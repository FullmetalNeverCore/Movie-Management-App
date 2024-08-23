import { LightningElement, wire, track } from 'lwc';
import getMovies from '@salesforce/apex/MovieController.getMovies';
import getGenrePicklistValues from '@salesforce/apex/MovieController.returnGenres';
import searchMovies from '@salesforce/apex/MovieController.searchMovies';

export default class MovieList extends LightningElement {
    @track movies = [];
    @track filtered_movies = [];
    @track displayedMovies = [];
    @track genreOptions = [];
    @track selectedGenre = '';
    
    lowerlim = 0;
    error;
    isLoading = true;
    limit = 20; 
    searchTerm = '';

    @wire(getMovies, { lowerlim: '$lowerlim', highlim: '$limit' })
    wiredMovies({ data, error }) {
        this.isLoading = false;
        if (data) {
            this.movies = [
                ...this.movies, 
                ...data.map(movie => ({
                    ...movie,
                    Genre__c: movie.Genre__c ? movie.Genre__c.replace(/;/g, ',') : ''
                }))
            ];
            this.filterMovies();
        } else if (error) {
            this.error = error;
            this.filtered_movies = [];
        }
    }
    
    @wire(getGenrePicklistValues)
    wiredGenres({ data, error }) {
        if (data) {
            this.genreOptions = data;
        } else if (error) {
            this.error = error;
        }
    }

    resetFilterSelection() {
        this.searchTerm = '';
        this.selectedGenre = '';
        this.filterMovies();
    }

    handleGenreChange(event) {
        this.selectedGenre = event.detail.value;
        this.searchMoviesByCriteria();  
    }

    handleLimitChange() {
        this.lowerlim += this.limit; 
        this.loadMovies();
    }

    handleTitleChange(event) {
        this.searchTerm = event.target.value; 
        this.searchMoviesByCriteria();  
    }

    loadMovies() {
        this.isLoading = true;
        getMovies({ lowerlim: this.lowerlim, highlim: this.limit })
            .then(data => {
                if (data) {
                    const newMovies = data.filter(movie => {
                        return !this.movies.some(existingMovie => existingMovie.Title__c === movie.Title__c); //filter enties by title to prevent duplicates
                    });
    
                    this.movies = [
                        ...this.movies, 
                        ...newMovies.map(movie => ({
                            ...movie,
                            Genre__c: movie.Genre__c ? movie.Genre__c.replace(/;/g, ',') : ''
                        }))
                    ];
    
                    this.filterMovies();
                }
                this.isLoading = false;
            })
            .catch(error => {
                this.error = error;
                this.isLoading = false;
            });
    }
    

    searchMoviesByCriteria() {
        this.isLoading = true;
        const title = this.searchTerm;
        const genre = this.selectedGenre;

        searchMovies({genre: genre,title: title,highlim: 80})
            .then(data => {
                if (data) {
                    this.filtered_movies = data.map(movie => ({
                        ...movie,
                        Genre__c: movie.Genre__c ? movie.Genre__c.replace(/;/g, ',') : ''
                    }));
                    this.updateDisplayedMovies();
                }
                this.isLoading = false;
            })
            .catch(error => {
                this.error = error;
                this.isLoading = false;
            });
    }
    
    updateDisplayedMovies() {
        this.displayedMovies = this.filtered_movies;
    }

    filterMovies() {
            let filtered = this.movies;
    
            if (this.searchTerm) {
                filtered = filtered.filter(movie => {
                    return movie.Title__c.toLowerCase().includes(this.searchTerm); 
                });
            }
    
            this.filtered_movies = filtered;
            this.updateDisplayedMovies();
    }

    get SearchMode()
    {
        return !this.searchTerm && !this.selectedGenre;
    }

    get hasMoreMovies() {
        return this.filtered_movies.length > this.displayedMovies.length;
    }
}

