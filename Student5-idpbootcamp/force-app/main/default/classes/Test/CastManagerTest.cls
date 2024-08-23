@isTest
public class CastManagerTest {

    @isTest
    static void testGetAllNecessaryContacts() {
        Contact contact1 = new Contact(FirstName='John', LastName='Doe', Email='john@example.com');
        Contact contact2 = new Contact(FirstName='Jane', LastName='Doe', Email='jane@example.com');
        insert new List<Contact>{contact1, contact2};

        List<String> contactNames = new List<String>{ 'John Doe', 'Jane Doe' };

        Movie__c movie = new Movie__c(Title__c='Test Movie');
        insert movie;

        CastManager manager = new CastManager(new List<tmdbMovieDetails.Actor>(), contactNames, movie);
        

        List<Contact> contacts = manager.getAllNecessaryContacts();


        System.assertEquals(2, contacts.size(), 'Should return both contacts.');


        CastManager emptyContactManager = new CastManager(new List<tmdbMovieDetails.Actor>(), new List<String>(), movie);


        List<Contact> emptyContacts = emptyContactManager.getAllNecessaryContacts();

        System.assertEquals(0, emptyContacts.size(), 'Should return no contacts for empty contact names.');
    }

    @isTest
    static void testCreateCast() {

        Movie__c movie = new Movie__c(Title__c='Test Movie');
        insert movie;

        Contact contact1 = new Contact(FirstName='John', LastName='Doe', Email='john@example.com');
        insert contact1;

        List<tmdbMovieDetails.Actor> actors = new List<tmdbMovieDetails.Actor>();
        tmdbMovieDetails.Actor actor = new tmdbMovieDetails.Actor();
        actor.name = 'John Doe';
        actor.character = 'Main Character';
        actors.add(actor);

        Map<String, List<tmdbMovieDetails.Actor>> actorMap = new Map<String, List<tmdbMovieDetails.Actor>>();
        actorMap.put('John Doe', actors);

        List<String> contactNames = new List<String>{ 'John Doe' };

        CastManager manager = new CastManager(new List<tmdbMovieDetails.Actor>(), contactNames, movie);

   
        List<Cast__c> castList = manager.createCast(actorMap);


        System.assertEquals(1, castList.size(), 'One cast member should be created.');
        System.assertEquals(contact1.Id, castList[0].Actor__c, 'Actor__c should match the contact ID.');
        System.assertEquals('Main Character', castList[0].Character__c, 'Character__c should match the actor character.');

        Map<String, List<tmdbMovieDetails.Actor>> emptyActorMap = new Map<String, List<tmdbMovieDetails.Actor>>();

        List<Cast__c> emptyCastList = manager.createCast(emptyActorMap);

     
        System.assertEquals(1, emptyCastList.size(), 'One cast member should be created.');
        System.assertEquals(null, emptyCastList[0].Character__c, 'Character__c should be null when no actors match.');
    }

}