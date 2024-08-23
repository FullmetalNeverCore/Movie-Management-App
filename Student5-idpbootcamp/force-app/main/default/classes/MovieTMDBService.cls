public with sharing class MovieTMDBService {
    
    public static void prepareMovieObject(List<Movie__c> listmovie) {
        Map<String, String> moviemap = new Map<String, String>(); 
        for (Movie__c mov : listmovie) {
            if (String.isNotBlank(mov.TMDBID__c)) {
                moviemap.put((String)mov.Id, mov.TMDBID__c);
            }
        }
        pullTMDBData(moviemap);
    }
    
    @future(callout=true)
    public static void pullTMDBData(Map<String, String> movMap) {
        Map<Id, tmdbMovieDetails> moviesToUpdate = new Map<Id, tmdbMovieDetails>();
        for (String movId : movMap.KeySet()) {
            tmdbMovieDetails result = tmdb.getMovieDetails(movMap.get(movId));
            moviesToUpdate.put((Id)movId, result);
        }
        ObjectWriter.updatingEntries(moviesToUpdate); 
    }

    @AuraEnabled
    public static Boolean handleInsertionBySingleId(String movieId, String tmdbId) {
        try {
            
            DisableUpdateTrigger__c bypassSetting = DisableUpdateTrigger__c.getOrgDefaults();
            bypassSetting.UpdateTrigger__c = false;
            upsert bypassSetting;

            Map<String, String> idMap = new Map<String, String>{movieId => tmdbId};
            pullTMDBData(idMap);

            DisableUpdateTrigger__c returnSetting = DisableUpdateTrigger__c.getOrgDefaults();
            returnSetting.UpdateTrigger__c = true;
            upsert returnSetting;
            return true; 
        } catch (Exception ex) {
            return false; 
        }
    }

    @AuraEnabled
    public static String obtainTrailerLink(String tmdbId) {
        System.debug(tmdbId);
        TrailerDetails tdetails = tmdb.searchTrailer(tmdbId);
        
        if (tdetails != null && !tdetails.results.isEmpty()) {
            TrailerDetails.Result firstResult = tdetails.results[0];
            
            if (firstResult.site == 'YouTube') {
                return 'https://www.youtube.com/embed/' + firstResult.key + '?controls=1';
            }
        }
        return ''; 
    }
}