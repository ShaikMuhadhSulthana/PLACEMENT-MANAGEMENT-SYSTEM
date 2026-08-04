public class StatisticsService {


    // US-14

    public static void updateStatistics(
        List<Application__c> newApplications,
        Map<Id,Application__c> oldApplications
    ){


        for(Application__c app : newApplications){


            Application__c oldApp =
                oldApplications.get(app.Id);



            if(
                app.Status__c == 'Selected'
                &&
                oldApp.Status__c != 'Selected'
            ){


                System.debug(
                    'Placement Statistics Updated'
                );


            }


        }


    }


}