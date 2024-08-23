@isTest
public class MovieMapperTest {

    @isTest
    static void testMapMovieNegative_NullMovieDetails() {
    
        MovieMapper movieMapper = new MovieMapper();
        Movie__c newmov = new Movie__c(); 
        
        Id idmov = newmov.id;  

   
        Movie__c result = movieMapper.mapMovie(idmov, null);

 
        System.assertNotEquals(null, result);
        System.assertEquals(null, result.TMDBID__c);
        System.assertEquals(null, result.Title__c);
        System.assertEquals(null, result.Description__c);
        System.assertEquals(null, result.Revenue__c);
        System.assertEquals(null, result.Budget__c);
        System.assertEquals(null, result.Poster_URL__c);
        System.assertEquals(null, result.Rating__c);
        System.assertEquals(null, result.Release_Date__c);
        System.assertEquals(null, result.Genre__c);
    }


    @isTest
    static void testMadeGenreStringNegative_EmptyList() {
        MovieMapper movieMapper = new MovieMapper();
        
      
        String result = movieMapper.madeGenreString(new List<tmdbMovieDetails>());

      
        System.assertEquals(null, result);
    }

    @isTest
    static void testMadeGenreStringNegative_NullList() {
       
        MovieMapper movieMapper = new MovieMapper();

    
        String result = movieMapper.madeGenreString(null);

   
        System.assertEquals(null, result);
    }
}