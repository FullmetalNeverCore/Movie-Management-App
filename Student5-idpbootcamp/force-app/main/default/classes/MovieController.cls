public with sharing class MovieController {
    @AuraEnabled(cacheable=true)
    public static List<Movie__c> getMovies(Integer lowerlim, Integer highlim) {
        System.debug('getMovies');
    
        List<Movie__c> movies =  [SELECT Id, Title__c, Rating_calc__c, Genre__c, Poster_URL__c 
                FROM Movie__c
                LIMIT :highlim
                OFFSET :lowerlim];
        System.debug(movies.size());
        return movies;
    }

    @AuraEnabled(cacheable=true)
    public static List<Movie__c> getMovie(Id movid) {
        List<Movie__c> movies = [SELECT Id, TMDBID__c, Title__c, Rating_calc__c, Genre__c, Poster_URL__c 
                                  FROM Movie__c
                                  WHERE Id = :movid];
        System.debug(movies.size());
        return movies;
    }


    //i did used it inside showPoster component,method created specifically to 
    // @AuraEnabled(cacheable=true)
    // public static Movie__c getMovieById(Id id) {
    //     return [
    //         SELECT Id, Title__c, Rating__c, Genre__c, Poster_URL__c 
    //         FROM Movie__c 
    //         WHERE Id = :id 
    //         LIMIT 1
    //     ];
    // }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> returnGenres() {
        List<Map<String, String>> genreOptions = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Movie__c.Genre__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry entry : picklistEntries) {
            Map<String, String> genreMap = new Map<String, String>();
            genreMap.put('label', entry.getLabel());
            genreMap.put('value', entry.getValue());
            genreOptions.add(genreMap);
        }
        
        return genreOptions;
    }

    @AuraEnabled(cacheable=true)
    public static List<Movie__c> searchMoviesByGenre(String genre) {
        if (String.isBlank(genre)) {
            return new List<Movie__c>();
        }

        List<Movie__c> movies = [
            SELECT Id, Title__c, Rating_calc__c, Genre__c, Poster_URL__c
            FROM Movie__c
            WHERE Genre__c INCLUDES (:genre)
        ];

        System.debug('Movies found: ' + movies.size());
        return movies;
    }

    @AuraEnabled(cacheable=true)
    public static List<Movie__c> searchMoviesByTitle(String title) {
        System.debug('Received title: ' + title); 
    
        if (String.isBlank(title)) {
            System.debug('Title is blank, returning empty list.');
            return new List<Movie__c>();
        }
    
        String searchTitle = '%' + title + '%';
        System.debug('Formatted search title: ' + searchTitle); 
    
        List<Movie__c> movies = [
            SELECT Id, Title__c, Rating_calc__c, Genre__c, Poster_URL__c
            FROM Movie__c
            WHERE Title__c LIKE :searchTitle
        ];
    
        System.debug('Movies found: ' + movies.size());
        return movies;
    }

    @AuraEnabled(cacheable=true)
    public static List<Movie__c> searchMovies(String genre, String title,Integer highlim) {
        List<Movie__c> movies = new List<Movie__c>();
    
        String query = 'SELECT Id, Title__c, Rating_calc__c, Genre__c, Poster_URL__c FROM Movie__c WHERE ';
        List<String> conditions = new List<String>();
    
        if (String.isNotBlank(genre)) {
            conditions.add('Genre__c INCLUDES (:genre)');
        }
    
        if (String.isNotBlank(title)) {
            String searchTitle = '%' + title + '%';
            conditions.add('Title__c LIKE :searchTitle');
        }
    
        if (conditions.isEmpty()) {
            return movies;
        }
    
        query += String.join(conditions, ' AND ');
    
        if (highlim != null && highlim > 0) {
            query += ' LIMIT :highlim';
        }
    
        movies = Database.query(query);
    
        System.debug('Movies found: ' + movies.size());
        return movies;
    }
    
    
}