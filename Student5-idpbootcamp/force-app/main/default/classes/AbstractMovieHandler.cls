public virtual class AbstractMovieHandler implements ITriggerHandler {

    public static List<Movie__c> newMovies;
    public static Map<Id, Movie__c> oldMoviesMap;
    public static Boolean isInsert;
    public static Boolean isUpdate;

    public void handle() {
        newMovies = Trigger.new;
        isInsert = Trigger.isInsert;
        isUpdate = Trigger.isUpdate;

        if (Trigger.isBefore || Trigger.isAfter) {
            oldMoviesMap = (Map<Id, Movie__c>)Trigger.oldMap;
        }
        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) doBeforeInsert();
            else if (Trigger.isUpdate) doBeforeUpdate();
            else if (Trigger.isDelete) doBeforeDelete();
        } else if (Trigger.isAfter) {
            if (Trigger.isInsert) doAfterInsert();
            else if (Trigger.isUpdate) doAfterUpdate();
            else if (Trigger.isDelete) doAfterDelete();
        }
    }

    public virtual void doBeforeInsert() { /* Do nothing */ }
    
    public virtual void doAfterInsert() { 
        MovieTMDBHandler.execute(newMovies, oldMoviesMap, isInsert, isUpdate);
    }
    
    public virtual void doBeforeUpdate() { 
        MovieTMDBHandler.execute(newMovies, oldMoviesMap, isInsert, isUpdate);
    }
    
    public virtual void doAfterUpdate() { /* Do nothing */ }
    
    public virtual void doBeforeDelete() { /* Do nothing */ }
    
    public virtual void doAfterDelete() { /* Do nothing */ }
}