@isTest
public class ValuesTest {

    @isTest
    public static void testGenreIdByNameMap() {
        Values values = new Values();
        
      
        Map<String, Integer> expectedGenreMap = new Map<String, Integer>{
            'Action' => 28,
            'Adventure' => 12,
            'Animation' => 16,
            'Comedy' => 35,
            'Crime' => 80,
            'Documentary' => 99,
            'Drama' => 18,
            'Family' => 10751,
            'Fantasy' => 14,
            'History' => 36,
            'Horror' => 27,
            'Music' => 10402,
            'Mystery' => 9648,
            'Romance' => 10749,
            'Science Fiction' => 878,
            'TV Movie' => 10770,
            'Thriller' => 53,
            'War' => 10752,
            'Wester' => 37
        };
        
        System.assertEquals(expectedGenreMap.size(), values.genreIdByName.size(), 
            'The genreIdByName map should contain the correct number of entries.');
        
        for (String genre : expectedGenreMap.keySet()) {
            System.assertEquals(expectedGenreMap.get(genre), values.genreIdByName.get(genre), 
                'The genreIdByName map should have the correct ID for genre: ' + genre);
        }
    }
}