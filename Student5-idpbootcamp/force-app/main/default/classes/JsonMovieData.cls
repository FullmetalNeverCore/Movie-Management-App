public class JsonMovieData {
    public List<Movie> movies { get; set; } 
    public class Movie {
        public String id { get; set; }
        public String name { get; set; }
        public String tmdb_id { get; set; }
        public String genre { get; set; }
        public Decimal rating { get; set; }
        public Decimal budget { get; set; }
        public Decimal actual_budget { get; set; }
        public Decimal revenue { get; set; }
        public Script script { get; set; }
        public String release_date { get; set; }
        public String status { get; set; }
    }

    public class Script {
        public String id { get; set; }
        public String name { get; set; }
        public String description { get; set; }
    }
}