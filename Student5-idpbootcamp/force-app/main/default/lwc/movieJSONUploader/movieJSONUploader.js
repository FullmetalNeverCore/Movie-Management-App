import { LightningElement } from 'lwc';
import processUserUploadedJson from '@salesforce/apex/JsonMovieDataHandler.processUserUploadedJson';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class JsonFileUploader extends LightningElement {
    handleFileUpload(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = (e) => {
                try {
                    const fileContents = e.target.result;
                    const jsonString = JSON.stringify(JSON.parse(fileContents), null, 2);
                    this.uploadJsonToApex(jsonString);
                } catch (error) {
                    console.error('Error parsing JSON file: ', error);
                    this.showToast('Error', 'There was an issue processing the file. Please ensure it is a valid JSON file.', 'error');
                }
            };
            try {
                reader.readAsText(file);
            } catch (error) {
                console.error('Error reading file: ', error);
                this.showToast('Error', 'There was an issue reading the file.', 'error');
            }
        } else {
            console.error('No file selected.');
            this.showToast('Error', 'No file selected.', 'error');
        }
    }

    uploadJsonToApex(jsonString) {
        processUserUploadedJson({ jsonString })
            .then(() => {
                this.showToast('Success', 'JSON processed successfully.', 'success');
            })
            .catch(error => {
                console.error('Error in Apex call: ', error);
                this.showToast('Error', 'Error processing JSON in Apex.', 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(event);
    }
}
