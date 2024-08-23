import { LightningElement, api, track, wire } from 'lwc';
import getReviews from '@salesforce/apex/UserReviewController.getReviews';
import getUserReview from '@salesforce/apex/UserReviewController.getUserReview';
import saveReview from '@salesforce/apex/UserReviewController.saveReview';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UsersReview extends LightningElement {
    @api recordId; 
    @track reviews = [];
    @track reviewText = '';
    @track score = '';
    @track existingReviewId = null;  

    @wire(getUserReview, { movieId: '$recordId' })
    wiredReview({ error, data }) {
        if (data) {
            this.existingReviewId = data.Id;
            this.reviewText = data.Review__c;
            this.score = data.UserScore__c;
        } else if (error) {
            this.showToast('Error', 'Error fetching user review', 'error');
        }
    }

    get scoreOptions() {
        const options = [];
        for (let i = 0; i <= 10; i++) {
            options.push({ label: i.toString(), value: i.toString() });
        }
        return options;
    }

    @wire(getReviews, { movieId: '$recordId' })
    wiredReviews({ error, data }) {
        if (data) {
            this.reviews = data;
        } else if (error) {
            this.showToast('Error', 'Error fetching reviews', 'error');
        }
    }

    handleReviewTextChange(event) {
        this.reviewText = event.target.value;
    }

    handleScoreChange(event) {
        this.score = event.target.value;
    }

    handleSubmit() {
        if (this.reviewText && this.score) {
            this.showToast('Saving', 'Saving review...', 'info');
            saveReview({ 
                movieId: this.recordId, 
                reviewId: this.existingReviewId, 
                reviewText: this.reviewText, 
                score: this.score 
            })
            .then(() => {
                this.showToast('Success', 'Review saved successfully!', 'success');
                window.location.reload();
            })
            .catch(error => {
                this.showToast('Error', 'Error saving review', 'error');
            });
        } else {
            this.showToast('Validation Error', 'Please fill in all fields correctly.', 'warning');
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