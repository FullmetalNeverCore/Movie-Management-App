public with sharing class tmdbSearchMovieResponse {
    @AuraEnabled
    public Integer total_pages;
    @AuraEnabled
    public Integer total_results;
    @AuraEnabled
    public Integer page;
    @AuraEnabled
    public List<tmdbSearchMovieResult> results;
}