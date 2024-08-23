public class tmdbImageDetails {
    public Images images { get; set; }
    public List<String> change_keys { get; set; }
    
    public class Images {
        public String base_url { get; set; }
        public String secure_base_url { get; set; }
        public List<String> backdrop_sizes { get; set; }
        public List<String> logo_sizes { get; set; }
        public List<String> poster_sizes { get; set; }
        public List<String> profile_sizes { get; set; }
        public List<String> still_sizes { get; set; }
    }
}