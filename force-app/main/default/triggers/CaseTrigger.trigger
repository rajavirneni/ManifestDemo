trigger CaseTrigger on Case (after update) {
	CaseTriggerHandler.updateChildCasesToResolve(trigger.newMap, trigger.oldMap);
}