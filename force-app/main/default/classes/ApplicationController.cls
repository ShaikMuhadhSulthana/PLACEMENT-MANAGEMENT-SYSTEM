public with sharing class ApplicationController {

    @AuraEnabled
    public static Id submitApplication(
        Id studentId,
        Id jobId
    ) {

        return ApplicationService.submitApplication(
            studentId,
            jobId
        );
    }
}