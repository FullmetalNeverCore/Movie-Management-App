public class MovieMapper {
    
    private GenreValidation validation = new GenreValidation();
    
    private String getBaseImageUrl()
    {
        String baseUrl;
        String posterSize;

        tmdbImageDetails imageDetails = tmdb.getImageDetails();

        try
        {
            baseUrl = imageDetails.images.base_url;
            posterSize = 'original';  
            return baseUrl+posterSize;          
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage());
            System.debug('Was unable to obtain tmdb base image hosting url.');
        }
        return '';
    }
    
    public Movie__c mapMovie(Id movieId, tmdbMovieDetails movieDetails) {


        if(movieDetails == null) 
        {
            throw new NoMovieDetailsException('movieDetails strucutre was null.');
        }

        Movie__c movie = new Movie__c();

        try
        {
         validation.loadValidGenres();   
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage());
        }
        

        movie.Id = movieId;
        movie.TMDBID__c = String.valueOf(movieDetails.id);
        movie.Title__c = movieDetails.original_title;
        movie.Description__c = movieDetails.overview;
        movie.Revenue__c = movieDetails.revenue;
        movie.Budget__c = movieDetails.budget;
        movie.Poster_URL__c = getBaseImageUrl()+movieDetails.poster_path;
        movie.Rating__c = movieDetails.vote_average;
        movie.Release_Date__c = Date.valueOf(movieDetails.release_date);
        try
        {
            movie.Genre__c = validation.validateGenres(madeGenreString(new List<tmdbMovieDetails>{movieDetails}));
        }        
        catch(Exception ex){
            System.debug(ex.getMessage());
            System.debug('Genre insertion failed.');
        }
        return movie;
    }
    
    public String madeGenreString(List<tmdbMovieDetails> tmdbMovies) 
    {
        List<String> genreNamesList = new List<String>();
        
        if (tmdbMovies != null && !tmdbMovies.isEmpty()) {
            for (tmdbMovieDetails movie : tmdbMovies) {
                if (movie.genres != null && !movie.genres.isEmpty()) {
                    for (tmdbMovieDetails.Genre genre : movie.genres) {
                        genreNamesList.add(genre.name.trim());
                    }
                }
            }
        }
    
        return genreNamesList.isEmpty() ? null : String.join(genreNamesList, ';');
    }
}