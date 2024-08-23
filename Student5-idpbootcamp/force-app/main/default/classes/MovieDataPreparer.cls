public with sharing class MovieDataPreparer {
    
    public static Movie__c prepareMovie(Id movieId, tmdbMovieDetails movieDetails) {
        MovieMapper movieMapper = new MovieMapper();
        return movieMapper.mapMovie(movieId, movieDetails);
    }
    
    public static List<Movie__c> prepareMovieJson(List<JsonMovieData.Movie> movieData) {
        ScriptManager scriptManager = new ScriptManager();
        MovieManager movieManager = new MovieManager(scriptManager);
        
        scriptManager.processScripts(movieData);
        List<Movie__c> movies = movieManager.createMovies(movieData);
        
        return movies;
    }
}