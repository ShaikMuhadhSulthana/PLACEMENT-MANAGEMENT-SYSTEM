public class ApplicationService {


    // US-13
    // Validate Application before saving

    public static void validateApplications(
        List<Application__c> applications
    ){

        for(Application__c app : applications){


            if(app.Student__c == null){

                app.addError(
                    'Student is required'
                );

            }


            if(app.Job__c == null){

                app.addError(
                    'Job is required'
                );

            }


            if(
                app.Student__c != null &&
                app.Job__c != null
            ){

                Boolean duplicate =
                    checkDuplicateApplication(
                        app.Student__c,
                        app.Job__c
                    );


                if(duplicate){

                    app.addError(
                        'Duplicate Application Found'
                    );

                }

            }

        }

    }



    // Check duplicate applications

    public static Boolean checkDuplicateApplication(
        Id studentId,
        Id jobId
    ){


        List<Application__c> existingApps =
        [
            SELECT Id
            FROM Application__c
            WHERE Student__c = :studentId
            AND Job__c = :jobId
        ];


        return existingApps.size() > 0;

    }



}