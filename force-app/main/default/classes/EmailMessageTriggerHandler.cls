public with sharing class EmailMessageTriggerHandler {
	public EmailMessageTriggerHandler() {
		
	}

	/*
	Method that takes the inserted email messages
	iterates through them and if the email message is incoming (coming to salesforce) and the length of Email body Exceeds 32K,
	creates a case feed item with a message displaying the length of email body (both html& text)
	*/
	public static void postMessageToChatter(map<Id,EmailMessage> newEmailMap, map<Id,EmailMessage> oldEmailMap) {
        list<Id> emailMessIdList = new List<Id>();
        list<Id> parentIdList = new List<Id>();
        system.debug('@@@@@@@@@newEmailMap Values Length@@@@@'+ newEmailMap.Values());
		for(EmailMessage em : newEmailMap.Values()) {
            system.debug('@@@@@@@@@EMailMEssage Length@@@@@'+em.TextBody.Length());
			if(em.Incoming == true && ((em.HTMLBody != null && em.HTMLBody.Length() >= 120000) || (em.TextBody != null && em.TextBody.Length() >= 120000))) {
                emailMessIdList.add(em.Id);
                parentIdList.add(em.ParentId);
				/*system.debug('@@@@@@@@@EMailMEssage Length@@@@@'+em.HTMLBody.Length());
				system.debug('@@@@@@@@@EMailMEssage Length@@@@@'+em.TextBody.Length());
				FeedItem cf = new FeedItem();
				cf.Body = 'An Email has been received with a HTMLBody of Length : '+ em.HTMLBody.Length()+ ' and TextBody of Length : '+em.TextBody.Length();
				cf.ParentId = em.ParentId;
				cf.Type = 'TextPost';
				newCaseFeedList.add(cf);*/
			}
		}
		if(emailMessIdList != null && emailMessIdList.size() > 0) {
			//insert newCaseFeedList;
			postAsyncMessages(parentIdList,emailMessIdList);
		}
	}
    
    @future
    public static void postAsyncMessages(list<Id> parentIdList, list<Id> emailMessList) {
        system.debug('@@@@@@ EMail Mess List@@@@@@@@'+emailMessList);
        list<EmailMessage> emList = [select id,parentId,HtmlBody,TextBody 
                                     		from EmailMessage
                                    		where Id IN: emailMessList];
        
        list<FeedItem> newCaseFeedList = new list<FeedItem>();
        for(EmailMessage em : emList) {
            FeedItem cf = new FeedItem();
			cf.Body = 'An Email has been received with a HTMLBody of Length : ' + em.HtmlBody.length() + ' and TextBody of Length : '+em.TextBody.Length();
			cf.ParentId = em.ParentId;
			cf.Type = 'TextPost';
			newCaseFeedList.add(cf);
        }
        
        if(newCaseFeedList != null && newCaseFeedList.size() >0) {
            insert newCaseFeedList;
        }
    }
}