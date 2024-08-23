@isTest
public class MovieTMDBSyncBatchTest {
   
    
    @isTest
    static void testBatchExecution() {
                
        Test.setMock(HttpCalloutMock.class, new MockMovieDetails());
        DisableUpdateTrigger__c bypassSetting = DisableUpdateTrigger__c.getOrgDefaults();
        bypassSetting.UpdateTrigger__c = true;
        upsert bypassSetting;
      
        Test.startTest();
        List<Movie__c> movies = new List<Movie__c>{new Movie__c(Title__c = 'Movie 1', TMDBID__c = '101'),
            new Movie__c(Title__c = 'Movie 2', TMDBID__c = '102', TMDBSyncDate_c__c = Date.today().addDays(-60))
         };
        insert movies;

        MovieTMDBSyncBatch batch = new MovieTMDBSyncBatch();
        Database.executeBatch(batch);
        Test.stopTest();
		
        List<Id> ids = new List<Id>();

		for(Movie__c mov : movies)
        {
            ids.add(mov.Id);
        }

        List<Movie__c> updatedMovies = [SELECT Id,  Title__c,Revenue__c, Rating__c, TMDBSyncDate_c__c FROM Movie__c WHERE Id IN :ids];
        for (Movie__c movie : updatedMovies) {
            System.debug(movie.Title__c);
    
            System.assertNotEquals(null, movie.Revenue__c, 'Revenue should be updated');
            System.assertNotEquals(null, movie.Rating__c, 'Rating should be updated');
            System.assertEquals(Date.today(), movie.TMDBSyncDate_c__c, 'Sync date should be updated to today');
        }
    }
}