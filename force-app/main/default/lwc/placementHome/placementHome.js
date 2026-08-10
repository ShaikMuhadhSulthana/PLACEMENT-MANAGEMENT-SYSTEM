import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import submitApplication from '@salesforce/apex/ApplicationController.submitApplication';

export default class PlacementHome extends LightningElement {

    // ==========================================
    // STUDENT INFORMATION
    // ==========================================

    studentName = 'Sana';

    studentId = 'a0AgK000008Vn1RUAS';


    // ==========================================
    // JOB DATA
    // ==========================================

    jobs = [
        {
            Id: 'a0BgK00000aD9dRUAS',
            Name: 'Salesforce Developer',
            Minimum_CGPA__c: 7,
            Eligible_Branch__c: 'CSE',
            Closing_Date__c: '2026-08-20'
        },
        {
            Id: 'a0BgK00000aGd0fUAC',
            Name: 'Salesforce Developer',
            Minimum_CGPA__c: 7.5,
            Eligible_Branch__c: 'AI & ML',
            Closing_Date__c: '2026-08-25'
        }
    ];


    // ==========================================
    // UI STATE
    // ==========================================

    isLoading = false;

    errorMessage = '';


    // ==========================================
    // CHECK WHETHER JOBS EXIST
    // ==========================================

    get hasJobs() {
        return this.jobs && this.jobs.length > 0;
    }


    // ==========================================
    // EMPTY STATE
    // ==========================================

    get showEmptyState() {
        return !this.isLoading &&
               !this.errorMessage &&
               (!this.jobs || this.jobs.length === 0);
    }


    // ==========================================
    // APPLY BUTTON
    // ==========================================

    handleApply(event) {

        const jobId = event.detail;

        console.log(
            'Apply clicked for Salesforce Job Id:',
            jobId
        );

        console.log(
            'Student Id:',
            this.studentId
        );


        // Clear previous error
        this.errorMessage = '';

        // Start loading
        this.isLoading = true;


        // ==========================================
        // CALL APEX
        // ==========================================

        submitApplication({
            studentId: this.studentId,
            jobId: jobId
        })

        .then(result => {

            console.log(
                'Application submitted successfully:',
                result
            );


            // ==========================================
            // SUCCESS TOAST
            // ==========================================

            this.showToast(
                'Application Submitted',
                result,
                'success'
            );

        })

        .catch(error => {

            console.error(
                'Application failed:',
                JSON.stringify(error)
            );


            // ==========================================
            // ERROR MESSAGE
            // ==========================================

            let message = 'Unable to submit application.';

            if (
                error &&
                error.body &&
                error.body.message
            ) {
                message = error.body.message;
            }

            this.errorMessage = message;


            // ==========================================
            // ERROR TOAST
            // ==========================================

            this.showToast(
                'Application Failed',
                message,
                'error'
            );

        })

        .finally(() => {

            // Stop loading
            this.isLoading = false;

        });
    }


    // ==========================================
    // TOAST METHOD
    // ==========================================

    showToast(title, message, variant) {

        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });

        this.dispatchEvent(event);
    }
}