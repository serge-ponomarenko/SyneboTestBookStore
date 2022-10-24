trigger OrderBookAssosiationTrigger on OrderBookAssosiation__c(
  after insert,
  after update,
  after delete,
  after undelete
) {
  if (Trigger.isAfter) {
    if (Trigger.isInsert) {
      OrderBookAssosiationTriggerHandler.updateCustomerTotalBookBought(
        Trigger.New,
        null
      );
    }
    if (Trigger.isUpdate) {
      OrderBookAssosiationTriggerHandler.updateCustomerTotalBookBought(
        Trigger.New,
        Trigger.oldMap
      );
    }
    if (Trigger.isDelete) {
      OrderBookAssosiationTriggerHandler.updateCustomerTotalBookBought(
        null,
        Trigger.oldMap
      );
    }
  }
}
