import { LightningElement } from 'lwc';

import submitApplication
    from '@salesforce/apex/ApplicationController.submitApplication';

export default class EligibleJobs extends LightningElement {

    handleApply(event) {

        const jobId = event.detail.jobId;

        console.log(
            'EligibleJobs received Job Id:',
            jobId
        );

        submitApplication({
            jobId: jobId
        })
        .then(applicationId => {

            console.log(
                'Application created successfully:',
                applicationId
            );

        })
        .catch(error => {

            console.error(
                'Application submission failed:',
                error
            );

        });
    }
}