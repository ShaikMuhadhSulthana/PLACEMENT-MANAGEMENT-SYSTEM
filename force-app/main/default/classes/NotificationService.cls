public class NotificationService {



    // US-15

    public static void sendNotifications(
        List<Application__c> newApplications,
        Map<Id,Application__c> oldApplications
    ){


        for(Application__c app : newApplications){


            Application__c oldApp =
                oldApplications.get(app.Id);



            if(
                app.Status__c != oldApp.Status__c
            ){


                if(
                    app.Status__c == 'Selected'
                    ||
                    app.Status__c == 'Rejected'
                    ||
                    app.Status__c == 'Interview Scheduled'
                    ||
                    app.Status__c == 'Offer Accepted'
                ){


                    System.debug(
                        'Notification Sent'
                    );


                }


            }


        }


    }


}