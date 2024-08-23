@isTest
public class MovieDataHandlerTest {

        @isTest
        static void testPrepareMovie() 
        {
          
            tmdbMovieDetails testMovieDetails = new tmdbMovieDetails();
            testMovieDetails.original_title = 'Fight Club';
            testMovieDetails.overview = 'A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground "fight clubs" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.';
            testMovieDetails.revenue = 100853753;
            testMovieDetails.budget = 63000000;
            testMovieDetails.poster_path = '/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg';
            testMovieDetails.vote_average = 8.433;
            testMovieDetails.release_date = '1999-10-15';
    
           
            Movie__c mov = new Movie__c();
            
            mov.TMDBID__c = '999';
     
    		
            System.debug(mov.Id);
        
            Movie__c movie = MovieDataPreparer.prepareMovie(mov.Id, testMovieDetails);
    
        
            System.assertEquals(mov.Id, movie.Id, 'The movie Id should be set correctly.');
            System.assertEquals(testMovieDetails.original_title, movie.Title__c, 'The Title__c should be set correctly.');
            System.assertEquals(testMovieDetails.overview, movie.Description__c, 'The Description__c should be set correctly.');
            System.assertEquals(testMovieDetails.revenue, movie.Revenue__c, 'The Revenue__c should be set correctly.');
            System.assertEquals(testMovieDetails.budget, movie.Budget__c, 'The Budget__c should be set correctly.');
            System.assertEquals(testMovieDetails.poster_path, movie.Poster_URL__c, 'The Poster_URL__c should be set correctly.');
            System.assertEquals(testMovieDetails.vote_average, movie.Rating__c, 'The Rating__c should be set correctly.');
            System.assertEquals(Date.valueOf(testMovieDetails.release_date), movie.Release_Date__c, 'The Release_Date__c should be set correctly.');
        }
    


    @isTest
    static void testHandleInsertEmptyMap() {
        Test.startTest();
        
   
        Map<Id, tmdbMovieDetails> movMap = new Map<Id, tmdbMovieDetails>();
        MovieDataHandler.handleInsert(movMap);
        
        Test.stopTest();
        
   
    }
    
    @isTest
    static void testHandleInsertRandomData() {
        Test.startTest();
        
        try
        {
            Map<Id, tmdbMovieDetails> movMap = new Map<Id, tmdbMovieDetails>{(Id)'test'=>new tmdbMovieDetails()};
        	MovieDataHandler.handleInsert(movMap);  
        }
		catch(System.StringException se)
        {
            System.debug('String Exception fired!');
        }
        
        try
        {
            Movie__c mov = new Movie__c();
            Map<Id, tmdbMovieDetails> movMap = new Map<Id, tmdbMovieDetails>{mov.Id=>new tmdbMovieDetails()};
        	MovieDataHandler.handleInsert(movMap);  
        }
		catch(System.NullPointerException np)
        {
            System.debug('Null Pointer fired!');
        }
        Test.stopTest();
        
   
    }

}