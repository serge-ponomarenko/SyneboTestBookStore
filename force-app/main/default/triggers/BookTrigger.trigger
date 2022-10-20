trigger BookTrigger on Book__c (before update, before insert) {
    
    BookTriggerHandler.validateDiscount(Trigger.New);
    
}