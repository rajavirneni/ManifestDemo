({
	formPress: function(component, event, helper) {
		if (event.keyCode === 13) {
            //alert('keyboard Enter pressed');
			helper.submitForm(component);
		}
		//$A.log(event);
	},
	buttonPress: function(component, event, helper) {
		helper.submitForm(component);
	}
})