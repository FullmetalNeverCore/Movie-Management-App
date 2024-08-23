@isTest
public class ManagersTest {
	
   private static String jsonString {get;set;}
   private static ScriptManager sman;
   private static List<JsonMovieData.Movie> movieData {get;set;}

   @isTest
   public static void ScriptCreationTest()
   {
      StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
      mock.setStaticResource('FilmsLessHuge');
      mock.setStatusCode(200);
      mock.setHeader('Content-Type', 'application/json');
      Test.setMock(HttpCalloutMock.class, mock);
       
      HTTPResponse res = MockStaticResource.getInfoFromExternalService(
            'https://example.com/example/test');
      //System.debug(res.getBody());
      movieData = JsonMovieDataHandler.parsingJson(res.getBody().toString());
      sman = new ScriptManager();  //.processScripts(movies);
      sman.processScripts(movieData);
      Script__c script = [SELECT Id, Title__c, Description__c FROM Script__c LIMIT 1];
      System.assertNotEquals(null, script, 'A Script record should have been created.');
      System.assertEquals(movieData[0].script.name, script.Title__c, 'The title should match.');
   }
    
   @isTest
   public static void MovieCreationTest()
   {
       StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
       mock.setStaticResource('FilmsLessHuge');
       mock.setStatusCode(200);
       mock.setHeader('Content-Type', 'application/json');
       Test.setMock(HttpCalloutMock.class, mock);
       
       HTTPResponse res = MockStaticResource.getInfoFromExternalService(
            'https://example.com/example/test');
       //System.debug(res.getBody());
       movieData = JsonMovieDataHandler.parsingJson(res.getBody().toString());
       sman = new ScriptManager();  //.processScripts(movies);
       sman.processScripts(movieData);
       MovieManager mman = new MovieManager(sman); 
       System.debug(movieData);
       List<Movie__c> createdMovies = mman.createMovies(movieData);
       Movie__c firstMovie = createdMovies[0];
       System.assertEquals('Avatar', firstMovie.Title__c, 'First movie title should be "Avatar".');
       System.assertEquals('Action;Adventure;Fantasy', firstMovie.Genre__c, 'First movie genre should be "Action;Adventure;Fantasy;Science_Fiction".');
       System.assertEquals('19995',firstMovie.TMDBID__c,'TMDB ID supposed to be 19995');
       
   }
}