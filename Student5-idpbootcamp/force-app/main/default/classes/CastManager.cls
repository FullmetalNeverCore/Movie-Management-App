public with sharing class CastManager 
{
    List<tmdbMovieDetails.Actor> mdetails;
    List<String> contactNames;
    Movie__c mov;

    public CastManager(List<tmdbMovieDetails.Actor> mdetails, List<String> contactNames,Movie__c mov) 
    {
        this.mdetails = mdetails; 
        this.contactNames = contactNames;
        this.mov = mov;
    }
    public void wipeExistingCasts() 
    {
        List<Cast__c> existingCasts = [SELECT Id FROM Cast__c WHERE Movie__c = :mov.Id];

 
        if (!existingCasts.isEmpty()) {
            delete existingCasts;
        } else {
            System.debug('No existing casts found for the movie.');
        }
    }

    public List<Contact> getAllNecessaryContacts()
    {
        if (contactNames.isEmpty()) {
            return new List<Contact>(); 
        }
        

        return [SELECT Id, FirstName, LastName FROM Contact WHERE Name IN :contactNames];
    }

    public List<Cast__c> createCast(Map<String, List<tmdbMovieDetails.Actor>> actorMap) {
        List<Cast__c> cList = new List<Cast__c>();
        
        List<Contact> getCont = getAllNecessaryContacts();
        
        for (Contact cont : getCont) {
            Cast__c member = new Cast__c();
            member.Actor__c = cont.Id; 
            member.Movie__c = mov.Id; 
            
           
            String fullName = cont.FirstName + ' ' + cont.LastName;
            
            List<tmdbMovieDetails.Actor> actorsForContact = actorMap.get(fullName);
        
            if (actorsForContact != null && !actorsForContact.isEmpty()) {
                
                member.Character__c = actorsForContact[0].character; 
            } else {
                
                member.Character__c = null; 
            }
            
            cList.add(member);
        }
        
        return cList;
    }
    
    

    public void insertCast(List<Cast__c> clist){
        insert clist;
    }
}