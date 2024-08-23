import { LightningElement, api, wire } from 'lwc';
import obtainTrailerLink from '@salesforce/apex/MovieTMDBService.obtainTrailerLink';
import getMovie from '@salesforce/apex/MovieController.getMovie';

export default class TrailerSearch extends LightningElement {
    @api recordId; 
    trailerLink = '';
    error;
    movie;

    @wire(getMovie, { movid: '$recordId' })
    wiredMovie({ error, data }) {
        if (data) {
            this.movie = data[0]; 
            this.fetchTrailerLink();
        } else if (error) {
            console.error('Error fetching movie data:', error);
            this.error = error;
        }
    }

    fetchTrailerLink() {
        if (this.movie) {
            const tmdbId = this.movie.TMDBID__c;
            if (tmdbId) {
                obtainTrailerLink({ tmdbId: tmdbId })
                    .then(result => {
                        this.trailerLink = result || ''; 
                    })
                    .catch(error => {
                        console.error('Error fetching trailer link:', error);
                        this.error = error;
                        this.trailerLink = ''; 
                    });
            } else {
                console.warn('TMDBID__c is missing or undefined');
                this.trailerLink = ''; 
            }
        } else {
            console.warn('Movie data is not available');
            this.trailerLink = ''; 
        }
    }

    get hasTrailer() {
        return this.trailerLink !== '';
    }
}
