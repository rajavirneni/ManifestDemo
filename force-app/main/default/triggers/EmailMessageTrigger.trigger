trigger EmailMessageTrigger on EmailMessage (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		if (Trigger.isBefore) {
	    	//call your handler.before method
	    
		} else if (Trigger.isAfter && trigger.isInsert) {
	    	//call handler.after method
	    	EmailMessageTriggerHandler.postMessageToChatter(trigger.newMap, trigger.oldMap);
		}
}