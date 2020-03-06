({
	createAccount: function() {
        var createRecordEvent = $A.get('e.force:createRecord');
        if ( createRecordEvent ) {
            createRecordEvent.setParams({
                'entityApiName': 'Account',
                'recordtypeId' : '0121a000000F24S',
                'defaultFieldValues': {
                    'Type' : 'Prospect',
                    'Industry' : 'Apparel',
                    'Rating' : 'Hot',
                    'Name' : 'RajTestAcc'
                }
            });
            createRecordEvent.fire();
        }
    }
})