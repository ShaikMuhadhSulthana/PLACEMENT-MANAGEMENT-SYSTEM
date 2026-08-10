import { LightningElement, api } from 'lwc';

export default class JobCard extends LightningElement {

    @api job;

    isApplying = false;


    // ==========================================
    // APPLY BUTTON LABEL
    // ==========================================

    get buttonLabel() {

        if (this.isApplying) {
            return 'Applying...';
        }

        return 'Apply';
    }


    // ==========================================
    // APPLY BUTTON
    // ==========================================

    handleApply() {

        // Prevent multiple clicks
        if (this.isApplying) {
            return;
        }


        // Make sure job exists
        if (!this.job) {

            console.error(
                'Job information is missing.'
            );

            return;
        }


        // Get Salesforce Job Id
        const jobId = this.job.Id;


        console.log(
            'Job Card Job Id:',
            jobId
        );


        // Start loading
        this.isApplying = true;


        // Send event to parent
        this.dispatchEvent(
            new CustomEvent('apply', {
                detail: jobId
            })
        );
    }
}