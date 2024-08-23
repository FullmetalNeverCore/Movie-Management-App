@isTest
private class JSONBatchInsertTest {
    @isTest
    static void testBatchInsertSuccess() {
    
        List<Movie__c> moviesToInsert = new List<Movie__c>{
            new Movie__c(Title__c = 'Movie 1', Release_Date__c = Date.today()),
            new Movie__c(Title__c = 'Movie 2', Release_Date__c = Date.today().addDays(1)),
            new Movie__c(Title__c = 'Movie 3', Release_Date__c = Date.today().addDays(2))
        };
        
      
        JSONBatchInsert batch = new JSONBatchInsert(moviesToInsert);

 
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

     
        List<Movie__c> insertedMovies = [SELECT Id, Title__c FROM Movie__c WHERE Title__c IN ('Movie 1', 'Movie 2', 'Movie 3')];
        System.assertEquals(3, insertedMovies.size(), 'Expected 3 movies to be inserted.');
    }


    @isTest
    static void testBatchInsertDMLException() {
  
        List<Movie__c> moviesToInsert = new List<Movie__c>{
            new Movie__c(Title__c = 'Movie 4', Release_Date__c = Date.today())
        };

        JSONBatchInsert batch = new JSONBatchInsert(moviesToInsert);

   
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

    }
}