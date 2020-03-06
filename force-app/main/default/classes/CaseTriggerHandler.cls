public with sharing class CaseTriggerHandler {
	public CaseTriggerHandler() {
		
	}

	public static void updateChildCasesToResolve(map<Id,Case> newCaseMap, map<Id,Case> oldCaseMap) {

		set<Id> caseIdSet = new set<Id>();
		list<Case> updateChildCaseList = new list<Case>();

		//Checking to only see if the case has been set to resolved and no other update to the case is considered
		for(Case cas : newCaseMap.Values()) {
			if(cas.Status == 'Closed' && cas.Status != oldCaseMap.get(cas.Id).Status) {
				caseIdSet.add(cas.Id);
			}
		}

		//Querying all the child cases in the system for the closed cases
		for(Case c : [select id,status,ParentId from Case where parentId IN: caseIdSet] ) {
			c.Status = 'Closed';
			updateChildCaseList.add(c);
		}

		//updating all child cases to resolved
		if(updateChildCaseList != null && updateChildCaseList.size() > 0) {
			List<Database.SaveResult> lsr = Database.update(updateChildCaseList,false);
			//looping through the save results and if there is an error
			//capturing the error and displaying it to the parent case record
			for(Integer i=0;i<lsr.size();i++){
                if (!lsr[i].isSuccess()){
                    Database.Error error = lsr.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    Id parentCaseId = updateChildCaseList[i].parentId;
                    newCaseMap.get(parentCaseId).addError('There is an Error while Resolving Child Cases for this Case. Please ensure child cases are complete before closure : '+failedDML);
                }
            }
        }
	}
}