trigger ValidationRuleBookDiscount on Book__c (before update, before insert) {
    
    ValidationRuleBookDiscountTriggerHandler.validate(Trigger.New);
    
}