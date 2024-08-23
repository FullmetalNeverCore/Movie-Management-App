@isTest
public class JsonMovieDataTest {

    @isTest
    public static void testJsonMovieDataInitialization() {
        JsonMovieData jsonMovieData = new JsonMovieData();
        
 
        System.assertNotEquals(null, jsonMovieData, 'JsonMovieData instance should not be null');

      
        System.assertEquals(null, jsonMovieData.movies, 'Initial movies list should be null');
    }

    @isTest
    public static void testMovieInitialization() {
        JsonMovieData.Movie movie = new JsonMovieData.Movie();
        
   
        System.assertNotEquals(null, movie, 'JsonMovieData.Movie instance should not be null');
       
        System.assertEquals(null, movie.id, 'Default id should be null');
        System.assertEquals(null, movie.name, 'Default name should be null');
        System.assertEquals(null, movie.tmdb_id, 'Default tmdb_id should be null');
        System.assertEquals(null, movie.genre, 'Default genre should be null');
        System.assertEquals(null, movie.release_date, 'Default release_date should be null');
        System.assertEquals(null, movie.status, 'Default status should be null');
        System.assertEquals(null, movie.rating, 'Default rating should be null');
        System.assertEquals(null, movie.budget, 'Default budget should be null');
        System.assertEquals(null, movie.actual_budget, 'Default actual_budget should be null');
        System.assertEquals(null, movie.revenue, 'Default revenue should be null');
        System.assertEquals(null, movie.script, 'Default script should be null');
    }

    @isTest
    public static void testScriptInitialization() {
       
        JsonMovieData.Script script = new JsonMovieData.Script();
        

        System.assertNotEquals(null, script, 'JsonMovieData.Script instance should not be null');
        
   
        System.assertEquals(null, script.id, 'Default id should be null');
        System.assertEquals(null, script.name, 'Default name should be null');
        System.assertEquals(null, script.description, 'Default description should be null');
    }

    @isTest
    public static void testMovieAndScriptSettersAndGetters() {
     
        JsonMovieData.Movie movie = new JsonMovieData.Movie();
        movie.id = '1';
        movie.name = 'Inception';
        movie.tmdb_id = '12345';
        movie.genre = 'Science Fiction';
        movie.rating = 8.8;
        movie.budget = 160000000;
        movie.actual_budget = 150000000;
        movie.revenue = 829895144;
        movie.release_date = '2010-07-16';
        movie.status = 'Released';

        JsonMovieData.Script script = new JsonMovieData.Script();
        script.id = 'script1';
        script.name = 'Inception Script';
        script.description = 'A complex and multi-layered script';

        movie.script = script;
        
    
        System.assertEquals('1', movie.id);
        System.assertEquals('Inception', movie.name);
        System.assertEquals('12345', movie.tmdb_id);
        System.assertEquals('Science Fiction', movie.genre);
        System.assertEquals(8.8, movie.rating);
        System.assertEquals(160000000, movie.budget);
        System.assertEquals(150000000, movie.actual_budget);
        System.assertEquals(829895144, movie.revenue);
        System.assertEquals('2010-07-16', movie.release_date);
        System.assertEquals('Released', movie.status);
        System.assertNotEquals(null, movie.script);
        System.assertEquals('script1', movie.script.id);
        System.assertEquals('Inception Script', movie.script.name);
        System.assertEquals('A complex and multi-layered script', movie.script.description);
    }
}