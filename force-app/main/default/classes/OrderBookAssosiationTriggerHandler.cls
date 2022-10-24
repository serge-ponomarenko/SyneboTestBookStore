public with sharing class OrderBookAssosiationTriggerHandler {
  public static void updateCustomerTotalBookBought(
    List<OrderBookAssosiation__c> obaNewList,
    Map<Id, OrderBookAssosiation__c> obaOldMap
  ) {
    Map<Id, Integer> ids = new Map<Id, Integer>();
    List<OrderBookAssosiation__c> iterateList = obaNewList;
    // For Delete Case
    if (obaNewList == null)
      iterateList = obaOldMap.values();

    for (OrderBookAssosiation__c oba_i : iterateList) {
      Integer delta = (Integer) oba_i.Quantity__c;

      // Proceed Update case only if Quantity changed
      if (
        obaNewList != null &&
        obaOldMap != null &&
        !obaOldMap.isEmpty() &&
        obaOldMap.containsKey(oba_i.Id)
      ) {
        if (obaOldMap.get(oba_i.Id).Quantity__c != oba_i.Quantity__c) {
          delta = (Integer) (oba_i.Quantity__c -
          obaOldMap.get(oba_i.Id).Quantity__c);
          // If Count_On_Total_Customer_s_Purchases__c also changed
          if (
            obaOldMap.get(oba_i.Id).Count_On_Total_Customer_s_Purchases__c !=
            oba_i.Count_On_Total_Customer_s_Purchases__c
          ) {
            if (!oba_i.Count_On_Total_Customer_s_Purchases__c) {
              // If it equals false then put old Quantity
              delta = (Integer) -obaOldMap.get(oba_i.Id).Quantity__c;
            } else {
              // If it equals true then put New Quantity
              delta = (Integer) oba_i.Quantity__c;
            }
            ids.put(oba_i.Order__c, delta);
          } else {
            // If Count_On_Total_Customer_s_Purchases not changed then chek if it equals true and put delta
            if (oba_i.Count_On_Total_Customer_s_Purchases__c)
              ids.put(oba_i.Order__c, delta);
          }
          // Proceed if only Count_On_Total_Customer_s_Purchases changed
        } else if (
          obaOldMap.get(oba_i.Id).Count_On_Total_Customer_s_Purchases__c !=
          oba_i.Count_On_Total_Customer_s_Purchases__c
        ) {
          if (!oba_i.Count_On_Total_Customer_s_Purchases__c)
            delta = -delta;
          ids.put(oba_i.Order__c, delta);
        }
      }
      // Proceed insert case
      if (
        obaOldMap == null &&
        oba_i.Count_On_Total_Customer_s_Purchases__c == true
      ) {
        ids.put(oba_i.Order__c, delta);
      }
      // Proceed delete case
      if (
        obaNewList == null &&
        oba_i.Count_On_Total_Customer_s_Purchases__c == true
      ) {
        ids.put(oba_i.Order__c, -delta);
      }
    }

    List<Customer> customers = [
      SELECT Id, (SELECT Id FROM Orders__r), Total_Books_Ordered__c
      FROM Customer
      WHERE Id IN (SELECT Customer__c FROM Order__c WHERE Id IN :ids.keySet())
    ];

    List<Order__c> orders = [
      SELECT Id, Customer__c
      FROM Order__c
      WHERE Id IN :ids.keySet()
    ];

    Map<Customer, Integer> mapCQ = new Map<Customer, Integer>();

    for (Customer customer_i : customers) {
      if (customer_i.Total_Books_Ordered__c == null) {
        customer_i.Total_Books_Ordered__c = 0;
      }
      for (Order__c order_i : orders) {
        if (order_i.Customer__c == customer_i.Id) {
          mapCQ.put(customer_i, ids.get(order_i.Id));
        }
      }
    }

    if (!mapCQ.isEmpty()) {
      for (Customer customer_i : mapCQ.keySet()) {
        customer_i.Total_Books_Ordered__c += mapCQ.get(customer_i);
      }
      update new List<Customer>(mapCQ.keySet());
    }
  }
}
