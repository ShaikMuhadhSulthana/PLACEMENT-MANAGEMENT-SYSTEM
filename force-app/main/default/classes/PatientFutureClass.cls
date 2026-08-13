public class PatientFutureClass {

    @future
    public static void updatePatient(String patientId){

        Patient__c p = [
            SELECT Id, PatientName__c
            FROM Patient__c
            WHERE Id = :patientId
            LIMIT 1
        ];

        p.PatientName__c = p.PatientName__c + ' - Updated';

        update p;
    }
}