import { LightningElement, wire } from 'lwc';

import getEligibleJobs from '@salesforce/apex/ApplicationController.getEligibleJobs';

export default class StudentPortal extends LightningElement {

    studentId = 'a0AgK000008Vn1RUAS';

    jobs = [];

    @wire(getEligibleJobs, { studentId: '$studentId' })
    wiredJobs({ data, error }) {

        if (data) {

            console.log('Eligible Jobs received:', data);

            this.jobs = data;

        } else if (error) {

            console.error('Error loading eligible jobs:', error);

            this.jobs = [];

        }

    }

    handleProfileSaved(event) {

        console.log(
            'Profile saved for Student:',
            event.detail.studentId
        );

    }

}