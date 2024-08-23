public class TrailerDetails {
    @AuraEnabled
    public Integer id { get; set; }
    @AuraEnabled
    public List<Result> results { get; set; }

    public class Result {
        @AuraEnabled
        public String iso_639_1 { get; set; }
        @AuraEnabled
        public String iso_3166_1 { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String key { get; set; }
        @AuraEnabled
        public String site { get; set; }
        @AuraEnabled
        public Integer size { get; set; }
        @AuraEnabled
        public String type { get; set; }
        @AuraEnabled
        public Boolean official { get; set; }
        @AuraEnabled
        public Datetime published_at { get; set; }
        @AuraEnabled
        public String id { get; set; }
    }
}