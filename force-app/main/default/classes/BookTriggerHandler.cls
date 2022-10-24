public class BookTriggerHandler {
  public static void validateDiscount(List<Book__c> books) {
    for (Book__c book_i : books) {
      if (book_i.Discount_Percent__c > 30) {
        book_i.Discount_Percent__c = 30;
      }
    }
  }
}
