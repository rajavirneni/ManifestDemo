({
	getProductsCount : function(component, event, helper) {

		// Get a reference to the getWeather() function defined in the Apex controller
		var action = component.get("c.getProdcutsCount");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {  
            console.log('Raj Data',response.getReturnValue());
            var data = JSON.parse(response.getReturnValue());
            console.log('Raj JSON Data',data);
            if (response.getReturnValue() == false) {
               /*component.find('notifLib').showToast({
                    "title": "Opportunity Edit Warning",
                    "mode" : "dismissable",
                    "message": "You Cannot Edit the Opporutnity as it do not have products. Please have atleast 1 Product before editing an opportunity.",
                    "variant" : "error"
                });*/
               
                component.find('notifLib').showNotice({
                "variant": "info",
                "header": "Opportunity Edit Warning!",
                "message": "You Cannot Edit the Opporutnity as it do not have products. Please add atleast 1 Product before editing the opportunity",
                closeCallback: function() {
                    
                }
                });
                
               /* var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'dismissable',
                    message: 'You Cannot Edit the Opporutnity',
                    title : 'Opportunity Edit Warning',
                    type : 'error',
                    duration: 5000
                });
                toastEvent.fire()*/
            }
        });
        // Invoke the service
        $A.enqueueAction(action);
	}
})