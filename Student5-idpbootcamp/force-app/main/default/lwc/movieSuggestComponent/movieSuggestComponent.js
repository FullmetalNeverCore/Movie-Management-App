import { LightningElement, track, api } from 'lwc';
import searchMovie from '@salesforce/apex/tmdb.searchMovie';
import handleInsertionBySingleId from '@salesforce/apex/MovieTMDBService.handleInsertionBySingleId';
import getMovie from '@salesforce/apex/MovieController.getMovie'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MovieSearch extends LightningElement {
    @track movieOptions = [];
    @track selectedMovieId;
    @track tmdbIdPopulated = false;
    @track showMovieList = false;
    @api recordId;
    movieTitle;

    connectedCallback() {
        this.loadMovieTitle();
    }

    loadMovieTitle() {
        getMovie({ movid: this.recordId })
            .then(result => {
                if (result.length > 0) {
                    this.movieTitle = result[0].Title__c;
                    this.handleSearch();
                } else {
                    this.showToast('Warning', 'No movie found with the given ID.', 'warning');
                }
            })
            .catch(error => {
                this.showToast('Error', 'Error fetching record data', 'error');
            });
    }

    handleSearch() {
        if (this.movieTitle.trim() === '') {
            this.movieOptions = [];
            this.showMovieList = false;
            return;
        }

        searchMovie({ title: this.movieTitle })
            .then(result => {
                this.movieOptions = result.results.map(movie => ({
                    label: movie.title,
                    value: movie.id.toString(),
                    overview: movie.overview
                }));
                this.showMovieList = this.movieOptions.length > 0;
            })
            .catch(error => {
                this.showToast('Error', 'Error searching for movies', 'error');
            });
    }

    handleMovieSelect(event) {
        this.selectedMovieId = event.currentTarget.dataset.value;
        const selectedMovie = this.movieOptions.find(movie => movie.value === this.selectedMovieId);

        if (selectedMovie) {
            this.copyMovieData(selectedMovie);
            this.showMovieList = false; 
            this.movieTitle = selectedMovie.label;
        }
    }

    copyMovieData() {
        if (this.recordId && this.selectedMovieId) {
            handleInsertionBySingleId({ movieId: this.recordId, tmdbId: this.selectedMovieId })
                .then(() => {
                    this.tmdbIdPopulated = true;
                    this.showToast('Success', 'TMDB ID copied to Movie record', 'success');
                    window.location.reload();
                })
                .catch(error => {
                    console.log(error);
                    this.showToast('Error', 'Error processing movie data', 'error');
                });
        } else {
            this.showToast('Error', 'Record ID or Selected Movie ID is missing', 'error');
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title,
            message,
            variant
        }));
    }
}
