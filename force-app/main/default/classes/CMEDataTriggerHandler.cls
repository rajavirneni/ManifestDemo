public with sharing class CMEDataTriggerHandler {

	public static void insertCMEData(map<Id,cme_data__c> newCMEDataMap) {
		set<string> emailSet = new set<string>();
		map<string,cme_data__c> cmeDataMap = new map<string,cme_data__c>();

		for(cme_data__c cmd : newCMEDataMap.values()) {
			emailSet.add(cmd.Email__c);
			cmeDataMap.put(cmd.Email__c,cmd);
		}
		if(emailSet != null && emailSet.size() > 0) 
			syncLeadOrContact(emailSet, cmeDataMap);
	}

	public static void updateCMELoginData(list<cme_data__c> newCMEDataList, map<Id,cme_data__c> oldCMEDataMap) {

		set<string> emailSet = new set<string>();
		map<string,cme_data__c> cmeDataMap = new map<string,cme_data__c>();

		for(cme_data__c cmed : newCMEDataList) {
			//check if InfoSource is updated on existing CME records and only execute for those records
			if(cmed.Info_Source_Id__c != oldCMEDataMap.get(cmed.Id).Info_Source_Id__c) {
				emailSet.add(cmed.Email__c);
				cmeDataMap.put(cmed.Email__c,cmed);
			}
		}
		if(emailSet != null && emailSet.size() > 0) 
			syncLeadOrContact(emailSet, cmeDataMap);
	}
	
	public static void syncLeadOrContact(set<string> emailSet, map<string,cme_data__c> cmeDataMap  ) {

		list<Contact> updateContactList = new list<Contact>();
		list<Lead> updateLeadList = new list<Lead>();

		//Querying Contacts to find the matches
		list<Contact> existingContactList = [select id,Email from Contact where Email IN : emailSet];

		if(existingContactList != null && existingContactList.size() > 0) {
			for(contact con :  existingContactList) {
				//updating infosourceId
				con.phone = '3453453454';
				con.Info_Source_Id__c = cmeDataMap.get(con.Email).Info_Source_Id__c;
				updateContactList.add(con);
				//finally removing from CME data map 
				cmeDataMap.remove(con.Email);
			}
		}

		//Querying Leads for the remaining CME data records for which contacts are not found

		list<Lead> existingLeadList = [select id,Email from Lead where Email IN: cmeDataMap.KeySet()];

		if(existingLeadList != null && existingLeadList.size() > 0) {
			for(Lead lea :  existingLeadList) {
				//removing from CME data for the Lead match
				cmeDataMap.remove(lea.Email);
				//updating infosourceId
				lea.phone = '3453453454';
				updateLeadList.add(lea);
			}
		}

		if(cmeDataMap != null && cmeDataMap.size() > 0) {
			//creating new Leads for the remaining CME data for which NO Contact and Lead is found
			for(cme_data__c cmed : cmeDataMap.values()) {
				Lead l = new Lead();
				l.LastName = 'Dummy';
				l.Email = cmed.Email__c;
				l.Company = 'TestCompany';
				updateLeadList.add(l);
			}
		}

		//updating existing contacts for a matching CME data
		if(updateContactList != null && updateContactList.size() > 0) {
			update updateContactList;
		}

		//updating existing Leads for a matching CME data and creating new leads for no match CME data 
		if(updateLeadList != null && updateLeadList.size() > 0) {
			upsert updateLeadList;
		}
	}
	
}