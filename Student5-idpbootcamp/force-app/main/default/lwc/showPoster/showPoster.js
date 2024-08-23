import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getMovie from '@salesforce/apex/MovieController.getMovie';

export default class ShowPoster extends NavigationMixin(LightningElement) {
    @api recordId; 
    posterUrl;

    @wire(getMovie, { movid: '$recordId' })
    movieRecord({ error, data }) {
        if (data) {
            this.posterUrl = data[0].Poster_URL__c;
        } else if (error) {
            this.posterUrl = null;
            console.error('Error retrieving the movie record:', error);
        }
    }
}
