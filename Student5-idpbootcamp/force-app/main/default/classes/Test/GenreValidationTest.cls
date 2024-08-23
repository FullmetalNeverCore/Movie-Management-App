@isTest
public class GenreValidationTest {
   
    @isTest
    static void testLoadValidGenres() {
  
        GenreValidation genreValidation = new GenreValidation();
        
      
        genreValidation.loadValidGenres();
        
     
        System.assertEquals(21, genreValidation.returnValidGenres().size(), 'Valid genres should be loaded correctly');
        System.assert(genreValidation.returnValidGenres().contains('Action'), 'Action genre should be loaded');
        System.assert(genreValidation.returnValidGenres().contains('Comedy'), 'Comedy genre should be loaded');
        System.assert(genreValidation.returnValidGenres().contains('Drama'), 'Drama genre should be loaded');
    }
    
    @isTest
    static void testValidateGenres_AllValidGenres() {

        GenreValidation genreValidation = new GenreValidation();
        genreValidation.loadValidGenres();
        
       
        String result = genreValidation.validateGenres('Action;Comedy;Drama');
        
        
        System.assertEquals('Action;Comedy;Drama', result, 'All valid genres should be returned as is');
    }
    
    @isTest
    static void testValidateGenres_SomeInvalidGenres() {
     
        GenreValidation genreValidation = new GenreValidation();
        genreValidation.loadValidGenres();
        
       
        String result = genreValidation.validateGenres('Action;SciFi;Comedy');
        
     
        System.assertEquals('Action;Comedy', result, 'Only valid genres should be returned');
    }
    
    @isTest
    static void testValidateGenres_AllInvalidGenres() {
   
        GenreValidation genreValidation = new GenreValidation();
        genreValidation.loadValidGenres();
        
     
        String result = genreValidation.validateGenres('Hor;SciFi;Fant');
        
  
        System.assertEquals(null, result, 'No valid genres should return null');
    }
    
    @isTest
    static void testValidateGenres_EmptyString() {
        
        GenreValidation genreValidation = new GenreValidation();
        genreValidation.loadValidGenres();
        
        
        String result = genreValidation.validateGenres('');
        
 
        System.assertEquals(null, result, 'Empty string should return null');
    }
    
    @isTest
    static void testValidateGenres_BlankString() {
    
        GenreValidation genreValidation = new GenreValidation();
        genreValidation.loadValidGenres();
        
    
        String result = genreValidation.validateGenres('   ');
        
   
        System.assertEquals(null, result, 'Blank string should return null');
    }
}