public class JsonMovieDataHandler {

    		public static List<JsonMovieData.Movie> parsingJson(String jsonString)
            {
                JSONParser parser = JSON.createParser(jsonString);
                
                List<JsonMovieData.Movie> movies = new List<JsonMovieData.Movie>();
                JsonMovieData.Movie currentMovie;
                
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        currentMovie = (JsonMovieData.Movie) parser.readValueAs(JsonMovieData.Movie.class);
                        movies.add(currentMovie);
                    }
                }
                
                return movies; 
            }
            
            @AuraEnabled
            public static void processUserUploadedJson(String jsonString) {
                System.debug('Start uploading');
                
                
                List<JsonMovieData.Movie> movies = JsonMovieDataHandler.parsingJson(jsonString);
                
                if (movies.isEmpty()) {
                    System.debug('No movies found');
                    return; // No movie found
                }
                
                try {
                    List<Movie__c> movieRecords = MovieDataPreparer.prepareMovieJson(movies);
                    ObjectWriter.insertInBatches(movieRecords, 50);
                    //Database.executeBatch(new JSONBatchInsert(movieRecords));
                } 
                catch(Exception ex) {
                    System.debug('Error processing JSON: ' + ex.getMessage());
                }
            }


            public void processJsonFromStaticResource() 
            {
                StaticResource myResource = [SELECT Body FROM StaticResource WHERE Name = 'FilmsLessHuge'];
                    
				List<JsonMovieData.Movie> movies = JsonMovieDataHandler.parsingJson(myResource.Body.toString());
                
                if (movies.isEmpty()) {
                    return; //No movie found
                }
                
                try
                {
                    insert MovieDataPreparer.prepareMovieJson(movies);
                }
                catch(Exception ex)
                {
                    System.debug(ex.getMessage());
                }
                
                
            }

}