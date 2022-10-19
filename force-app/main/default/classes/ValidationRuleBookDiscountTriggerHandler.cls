public class ValidationRuleBookDiscountTriggerHandler {
    
    public static void validate(List<Book__c> books) {
        for (Book__c book_i : books) {
            if (book_i.Discount_Percent__c > 30) {
                book_i.Discount_Percent__c = 30;
            }
        } 
    }
    
}