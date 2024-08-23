@isTest
public class MovieControllerTest {

    @isTest
    static void testGetMovies() {

        List<Movie__c> movies = new List<Movie__c>();
        for (Integer i = 0; i < 10; i++) {
            movies.add(new Movie__c(
                Title__c = 'Test Movie ' + i,
                Genre__c = 'Action',
                Poster_URL__c = 'http://example.com/poster' + i
            ));
        }
        insert movies;

        List<Movie__c> result = MovieController.getMovies(0, 5);
        System.assertEquals(5, result.size(), 'Should return 5 movies');

        
        List<Movie__c> emptyResult = MovieController.getMovies(10, 5);
        System.assertEquals(0, emptyResult.size(), 'Should return 0 movies when offset exceeds available movies');
    }

    @isTest
    static void testGetMovie() {
        // Setup: Create a test movie
        Movie__c movie = new Movie__c(
            Title__c = 'Single Movie',
            Genre__c = 'Drama',
            Poster_URL__c = 'http://example.com/poster'
        );
        insert movie;

    
        List<Movie__c> result = MovieController.getMovie(movie.Id);
        System.assertEquals(1, result.size(), 'Should return 1 movie');
        System.assertEquals('Single Movie', result[0].Title__c, 'Returned movie title should match');

       
        List<Movie__c> emptyResult = MovieController.getMovie(Id.valueOf('001000000000001')); // Invalid ID
        System.assertEquals(0, emptyResult.size(), 'Should return 0 movies for invalid ID');
    }

    @isTest
    static void testReturnGenres() {

        List<Map<String, String>> genres = MovieController.returnGenres();
        System.assertNotEquals(0, genres.size(), 'Should return non-empty list of genres');
        
        
        Boolean found = false;
        for (Map<String, String> genre : genres) {
            if (genre.get('label') == 'Action') {
                found = true;
                break;
            }
        }
        System.assert(found, 'Should include Action genre in the list');
    }

    @isTest
    static void testSearchMoviesByGenre() {
        
        List<Movie__c> movies = new List<Movie__c>{
            new Movie__c(Title__c = 'Action Movie 1', Genre__c = 'Action'),
            new Movie__c(Title__c = 'Comedy Movie', Genre__c = 'Comedy')
        };
        insert movies;


        List<Movie__c> actionMovies = MovieController.searchMoviesByGenre('Action');
        System.assertEquals(1, actionMovies.size(), 'Should return 1 Action movie');

        List<Movie__c> noGenreMovies = MovieController.searchMoviesByGenre('Nonexistent Genre');
        System.assertEquals(0, noGenreMovies.size(), 'Should return 0 movies for nonexistent genre');
    }

    @isTest
    static void testSearchMoviesByTitle() {
      
        List<Movie__c> movies = new List<Movie__c>{
            new Movie__c(Title__c = 'The Great Adventure', Genre__c = 'Adventure'),
            new Movie__c(Title__c = 'Another Great Movie',  Genre__c = 'Drama')
        };
        insert movies;

   
        List<Movie__c> result = MovieController.searchMoviesByTitle('Great');
        System.assertEquals(2, result.size(), 'Should return 2 movies matching "Great"');

      
        List<Movie__c> noTitleMovies = MovieController.searchMoviesByTitle('Nonexistent Title');
        System.assertEquals(0, noTitleMovies.size(), 'Should return 0 movies for nonexistent title');
    }

    @isTest
    static void testSearchMovies() {

        List<Movie__c> movies = new List<Movie__c>{
            new Movie__c(Title__c = 'Action Adventure', Genre__c = 'Action'),
            new Movie__c(Title__c = 'Romantic Comedy', Genre__c = 'Romance')
        };
        insert movies;

        
        List<Movie__c> result = MovieController.searchMovies('Action', 'Adventure', null);
        System.assertEquals(1, result.size(), 'Should return 1 movie matching both genre and title');

       
        List<Movie__c> noResult = MovieController.searchMovies('Drama', 'Adventure', null);
        System.assertEquals(0, noResult.size(), 'Should return 0 movies for nonexistent genre and title');
    }
}