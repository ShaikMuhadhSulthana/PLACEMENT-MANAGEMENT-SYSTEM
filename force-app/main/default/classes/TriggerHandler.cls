public class TriggerHandler {

    // Before Insert
    public static void beforeInsert(
        List<Application__c> applications
    ) {

        ApplicationService.validateApplications(
            applications
        );
    }


    // After Update
    public static void afterUpdate(
        List<Application__c> newApplications,
        Map<Id, Application__c> oldApplications
    ) {

        // Existing Sprint 7 logic
        StatisticsService.updateStatistics(
            newApplications,
            oldApplications
        );

        NotificationService.sendNotifications(
            newApplications,
            oldApplications
        );


        // Sprint 11 - External Recruitment Integration
        for (Application__c application : newApplications) {

            Application__c oldApplication =
                oldApplications.get(application.Id);

            if (
                application.Status__c == 'Selected' &&
                oldApplication.Status__c != 'Selected'
            ) {

                System.enqueueJob(
                    new CandidateSyncQueueable(application.Id)
                );
            }
        }
    }
}