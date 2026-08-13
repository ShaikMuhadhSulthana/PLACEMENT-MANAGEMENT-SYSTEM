import { LightningElement, api } from 'lwc';

export default class ChildCommunication extends LightningElement {
    @api patientId;

    handleNotifyParent() {
        const childEvent = new CustomEvent('childnotification', {
            detail: 'Child button was clicked successfully'
        });

        this.dispatchEvent(childEvent);
    }
}