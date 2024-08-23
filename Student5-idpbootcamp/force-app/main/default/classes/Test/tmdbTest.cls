@IsTest
public class tmdbTest {

    @IsTest
    static void testGenreList_Positive() {
        TmdbHttpMock mock = new TmdbHttpMock(true);
        Test.setMock(HttpCalloutMock.class, mock);

        tmdb tmdbInstance = new tmdb();
        tmdbGenreListResponse response = tmdbInstance.genreList();
		System.debug(response);
        System.assertNotEquals(null, response, 'Expected a valid response from genreList method.');
        System.assertEquals(2, response.genres.size(), 'Expected 2 genres in the response.');
    }

    @IsTest
    static void testGenreList_Negative() {
        	TmdbHttpMock mock = new TmdbHttpMock(false);
        	Test.setMock(HttpCalloutMock.class, mock);
        
            tmdb tmdbInstance = new tmdb();
            tmdbGenreListResponse response = tmdbInstance.genreList();
            System.debug(response);
			System.assertEquals(null, response.genres, 'Expected the page field to be null due to an error in the API response.');
    }

    @IsTest
    static void testSearchTrailer_Positive() {
        TmdbHttpMock mock = new TmdbHttpMock(true);
        Test.setMock(HttpCalloutMock.class, mock);

        TrailerDetails trailerDetails = tmdb.searchTrailer('123');
        System.debug(trailerDetails);
        System.assertNotEquals(null, trailerDetails, 'Expected a valid response from searchTrailer method.');
    }

    @IsTest
    static void testSearchTrailer_Negative() {
        	TmdbHttpMock mock = new TmdbHttpMock(false);
        	Test.setMock(HttpCalloutMock.class, mock);

            TrailerDetails trailerDetails = tmdb.searchTrailer('123');
            System.debug(trailerDetails);
        	System.assertEquals(null, trailerDetails.id, 'Expected the page field to be null due to an error in the API response.');
    }

    @IsTest
    static void testSearchMovie_Positive() {
        TmdbHttpMock mock = new TmdbHttpMock(true);
        Test.setMock(HttpCalloutMock.class, mock);

        tmdbSearchMovieResponse movieResponse = tmdb.searchMovie('Inception');
        System.debug(movieResponse);
        System.assertNotEquals(null, movieResponse, 'Expected a valid response from searchMovie method.');
        System.assertEquals('Inception', movieResponse.results[0].title, 'Expected the movie title to be "Inception".');
    }

    @IsTest
    static void testSearchMovie_Negative() {
        TmdbHttpMock mock = new TmdbHttpMock(false);
        Test.setMock(HttpCalloutMock.class, mock);
        tmdbSearchMovieResponse movieResponse = tmdb.searchMovie('Inception');
        System.debug(movieResponse);
        System.assertEquals(null, movieResponse.page, 'Expected the page field to be null due to an error in the API response.');
    }

    @IsTest
    static void testGetMovieDetails_Positive() {
        TmdbHttpMock mock = new TmdbHttpMock(true);
        Test.setMock(HttpCalloutMock.class, mock);

        tmdbMovieDetails movieDetails = tmdb.getMovieDetails('123');
        System.debug(movieDetails);
        System.assertNotEquals(null, movieDetails, 'Expected a valid response from getMovieDetails method.');
        System.assertEquals('Inception', movieDetails.title, 'Expected the movie title to be "Inception".');
    }

    @IsTest
    static void testGetMovieDetails_Negative() {
        	TmdbHttpMock mock = new TmdbHttpMock(false);
        	Test.setMock(HttpCalloutMock.class, mock);

            tmdbMovieDetails movieDetails = tmdb.getMovieDetails('123');
            System.debug(movieDetails);
			System.assertEquals(null, movieDetails.title, 'Expected movie title to be null');
    }
}