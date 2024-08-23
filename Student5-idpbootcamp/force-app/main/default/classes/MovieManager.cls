public class MovieManager 
{
    private ScriptManager scriptManager;
    private Map<String, Movie__c> existingMoviesMap = new Map<String, Movie__c>();
    private Set<String> tmdbIds = new Set<String>();
    private GenreValidation validation = new GenreValidation();

    public MovieManager(ScriptManager scriptManager) {
        this.scriptManager = scriptManager;
        //System.debug('validation of genres');
        validation.loadValidGenres();
    }

    public List<Movie__c> createMovies(List<JsonMovieData.Movie> movieData) {
        extractTmdbIds(movieData);
        loadExistingMovies();
        List<Movie__c> movieContainer = new List<Movie__c>();
        
        for(JsonMovieData.Movie jsmovie : movieData) {
            if (!existingMoviesMap.containsKey(jsmovie.tmdb_id)) {
                Movie__c movie = mapJsonMovieToMovie(jsmovie);
                movieContainer.add(movie);
            }
        }
        return movieContainer;
    }

    private void extractTmdbIds(List<JsonMovieData.Movie> movieData) {
        for(JsonMovieData.Movie jsmovie : movieData) {
            tmdbIds.add(jsmovie.tmdb_id);
        }
    }

    private void loadExistingMovies() {
        for (Movie__c existingMovie : [SELECT Id, TMDBID__c FROM Movie__c WHERE TMDBID__c IN :tmdbIds]) {
            existingMoviesMap.put(existingMovie.TMDBID__c, existingMovie);
        }
    }

    private Movie__c mapJsonMovieToMovie(JsonMovieData.Movie jsmovie) {
        Movie__c movie = new Movie__c();
        movie.LegacyId__c = jsmovie.id;
        movie.Title__c = jsmovie.name;
        movie.TMDBID__c = jsmovie.tmdb_id;
        movie.Rating__c = jsmovie.rating; 
        movie.Budget__c = jsmovie.budget;
        movie.Revenue__c = jsmovie.revenue;
        movie.TMDBSyncDate_c__c = Date.today();
        movie.Release_Date__c = parseReleaseDate(jsmovie.release_date);
        movie.Genre__c = validation.validateGenres(jsmovie.genre);
        
        Script__c script = scriptManager.getScriptByLegacyId(jsmovie.script.id);
        if (script != null) {
            movie.Script__c = script.Id;
        }
        
        return movie;
    }

    private Date parseReleaseDate(String releaseDateStr) {
        List<String> dateParts = releaseDateStr.split('/');
        if (dateParts.size() == 3) {
            Integer month = Integer.valueOf(dateParts[0]);
            Integer day = Integer.valueOf(dateParts[1]);
            Integer year = Integer.valueOf(dateParts[2]);
            return Date.newInstance(year, month, day);
        }
        return null;
    }


}