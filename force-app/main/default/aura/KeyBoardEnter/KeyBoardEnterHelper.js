({
	submitForm: function(component) {
		var firstName = component.find('firstName').get('v.value'),
			lastName = component.find('lastName').get('v.value'),
			toastEvent = $A.get("e.force:showToast");
	    toastEvent.setParams({
    		title: 'Welcome ',
    		message: firstName + ' ' + lastName + '!'
	    });
	    toastEvent.fire();
	}
})