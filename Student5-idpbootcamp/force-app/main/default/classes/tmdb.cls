public with sharing class tmdb {
    private static final String API_KEY = '';
    private static final String API_KEY_PARAM_NAME = 'api_key';
    private static final String API_VERSION = '3';

    private static String authQueryParameter {
        get {
            return API_KEY_PARAM_NAME + '=' + API_KEY;
        }
    }

    private static final String BASE_URL = 'https://api.themoviedb.org/';

    private static string buildResourceUrl(String resourceName) {
        return BASE_URL + API_VERSION + resourceName;
    }

    private static HttpRequest authenticateRequest(HttpRequest request) {
        String endpoint = request.getEndpoint();
        if (endpoint.contains('?')) {
            endpoint += '&' + authQueryParameter;
        } else {
            endpoint += '?' + authQueryParameter;
        }
        request.setEndpoint(endpoint);

        return request;
    }

    private static HttpRequest authenticateRequestWithCredits(HttpRequest request)
    {
        String endpoint = request.getEndpoint();
        endpoint += '?' + authQueryParameter + '&language=en-US&append_to_response=credits';
        System.debug(endpoint);
        request.setEndpoint(endpoint);
        return request; 
    }

    public tmdbGenreListResponse genreList() {
        String resourceName = '/genre/movie/list';
        String endpoint = buildResourceUrl(resourceName);
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);
        request = authenticateRequest(request);
        Http http = new Http();
        HttpResponse response = http.send(request);

        tmdbGenreListResponse tmdbResponse = (tmdbGenreListResponse) JSON.deserialize(response.getBody(), tmdbGenreListResponse.class);
        System.debug(tmdbResponse);
        return tmdbResponse;
    }

    @AuraEnabled
    public static TrailerDetails searchTrailer(String movieId) {
        String resourceName = '/movie/' + movieId + '/videos';
        String endpoint = buildResourceUrl(resourceName);

        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);

        request = authenticateRequest(request);

        Http http = new Http();
        HttpResponse response = http.send(request);
        String responseBody = response.getBody();

        TrailerDetails trailerData = (TrailerDetails) JSON.deserialize(responseBody, TrailerDetails.class);
        return trailerData;
    }

    @AuraEnabled
    public static tmdbSearchMovieResponse searchMovie(String title) {
        String resourceName = '/search/movie';
        String endpoint = buildResourceUrl(resourceName);
        endpoint += '?query=' + EncodingUtil.urlEncode(title, 'UTF-8');


        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);

        request = authenticateRequest(request);
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug(response.getBody());

        tmdbSearchMovieResponse result = (tmdbSearchMovieResponse) JSON.deserialize(response.getBody(), tmdbSearchMovieResponse.class);
        return result;
    }
    

	
    public static tmdbMovieDetails getMovieDetails(String tmdbId) {
        String resourceName = '/movie/' + tmdbId;
        String endpoint = buildResourceUrl(resourceName);

        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);
        request = authenticateRequestWithCredits(request);

        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        if (response.getBody().contains('credits')) {
            System.debug('The response contains the word "credits".');
        } else {
            System.debug('The response does NOT contain the word "credits".');
        }
        String responseBody = response.getBody().replace('cast', 'actors');

        System.debug(responseBody);

        tmdbMovieDetails results = (tmdbMovieDetails) JSON.deserialize(responseBody, tmdbMovieDetails.class);
        
		return results;
    }
    
    public static tmdbImageDetails getImageDetails() {
        String resourceName = '/configuration';
        String endpoint = buildResourceUrl(resourceName);
    
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);
        request = authenticateRequest(request);
    
        Http http = new Http();
        HttpResponse response = http.send(request);
    
        tmdbImageDetails results = (tmdbImageDetails) JSON.deserialize(response.getBody(), tmdbImageDetails.class);
        
        return results;
    }
    
    @AuraEnabled
    public static void copyMovieDataToSalesforce(Id movieRecordId, String tmdbId) {
        tmdbMovieDetails movieDetails = getMovieDetails(tmdbId);

        Map<Id, tmdbMovieDetails> moviesToUpdate = new Map<Id, tmdbMovieDetails>();

        moviesToUpdate.put(movieRecordId, movieDetails);

        ObjectWriter.updatingEntries(moviesToUpdate);
    }
    

}