public class GenreValidation 
{
    private Set<String> validGenres = new Set<String>();
    
   	public void loadValidGenres() {
        Schema.DescribeFieldResult fieldResult = Movie__c.Genre__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry entry : picklistEntries) {
            validGenres.add(entry.getValue());
        }
    }
    
    public Set<String> returnValidGenres()
    {
        return validGenres;
    }
    
    public String validateGenres(String genreStr) {
        if (String.isBlank(genreStr)) return null;

        List<String> genres = genreStr.split(';');
        List<String> validGenresList = new List<String>();
		
        for(String gen : validGenres)
        {
            System.debug(gen);
        }
        
        for (String genre : genres) {
           
            if (validGenres.contains(genre.trim())) {
                validGenresList.add(genre.trim());
            } else {
                System.debug('Invalid genre value: ' + genre.trim());
            }
        }
        return validGenresList.isEmpty() ? null : String.join(validGenresList, ';');
    }

}