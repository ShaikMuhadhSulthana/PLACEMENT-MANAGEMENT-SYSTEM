public class TriggerHandler {


    // Before Insert

    public static void beforeInsert(
        List<Application__c> applications
    ){

        ApplicationService.validateApplications(
            applications
        );

    }



    // After Update

    public static void afterUpdate(
        List<Application__c> newApplications,
        Map<Id,Application__c> oldApplications
    ){


        StatisticsService.updateStatistics(
            newApplications,
            oldApplications
        );


        NotificationService.sendNotifications(
            newApplications,
            oldApplications
        );


    }


}