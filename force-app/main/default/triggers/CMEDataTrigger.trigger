trigger CMEDataTrigger on cme_data__c (
	after insert, 
	after update, 
	after delete) {

		if (Trigger.isAfter) {
	    	//call handler.after method
	    	If(Trigger.isInsert) 
	    		CMEDataTriggerHandler.insertCMEData(trigger.newMap);
	    	else if(Trigger.isUpdate)
	    		CMEDataTriggerHandler.updateCMELoginData(trigger.new, trigger.oldMap);
		}
}