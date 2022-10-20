public with sharing class OrderBookAssosiationTriggerHandler {

    public static void updateCustomerTotalBookBought(List<OrderBookAssosiation__c> obaList) {
        Set<Id> ids = new Set<Id>();
        for (OrderBookAssosiation__c oba_i : obaList) {
          ids.add(oba_i.Order__c);
        }
      
        List<Customer> customers = [    
          SELECT Id
          FROM Customer
          WHERE Id IN (SELECT Customer__c FROM Order__c WHERE Id IN :ids)
        ];
      
        for (Customer c : customers) {
          List<OrderBookAssosiation__c> ordersBooks = [
            SELECT Id, Quantity__c
            FROM OrderBookAssosiation__c
            WHERE Order__c IN (SELECT Id FROM Order__c WHERE Customer__c = :c.Id)
          ];
      
          Decimal total = 0;
          for (OrderBookAssosiation__c order_i : ordersBooks) {
            total += order_i.Quantity__c;
          }
          c.Total_Books_Ordered__c = total;
        }
      
        if (!customers.isEmpty()) {
          update customers;
        }
    }

}
