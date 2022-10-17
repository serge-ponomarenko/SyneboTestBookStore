trigger UpdateBookAuthors on BookAuthorAssociation__c (after insert, after update, after Undelete, after delete) {
    
    List<BookAuthorAssociation__c> tr;

    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isUnDelete)) {
        tr = Trigger.New;
    }
    
    if(Trigger.isAfter && Trigger.isDelete) {
        tr = Trigger.Old;  
    }
    
    if (tr != null) {
        for(BookAuthorAssociation__c baa : tr) {
            
            Id bookId = baa.Book__c;
            Book__c book = [SELECT Id FROM Book__c WHERE Id = :bookId];
        
            List<Author__c> authors = [SELECT Name FROM Author__c WHERE Id IN 
            (SELECT Author__c FROM BookAuthorAssociation__c WHERE Book__c = :bookId)];
            
            List<String> names = new List<String>();
            for(Author__c ac : authors) {
                names.add(ac.Name);
            }
            
            names.sort();
            book.Authors__c = String.join(names, ', ');
            
            update book;
        }
    }
}