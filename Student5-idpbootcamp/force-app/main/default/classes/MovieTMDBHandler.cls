public with sharing class MovieTMDBHandler extends AbstractMovieHandler {

    public static void execute(List<Movie__c> newMovies, Map<Id, Movie__c> oldMoviesMap, Boolean isInsert, Boolean isUpdate) {
        try {
            if (TriggerControl.getMovieSettings()) {
                List<Movie__c> moviesNeedingUpdate = NecessaryMovies.getMoviesToUpdate(newMovies, oldMoviesMap, isInsert, isUpdate);

                if (!moviesNeedingUpdate.isEmpty()) {
                    MovieTMDBService.prepareMovieObject(moviesNeedingUpdate);
                }
            }
        } catch (System.AsyncException ex) {
            System.debug('Error: ' + ex.getMessage() + ' -- ' + 'If exception appears after usage of search component, that\'s okay.');
        }
    }
}