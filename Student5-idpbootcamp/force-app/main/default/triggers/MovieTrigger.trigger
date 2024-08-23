trigger MovieTrigger on Movie__c (after insert, before update) {
    AbstractMovieHandler handler = new MovieTMDBHandler(); 
    handler.handle();
}
