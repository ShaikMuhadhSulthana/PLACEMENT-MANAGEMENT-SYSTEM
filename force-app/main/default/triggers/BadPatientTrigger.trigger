trigger BadPatientTrigger on Patient__c (before insert) {

    List<Patient__c> existingPatients = [
        SELECT Id, PatientName__c
        FROM Patient__c
    ];

    for (Patient__c p : Trigger.new) {
        System.debug(existingPatients.size());
    }

}