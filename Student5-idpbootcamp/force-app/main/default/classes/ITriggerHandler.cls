public interface ITriggerHandler {
 
    void handle();
    
    void doBeforeInsert();
    
    void doAfterInsert();
    
    void doBeforeUpdate();
    
    void doAfterUpdate();
    
    void doBeforeDelete();
    
    void doAfterDelete(); 
}