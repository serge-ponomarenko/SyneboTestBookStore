trigger OrderBookAssosiationTrigger on OrderBookAssosiation__c(
  after insert,
  after update,
  after delete,
  after Undelete
) {

  if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isUnDelete)) {
    OrderBookAssosiationTriggerHandler.updateCustomerTotalBookBought(Trigger.New);
  } 
  else if(Trigger.isAfter && Trigger.isDelete) {
    OrderBookAssosiationTriggerHandler.updateCustomerTotalBookBought(Trigger.Old);
  }

}