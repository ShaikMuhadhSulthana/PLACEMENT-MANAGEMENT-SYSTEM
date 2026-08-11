import { LightningElement } from 'lwc';

export default class StudentProfile extends LightningElement {

    studentId = 'a0AgK000008Vn1RUAS';

    handleSuccess(event) {

        console.log(
            'Student profile saved successfully:',
            event.detail.id
        );

        this.dispatchEvent(
            new CustomEvent('profilesaved', {
                detail: {
                    studentId: event.detail.id
                }
            })
        );
    }

    handleError(event) {

        console.error(
            'Student profile save failed:',
            event.detail
        );

    }
}