import { LightningElement, wire } from 'lwc';

import getMyApplications
    from '@salesforce/apex/ApplicationController.getMyApplications';

import getMyOfferLetters
    from '@salesforce/apex/ApplicationController.getMyOfferLetters';

export default class MyApplications extends LightningElement {

    studentId = 'a0AgK000008Vn1RUAS';

    applications = [];
    offerLetters = [];

    @wire(getMyApplications, { studentId: '$studentId' })
    wiredApplications({ data, error }) {

        if (data) {
            this.applications = data;
        } else if (error) {
            console.error('Applications error:', error);
            this.applications = [];
        }
    }

    @wire(getMyOfferLetters, { studentId: '$studentId' })
    wiredOfferLetters({ data, error }) {

        if (data) {
            this.offerLetters = data;
        } else if (error) {
            console.error('Offer Letters error:', error);
            this.offerLetters = [];
        }
    }

    get hasApplications() {
        return this.applications.length > 0;
    }

    get hasOfferLetters() {
        return this.offerLetters.length > 0;
    }
}