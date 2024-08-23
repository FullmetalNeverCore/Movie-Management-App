@isTest
private class UserReviewControllerTest {
    
    @isTest
    static void testGetReviewsWithValidMovieId() {
        Movie__c testMovie = new Movie__c(Title__c = 'Inception');
        insert testMovie;
        
        UsersReview__c testReview = new UsersReview__c(MovieID__c = testMovie.Id, UserName__c = 'Test User', Review__c = 'Amazing!', UserScore__c = 9.0);
        insert testReview;

        Test.startTest();
        List<UsersReview__c> reviews = UserReviewController.getReviews(testMovie.Id);
        System.assertEquals(1, reviews.size(), 'Should return one review for the movie');
        Test.stopTest();
    }

    @isTest
    static void testGetUserReviewWithExistingReview() {
        User currentUser = [SELECT Id, FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        String username = currentUser.FirstName + ' ' + currentUser.LastName;
        
        Movie__c testMovie = new Movie__c(Title__c = 'Inception');
        insert testMovie;
        
        UsersReview__c testReview = new UsersReview__c(MovieID__c = testMovie.Id, UserName__c = username, Review__c = 'Loved it!', UserScore__c = 10.0);
        insert testReview;

        Test.startTest();
        UsersReview__c userReview = UserReviewController.getUserReview(testMovie.Id);
        System.assertNotEquals(null, userReview, 'User should have a review for the movie');
        Test.stopTest();
    }

    @isTest
    static void testGetUserReviewWithNoExistingReview() {
        Movie__c testMovie = new Movie__c(Title__c = 'Inception');
        insert testMovie;

        Test.startTest();
        UsersReview__c userReview = UserReviewController.getUserReview(testMovie.Id);
        System.assertEquals(null, userReview, 'User should not have a review for the movie');
        Test.stopTest();
    }

    @isTest
    static void testSaveReviewInsertNewReview() {
        Movie__c testMovie = new Movie__c(Title__c = 'Inception');
        insert testMovie;

        Test.startTest();
        UserReviewController.saveReview(testMovie.Id, null, 'Great movie!', '8');
        List<UsersReview__c> reviews = [SELECT Id FROM UsersReview__c WHERE MovieID__c = :testMovie.Id];
        System.assertEquals(1, reviews.size(), 'Should insert a new review');
        Test.stopTest();
    }

    @isTest
    static void testSaveReviewUpdateExistingReview() {
        Movie__c testMovie = new Movie__c(Title__c = 'Inception');
        insert testMovie;

        UsersReview__c testReview = new UsersReview__c(MovieID__c = testMovie.Id, UserName__c = 'Test User', Review__c = 'Amazing!', UserScore__c = 9.0);
        insert testReview;

        Test.startTest();
        UserReviewController.saveReview(testMovie.Id, testReview.Id, 'Updated review!', '10');
        UsersReview__c updatedReview = [SELECT Review__c, UserScore__c FROM UsersReview__c WHERE Id = :testReview.Id];
        System.assertEquals('Updated review!', updatedReview.Review__c, 'Review should be updated');
        System.assertEquals(10.0, updatedReview.UserScore__c, 'User score should be updated');
        Test.stopTest();
    }

    @isTest
    static void testGetReviewsWithInvalidMovieId() {
        Test.startTest();
        try
        {
         List<UsersReview__c> reviews = UserReviewController.getReviews('invalidId');
         System.assert(false, 'Should throw an exception for invalid id');
        }
        catch(Exception ex)
        {
         System.debug(ex.getMessage()); 
         System.assertEquals('Invalid id: invalidId',ex.getMessage(),'Error is not correct');
        }
        Test.stopTest();
    }

    @isTest
    static void testSaveReviewWithInvalidScore() {
        Movie__c testMovie = new Movie__c(Title__c = 'Inception');
        insert testMovie;

        Test.startTest();
        try {
            UserReviewController.saveReview(testMovie.Id, null, 'Great movie!', 'invalidScore');
            System.assert(false, 'Should throw an exception for invalid score');
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testSaveReviewWithNullMovieId() {
        Test.startTest();
        try {
            UserReviewController.saveReview(null, null, 'No movie ID', '5');
            System.assert(false, 'Should throw an exception for null movie ID');
        } catch (Exception e) {
            System.assert(e instanceof BlankMovieIDException, 'Expected BlankMovieIDException due to null movie ID');
        }
        Test.stopTest();
    }
}