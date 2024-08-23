@isTest
public class ContactManagerTest {
    @isTest
    static void testContactManager() {
        List<tmdbMovieDetails.Actor> actors = new List<tmdbMovieDetails.Actor>();
        tmdbMovieDetails.Actor actor1 = new tmdbMovieDetails.Actor();
        actor1.name = 'John Doe';
        tmdbMovieDetails.Actor actor2 = new tmdbMovieDetails.Actor();
        actor2.name = 'Jane Smith';
        tmdbMovieDetails.Actor actor3 = new tmdbMovieDetails.Actor();
        actor3.name = 'John Doe';
        
        actors.add(actor1);
        actors.add(actor2);
        actors.add(actor3);
        
        Id actorRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Actor' AND SObjectType = 'Contact' LIMIT 1].Id;

        List<Contact> existingContacts = new List<Contact>{
            new Contact(FirstName = 'Existing', LastName = 'User', RecordTypeId = actorRecordTypeId)
        };
        insert existingContacts;

        ContactManager contactManager = new ContactManager(actors);
        
        List<Contact> createdContacts = contactManager.createContacts();
        System.assertEquals(3, createdContacts.size());

        List<String> contactNames = contactManager.createContactNamesList();
        System.assertEquals(2, contactNames.size());
        System.assert(contactNames.contains('John Doe'));
        System.assert(contactNames.contains('Jane Smith'));

        List<Contact> allContacts = contactManager.getContactList();
        System.assertEquals(3, allContacts.size());

        contactManager.insertContacts(allContacts);
        
    }

    @isTest
    static void testCreateActorMap() {
        List<tmdbMovieDetails.Actor> actors = new List<tmdbMovieDetails.Actor>();
        tmdbMovieDetails.Actor actor1 = new tmdbMovieDetails.Actor();
        actor1.name = 'Actor One';
        tmdbMovieDetails.Actor actor2 = new tmdbMovieDetails.Actor();
        actor2.name = 'Actor Two';
        tmdbMovieDetails.Actor actor3 = new tmdbMovieDetails.Actor();
        actor3.name = 'Actor One';
        
        actors.add(actor1);
        actors.add(actor2);
        actors.add(actor3);
        
        ContactManager contactManager = new ContactManager(actors);
        
        Map<String, List<tmdbMovieDetails.Actor>> actorMap = contactManager.createActorMap();
        
        System.assertEquals(2, actorMap.size());
        System.assert(actorMap.containsKey('Actor One'));
        System.assert(actorMap.containsKey('Actor Two'));
        System.assertEquals(2, actorMap.get('Actor One').size());
    }



}