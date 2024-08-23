import { LightningElement, track, api } from 'lwc';
import searchMovie from '@salesforce/apex/tmdb.searchMovie';
import handleInsertionBySingleId from '@salesforce/apex/MovieTMDBService.handleInsertionBySingleId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MovieSearch extends LightningElement{
    @track movieTitle = '';
    @track movies = [];
    @track movieOptions = [];
    @track selectedMovieId;
    @track tmdbIdPopulated = false;
    @track showDropdown = false;
    @api recordId;
    searchTimeout;

    handleTitleChange(event) {
        this.movieTitle = event.target.value;
        
        // Preventing too many API calls
        if (this.searchTimeout) {
            clearTimeout(this.searchTimeout);
        }

        this.searchTimeout = setTimeout(() => {
            this.handleSearch();
        }, 300);
    }

    handleSearch() {
        if (this.movieTitle.trim() === '') {
            this.movies = [];
            this.movieOptions = [];
            this.showDropdown = false;
            return;
        }

        searchMovie({ title: this.movieTitle })
            .then(result => {
                this.movies = result.results;
                this.movieOptions = this.movies.map(movie => {
                    return { label: movie.title, value: movie.id.toString(), overview: movie.overview};
                });
                this.showDropdown = this.movieOptions.length > 0;
            })
            .catch(error => {
                console.error(error);
                this.showToast('Error', 'Error searching for movies', 'error');
            });
    }

    handleMovieSelect(event) {
        this.selectedMovieId = event.currentTarget.dataset.value;
        const selectedMovie = this.movies.find(movie => movie.id.toString() === this.selectedMovieId);
        if (selectedMovie) {
            this.copyMovieData(selectedMovie);
            this.showDropdown = false;
            this.movieTitle = selectedMovie.title;
        }
    }

    copyMovieData() {
        if (this.recordId && this.selectedMovieId) {
            handleInsertionBySingleId({ movieId: this.recordId, tmdbId: this.selectedMovieId })
                .then(result => {
                    this.tmdbIdPopulated = true;
                    this.showToast('Success', 'TMDB ID copied to Movie record', 'success');
                    window.location.reload();
                })
                .catch(error => {
                    console.error('Error in Apex call:', error);
                    this.showToast('Error', 'Error processing movie data in Apex.', 'error');
                });
        } else {
            console.error('Record ID or Selected Movie ID is null.');
            this.showToast('Error', 'Required data is missing.', 'error');
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }
}
