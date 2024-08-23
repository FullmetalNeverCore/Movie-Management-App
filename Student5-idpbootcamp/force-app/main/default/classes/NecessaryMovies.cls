public class NecessaryMovies
{
    public static List<Movie__c> getMoviesToUpdate(List<Movie__c> newMovies, Map<Id, Movie__c> oldMoviesMap, Boolean isInsert, Boolean isUpdate) 
    {
        List<Movie__c> moviesNeedingUpdate = new List<Movie__c>();

        for (Movie__c movie : newMovies) {
            Movie__c oldMovie = oldMoviesMap?.get(movie.Id);
            if (isInsert || (isUpdate && movie.TMDBID__c != oldMovie.TMDBID__c))
            {
                moviesNeedingUpdate.add(movie);
            }
        }
        
        return moviesNeedingUpdate;
    }
}