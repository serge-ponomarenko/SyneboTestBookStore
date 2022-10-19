trigger ValidationRuleBookDiscount on Book__c (before update) {
    
    ValidationRuleBookDiscountTriggerHandler.validate(Trigger.New);
    
}