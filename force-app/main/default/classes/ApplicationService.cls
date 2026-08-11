public class ApplicationService {

    // US-13
    // Validate Application before saving
    public static void validateApplications(
        List<Application__c> applications
    ) {

        for (Application__c app : applications) {

            if (app.Student__c == null) {
                app.addError(
                    'Student is required'
                );
            }

            if (app.Job__c == null) {
                app.addError(
                    'Job is required'
                );
            }

            if (
                app.Student__c != null &&
                app.Job__c != null
            ) {

                Boolean duplicate =
                    checkDuplicateApplication(
                        app.Student__c,
                        app.Job__c
                    );

                if (duplicate) {
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
    ) {

        List<Application__c> existingApps = [
            SELECT Id
            FROM Application__c
            WHERE Student__c = :studentId
            AND Job__c = :jobId
        ];

        return existingApps.size() > 0;
    }


    // Submit a new application
    public static Id submitApplication(
        Id studentId,
        Id jobId
    ) {

        // Get Student details
        Student__c student = [
            SELECT Id, CGPA__c
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];


        // Get Job details
        Job__c job = [
            SELECT Id, Minimum_CGPA__c
            FROM Job__c
            WHERE Id = :jobId
            LIMIT 1
        ];


        // Check CGPA eligibility
        if (
            student.CGPA__c != null &&
            job.Minimum_CGPA__c != null &&
            student.CGPA__c < job.Minimum_CGPA__c
        ) {

            throw new AuraHandledException(
                'You do not meet the minimum CGPA requirement for this job.'
            );
        }


        // Check for duplicate application
        if (checkDuplicateApplication(studentId, jobId)) {

            throw new AuraHandledException(
                'Duplicate Application Found'
            );
        }


        // Create Application record
        Application__c applicationRecord =
            new Application__c(
                Student__c = studentId,
                Job__c = jobId
            );


        // Insert Application
        insert applicationRecord;


        // Return Application Id
        return applicationRecord.Id;
    }


    // Get eligible jobs for a student
    public static List<Job__c> getEligibleJobs(
        Id studentId
    ) {

        // Get Student details
        Student__c student = [
            SELECT Id, CGPA__c
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];


        // Get eligible Jobs
        return [
            SELECT Id,
                   Name,
                   Minimum_CGPA__c,
                   Closing_Date__c
            FROM Job__c
            WHERE Minimum_CGPA__c <= :student.CGPA__c
            AND Closing_Date__c >= :Date.today()
            ORDER BY Closing_Date__c ASC
        ];
    }

}