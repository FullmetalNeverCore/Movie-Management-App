public class MovieDataHandler {
    public static void updatingEntries(Map<Id,tmdbMovieDetails> movMap) 
    {
        	List<Movie__c> finalMovieList = new List<Movie__c>();
        	for(Id movId : movMap.KeySet())
            {
                Movie__c movie = MovieDataPreparer.prepareMovie(movId,movMap.get(movId));
                finalMovieList.add(movie);
            }
            
   
            try 
                {
                    update finalMovieList;
           
                } 
        	catch (DmlException e) 
                {
                    System.debug('Error updating movie record: ' + e.getMessage());
                }
       }
		
}