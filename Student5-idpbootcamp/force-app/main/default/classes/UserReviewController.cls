public class UserReviewController {
    @AuraEnabled(cacheable=true)
    public static List<UsersReview__c> getReviews(Id movieId) {
        return [SELECT Id, UserName__c, UserScore__c, Review__c FROM UsersReview__c WHERE MovieID__c = :movieId];
    }


    @AuraEnabled(cacheable=true)
    public static UsersReview__c getUserReview(String movieId) {
        User currentUser = [SELECT FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        String username = currentUser.FirstName + ' ' + currentUser.LastName;
        
        List<UsersReview__c> reviews = [SELECT Id, Review__c, UserScore__c 
                                   FROM UsersReview__c 
                                   WHERE Username__c = :username AND MovieId__c = :movieId];
        
        if (!reviews.isEmpty()) {
            return reviews[0];
        }
        return null;
    }

    @AuraEnabled
    public static void saveReview(String movieId, String reviewId, String reviewText, String score) {
        if (String.isBlank(movieId)) {
            throw new BlankMovieIDException('The movieId cannot be null or empty.');
        }


        User currentUser = [SELECT FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        String username = currentUser.FirstName + ' ' + currentUser.LastName;
        
        UsersReview__c review;
        if (reviewId != null) {
            review = [SELECT Id FROM UsersReview__c WHERE Id = :reviewId];
        } else {
            review = new UsersReview__c();
            review.MovieID__c = movieId;
        }
        
        review.UserName__c = username;
        review.Review__c = reviewText;
        review.UserScore__c = Decimal.valueOf(score);
        
        upsert review;
    }
}