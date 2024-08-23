@isTest
public with sharing class MovieDataPreparerTest {
    
    @isTest
    static void testPrepareMovieJson() {
        
        JsonMovieData.Movie movie1 = new JsonMovieData.Movie();
        movie1.id = '1';
        movie1.name = 'The Matrix';
        movie1.tmdb_id = 'tt0133093';
        movie1.genre = 'Sci-Fi;Action';
        movie1.rating = 8.7;
        movie1.budget = 63000000;
        movie1.actual_budget = 65000000;
        movie1.revenue = 463517383;
        movie1.release_date = '03/31/1999';
        movie1.status = 'Released';

        movie1.script = new JsonMovieData.Script();
        movie1.script.id = '101';
        movie1.script.name = 'The Matrix Script';
        movie1.script.description = 'A dystopian science fiction script';

        List<JsonMovieData.Movie> movieData = new List<JsonMovieData.Movie>();
        movieData.add(movie1);

     
        Test.startTest();
        List<Movie__c> movies = MovieDataPreparer.prepareMovieJson(movieData);
        Test.stopTest();

 
        System.assertEquals(1, movies.size(), 'There should be 1 movie prepared');
        Movie__c movie = movies[0];
        System.assertEquals('The Matrix', movie.Title__c, 'Title should be set correctly');
        System.assertEquals('tt0133093', movie.TMDBID__c, 'TMDB ID should be set correctly');
        System.assertEquals('Sci-Fi;Action', movie.Genre__c, 'Genre should be set correctly');
        System.assertEquals(8.7, movie.Rating__c, 'Rating should be set correctly');
        System.assertEquals(63000000, movie.Budget__c, 'Budget should be set correctly');
        System.assertEquals(463517383, movie.Revenue__c, 'Revenue should be set correctly');
        System.assertEquals(Date.newInstance(1999, 3, 31), movie.Release_Date__c, 'Release Date should be set correctly');
        
       
       

        
        System.assertEquals(Date.today(), movie.TMDBSyncDate_c__c, 'TMDBSyncDate_c__c should be set to today’s date');
    }
    
    @isTest
    static void testPrepareMovieJsonNoData() {
        
        JsonMovieData.Movie movie1 = new JsonMovieData.Movie();
        movie1.id = null;
        movie1.name = null;
        movie1.tmdb_id = null;
        movie1.genre = 'Sci-Fi;Action';
        movie1.rating = 8.7;
        movie1.budget = 63000000;
        movie1.actual_budget = 65000000;
        movie1.revenue = 463517383;
        movie1.release_date = '03/31/1999';
        movie1.status = 'Released';

        movie1.script = new JsonMovieData.Script();
        movie1.script.id = null;
        movie1.script.name = null;
        movie1.script.description = null;

        List<JsonMovieData.Movie> movieData = new List<JsonMovieData.Movie>();
        movieData.add(movie1);

     
        Test.startTest();
        try
        {
            List<Movie__c> movies = MovieDataPreparer.prepareMovieJson(movieData);
        }
        catch(System.NullPointerException ex)
        {
            System.debug('NullPointer fired!');
        }
        Test.stopTest();

    }
}