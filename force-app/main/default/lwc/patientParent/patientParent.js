import { LightningElement } from 'lwc';

export default class PatientParent extends LightningElement {

    patientId = 'P001';

    message = 'Waiting for child event...';

    handleNotify() {
        this.message = 'Message received from Child Component!';
    }

}