global class UpdateCustomerTotalBookBought implements Database.Batchable<SObject>, Schedulable {
  global void execute(SchedulableContext SC) {
    UpdateCustomerTotalBookBought batch = new UpdateCustomerTotalBookBought();
    Database.executeBatch(batch);
  }

  public Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator('SELECT Id FROM Customer');
  }

  public void execute(Database.BatchableContext BC, List<SObject> scope) {
    List<OrderBookAssosiation__c> oba = [
      SELECT
        Id,
        Quantity__c,
        Count_On_Total_Customer_s_Purchases__c,
        Order__c,
        Order__r.Customer__c
      FROM OrderBookAssosiation__c
    ];

    for (SObject o : scope) {
      Customer c = (Customer) o;

      Integer total = 0;
      for (OrderBookAssosiation__c oba_i : oba) {
        if (
          oba_i.Order__r.Customer__c == c.Id &&
          oba_i.Count_On_Total_Customer_s_Purchases__c
        )
          total += (Integer) oba_i.Quantity__c;
      }
      c.Total_Books_Ordered__c = total;
    }

    update scope;
  }

  public void finish(Database.BatchableContext BC) {
    System.debug('Batch UpdateCustomerTotalBookBought completed.');
  }
}
