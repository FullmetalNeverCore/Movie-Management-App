@isTest
public class MovieTriggerTest {

    @isTest
    static void testInsert() {
        Test.setMock(HttpCalloutMock.class, new MockMovieDetails());

        
        DisableUpdateTrigger__c bypassSetting = DisableUpdateTrigger__c.getOrgDefaults();
        bypassSetting.UpdateTrigger__c = true;
        upsert bypassSetting;

        Test.startTest();

      
        Movie__c mov = new Movie__c();
        mov.TMDBID__c = '550'; 

        insert mov;
		Test.stopTest();
    
        Movie__c movieToTest = [SELECT TMDBID__c, Title__c, Description__c, Revenue__c, Budget__c, Poster_URL__c, Rating__c, Release_Date__c, Genre__c FROM Movie__c WHERE Id = :mov.Id];
		
        
        System.assertNotEquals(null, movieToTest, 'Movie record should have been inserted.');
        System.assertEquals('Fight Club', movieToTest.Title__c, 'Title field should match the inserted value.');
        System.assertEquals('550', movieToTest.TMDBID__c, 'TMDBID__c field should match the inserted value.');
        System.assertEquals(100853753, movieToTest.Revenue__c, 'Revenue should match the mock response.');
        System.assertEquals(63000000, movieToTest.Budget__c, 'Budget should match the mock response.');
        System.assertEquals(8.433, movieToTest.Rating__c, 'Rating should match the mock response.');
        System.assertEquals(Date.valueOf('1999-10-15'), movieToTest.Release_Date__c, 'Release date should match the mock response.');
        System.assertEquals('Comedy;Drama;Thriller', movieToTest.Genre__c, 'Genre should match the mock response.');

        
    }    

    @isTest
    static void testFailedInsert() {
        Test.setMock(HttpCalloutMock.class, new MockMovieDetails());

      
        DisableUpdateTrigger__c bypassSetting = DisableUpdateTrigger__c.getOrgDefaults();
        bypassSetting.UpdateTrigger__c = true;
        upsert bypassSetting;

        Test.startTest();

    
        Movie__c mov = new Movie__c();
        mov.TMDBID__c = '';
        try {
            insert mov; 
  
            System.assert(false, 'Expected an exception to be thrown due to invalid TMDBID__c.');
        } catch (DmlException e) {
     
            System.assert(e.getMessage().contains('TMDBID__c cannot be empty'), 'Expected error message about empty TMDBID__c');
        }

      
        List<Movie__c> movies = [SELECT TMDBID__c, Title__c FROM Movie__c WHERE TMDBID__c = ''];
        System.assertEquals(0, movies.size(), 'No movie records should be inserted with empty TMDBID__c.');

        Test.stopTest();
    }
}