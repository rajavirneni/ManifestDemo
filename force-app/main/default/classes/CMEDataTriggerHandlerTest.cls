@isTest
private class CMEDataTriggerHandlerTest {
	
	@isTest static void cmeDataTest() {

		Lead l = new Lead();
		l.Company = 'Test Company';
		l.Email = 'LeadEmail@Test.com';
		l.LastName = 'TestLastName';

		insert l;

		Account acc = new Account();
		acc.Name ='testAcc';
		insert acc;

		Contact con = new Contact();
		con.LastName = 'LastName';
		con.Email = 'ConEmail@Test.com';
		con.AccountId = acc.Id;

		insert con;

		list<cme_data__c> cmeList = new list<cme_data__c>();

		cme_data__c cmed = new cme_data__c();
		cmed.Email__c = 'LeadEmail@Test.com';
		cmed.Info_Source_Id__c = 'ABC1234';
		cmeList.add(cmed);

		cme_data__c cmed1 = new cme_data__c();
		cmed1.Email__c = 'ConEmail@Test.com';
		cmed1.Info_Source_Id__c = 'DEF1234';
		cmeList.add(cmed1);

		cme_data__c cmed2 = new cme_data__c();
		cmed2.Email__c = 'Con2Email@Test.com';
		cmed2.Info_Source_Id__c = 'XYZ1234';
		cmeList.add(cmed2);

		insert cmeList;
		
		// Implement test code
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}