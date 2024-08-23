public class tmdbMovieDetails {
    public Boolean adult;
    public String backdrop_path;
    public Collection belongs_to_collection;  
    public Integer budget;
    public List<Genre> genres;
    public String homepage;
    public Integer id;
    public String imdb_id;
    public String original_language;
    public String original_title;
    public String overview;
    public Decimal popularity;
    public String poster_path;
    public List<ProductionCompany> production_companies;
    public List<ProductionCountry> production_countries;
    public String release_date;
    public Long revenue;
    public Integer runtime;
    public List<SpokenLanguage> spoken_languages;
    public String status;
    public String tagline;
    public String title;
    public Boolean video;
    public Decimal vote_average;
    public Integer vote_count;
    public Credits credits;

    public class Collection {
        public Integer id;
        public String name;
        public String poster_path;
        public String backdrop_path;
    }

    public class Genre {
        public Integer id;
        public String name;
    }

    public class ProductionCompany {
        public Integer id;
        public String logo_path;
        public String name;
        public String origin_country;
    }

    public class ProductionCountry {
        public String name;
    }

    public class SpokenLanguage {
        public String english_name;
        public String name;
    }
    
    public class Credits {
        public List<Actor> actors;
    }

    public class Actor {
        public Boolean adult;
        public Integer gender;
        public Integer id;
        public String known_for_department;
        public String name;
        public String original_name;
        public Decimal popularity;
        public String profile_path;
        public Integer actors_id;
        public String character;
        public String credit_id;
        public Integer order;
    }
}