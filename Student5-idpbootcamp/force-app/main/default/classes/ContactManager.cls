public with sharing class ContactManager {   
    List<tmdbMovieDetails.Actor> actors;
    public List<Contact> contactListNotForInsert = new List<Contact>();
    public List<Contact> contactList = new List<Contact>();
    List<Contact> existingContacts; 
    Id actorId;

    public ContactManager(List<tmdbMovieDetails.Actor> casts) {
        this.actors = casts;
        this.existingContacts = obtainExistingContacts();
        this.actorId = [SELECT Id FROM RecordType WHERE Name = 'Actor' AND SObjectType = 'Contact' LIMIT 1].Id;
    }

    public List<String> createContactNamesList() {
        List<String> nameList = new List<String>();

        System.debug(contactListNotForInsert);
        for (Contact contact : contactListNotForInsert) {
            String fullName = contact.FirstName + ' ' + contact.LastName;
    
            if (!nameList.contains(fullName)) {
                nameList.add(fullName);
            }
        }
        
        System.debug(nameList);
        return nameList;
    }

    public Map<String, List<tmdbMovieDetails.Actor>> createActorMap() {
        Map<String, List<tmdbMovieDetails.Actor>> actorMap = new Map<String, List<tmdbMovieDetails.Actor>>();
        
        for (tmdbMovieDetails.Actor actor : actors) {
            String actorName = actor.name;
            
            if (!actorMap.containsKey(actorName)) {
                actorMap.put(actorName, new List<tmdbMovieDetails.Actor>());
            }
            actorMap.get(actorName).add(actor);
        }
        
        return actorMap;
    }
    
    

    public List<Contact> getContactList()
    {
        return this.contactList;
    }

    private List<Contact> obtainExistingContacts() {
        return [SELECT FirstName, LastName FROM Contact];
    }

    public List<Contact> createContacts() {

        for (tmdbMovieDetails.Actor actor : actors) {   
            List<String> nameParts = actor.name.split(' ');
            String firstName;
            String lastName;

            // System.debug(actor.name);

            try 
            {
                firstName = nameParts[0];
                lastName = nameParts[1];
            } catch (Exception ex) 
            {
                firstName = actor.name;
                lastName = '_'; 
            }
                Contact act = new Contact();
                act.FirstName = firstName;
                act.LastName = lastName; 
                act.RecordTypeId = this.actorId;
                act.Skills__c = 'Main Character';
                act.Role__c = 'Actor';
                contactListNotForInsert.add(act);
                if (!isDuplicateContact(firstName, lastName)){
                    contactList.add(act);
                }
        }
        System.debug('Contact Lists');
        System.debug(contactList);
        return contactList;
    }

    private Boolean isDuplicateContact(String firstName, String lastName) {
        for (Contact existing : existingContacts) {
            if (existing.FirstName == firstName && existing.LastName == lastName) {
                System.debug('Exists: '+firstName+' '+lastName);
                return true; 
            }
        }
        return false; 
    }

    public void insertContacts(List<Contact> cList) {
        if (!cList.isEmpty()) {
            System.debug('Inserting Contants' + cList);
            insert cList;
        } else {
            System.debug('No contacts to insert.');
        }
    }
}