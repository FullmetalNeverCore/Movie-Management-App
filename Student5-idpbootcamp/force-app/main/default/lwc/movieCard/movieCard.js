import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class MovieCard extends NavigationMixin(LightningElement) {
    @api movie;

    renderedCallback() {
        const movieCard = this.template.querySelector('.movie-card');

        if (movieCard) {
            movieCard.style.opacity = 0; 
            movieCard.style.transform = 'translateY(10px)'; 

         
            requestAnimationFrame(() => {
                setTimeout(() => {
                    movieCard.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                    movieCard.style.opacity = 1; 
                    movieCard.style.transform = 'translateY(0)'; 
                }, 100); 
            });
        }

        const albums = this.template.querySelectorAll('.album');
        albums.forEach(album => {
            const coverUrl = album.getAttribute('data-cover-url');
            const vinylCover = album.querySelector('.vinyl-cover');

            if (coverUrl && vinylCover) {
                vinylCover.style.backgroundImage = `url('${coverUrl}')`;
            }
        });
    }

    get isHorrorMovie() {
        let genres = this.movie.Genre__c || [];
        return genres.includes('Horror');
    }

    handleDetailsClick() {
        if (!this.movie || !this.movie.Id) {
            console.error('Record ID is missing or movie data is not provided');
            return;
        }

        const pageReference = {
            type: 'standard__recordPage',
            attributes: {
                objectApiName: 'Movie__c',
                recordId: this.movie.Id,
                actionName: 'view'
            }
        };

        this[NavigationMixin.Navigate](pageReference)
            .then(() => {
                console.log('Navigation successful');
            })
            .catch(error => {
                console.error('Navigation error:', error);
            });
    }
}
