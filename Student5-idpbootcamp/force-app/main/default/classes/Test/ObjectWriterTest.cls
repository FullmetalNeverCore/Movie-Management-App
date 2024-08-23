@IsTest
public class ObjectWriterTest {

    @IsTest
    static void testInsertInBatches_Success() {
        List<Movie__c> movieList = new List<Movie__c>();
        for (Integer i = 0; i < 25; i++) {
            movieList.add(new Movie__c(Title__c = 'Movie ' + i));
        }

        ObjectWriter.insertInBatches(movieList, 10);

        Integer count = [SELECT COUNT() FROM Movie__c WHERE Title__c LIKE 'Movie %'];
        System.assertEquals(25, count);
    }

    @IsTest
    static void testUpdatingEntries_EmptyMap() {
        Map<Id, tmdbMovieDetails> emptyMap = new Map<Id, tmdbMovieDetails>();

        Test.startTest();
        ObjectWriter.updatingEntries(emptyMap);
        Test.stopTest();
    }

    @IsTest
    static void testInsertInBatches_EmptyList() {
        List<Movie__c> emptyList = new List<Movie__c>();

        Test.startTest();
        ObjectWriter.insertInBatches(emptyList, 10);
        Test.stopTest();
    }
}