import { LightningElement, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import STUDENT_NAME from '@salesforce/schema/Student__c.Name';
import STUDENT_CGPA from '@salesforce/schema/Student__c.CGPA__c';

const FIELDS = [
    STUDENT_NAME,
    STUDENT_CGPA
];

export default class StudentSummary extends LightningElement {

    studentId = 'a0AgK000008Vn1RUAS';

    @wire(getRecord, {
        recordId: '$studentId',
        fields: FIELDS
    })
    student;

    get studentName() {
        return getFieldValue(this.student.data, STUDENT_NAME);
    }

    get cgpa() {
        return getFieldValue(this.student.data, STUDENT_CGPA);
    }

    get hasStudentData() {
        return this.student && this.student.data;
    }
}