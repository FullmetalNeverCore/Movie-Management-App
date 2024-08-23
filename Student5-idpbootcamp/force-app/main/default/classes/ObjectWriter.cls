public class ObjectWriter {
    public static void updatingEntries(Map<Id, tmdbMovieDetails> movMap) {
        List<Movie__c> finalMovieList = new List<Movie__c>();
        List<Contact> allContactsToInsert = new List<Contact>();
        List<Cast__c> allCastsToInsert = new List<Cast__c>();
    
        for (Id movId : movMap.keySet()) 
        {	
            Movie__c movie = MovieDataPreparer.prepareMovie(movId, movMap.get(movId));
            finalMovieList.add(movie);
            
            //trying to handle addition of casts,if enabled no poster will be available
            ContactManager cman = new ContactManager(movMap.get(movId).credits.actors);
            List<Contact> contacts = cman.createContacts();
            allContactsToInsert.addAll(contacts);
    
            List<String> contactListNames = cman.createContactNamesList(); 
            Map<String, List<tmdbMovieDetails.Actor>> actorMap = cman.createActorMap();
            if (!allContactsToInsert.isEmpty()) {
                cman.insertContacts(allContactsToInsert); //inserting contacts
            }

            CastManager castMan = new CastManager(movMap.get(movId).credits.actors, contactListNames, movie);
            castMan.wipeExistingCasts();
            List<Cast__c> cList = castMan.createCast(actorMap);
            allCastsToInsert.addAll(cList);

            if (!allCastsToInsert.isEmpty()) {
                castMan.insertCast(allCastsToInsert);
            }
        }
    

        try {
            if (!finalMovieList.isEmpty()) {
                update finalMovieList;
            }
        } catch (DmlException e) {
            System.debug('Error during DML operation: ' + e.getMessage());
        }
    
    }
    
    
    public static void insertInBatches(List<Movie__c> records, Integer batchSize) {
        Integer totalSize = records.size();

        JSONBatchInsert.insertInBatches(records, batchSize);
    }
}