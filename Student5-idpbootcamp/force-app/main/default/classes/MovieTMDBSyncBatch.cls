public class MovieTMDBSyncBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful 
{
    public Database.QueryLocator start(Database.BatchableContext BC) {
        
        return Database.getQueryLocator([
            SELECT Id, tmdbId__c, TMDBSyncDate_c__c
            FROM Movie__c 
            WHERE (TMDBSyncDate_c__c = NULL OR TMDBSyncDate_c__c < LAST_N_DAYS:30) 
            AND tmdbId__c != NULL
        ]);
    }
    
    public void execute(Database.BatchableContext BC, List<Movie__c> scope) {
        for (Movie__c movie : scope) {
           
            tmdbMovieDetails tmdbData = tmdb.getMovieDetails(movie.tmdbId__c);
            
            if (tmdbData != null) {
                
                movie.Revenue__c = tmdbData.revenue;
                movie.Rating__c = tmdbData.vote_average;
                movie.TMDBSyncDate_c__c = Date.today(); 
            }
        }
        
        update scope;
    }
    
    public void finish(Database.BatchableContext BC) {
      
    }
}