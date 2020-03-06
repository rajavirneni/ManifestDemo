public with sharing class OpportunityBannerController {
    @auraEnabled
    public static Boolean getProdcutsCount(Id opportunityId){
        system.debug('@@@@@@ Opportunity Id@@@@@@@@'+opportunityId);
        if(opportunityId != null) {
            //Checking to see if the Opportunity has Oppotunity category as revenue & recordtype of CME sales
            List<Opportunity> oppList = [select id,Name,CreatedDate from Opportunity 
                                         				where Id =: opportunityId];
            
            if(oppList != null && oppList.size() > 0) {
                //When an opportunity is created and redirected to the detail page, Products Missing warning notification is presented
                //Getting the difference in seconds between opportunity created date and current time
                //This is done to make sure the Notification is not shown to the newly created opportunities
                Long D1 = oppList[0].createdDate.getTime();
                Long D2 = system.Now().getTime();
                Long diffTime = (D2 - D1)/1000;
                list<OpportunityLineItem> oppProductsList = [select id from OpportunityLineItem where OpportunityId  =: opportunityId];
                //If the Opportunity has products or if the opporutnity is newly created, notification is not shown
                //else notification will be shown
                if((oppProductsList != null && oppProductsList.size() > 0) || diffTime < 20) {
                    return true;
                }
                else {
                    return false;
                }	
            }
        }
        return true;
    }
}