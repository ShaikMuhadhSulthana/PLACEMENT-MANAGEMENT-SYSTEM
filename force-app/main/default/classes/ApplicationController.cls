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


    @AuraEnabled(cacheable=true)
    public static List<Job__c> getEligibleJobs(
        Id studentId
    ) {
        return ApplicationService.getEligibleJobs(
            studentId
        );
    }


    public class ApplicationView {

        @AuraEnabled
        public Id applicationId;

        @AuraEnabled
        public String applicationName;

        @AuraEnabled
        public String jobName;

        @AuraEnabled
        public String status;

        @AuraEnabled
        public Date applicationDate;

        @AuraEnabled
        public String offerLetterName;


        public ApplicationView(Application__c app) {

            this.applicationId = app.Id;
            this.applicationName = app.Name;

            if (app.Job__r != null) {
                this.jobName = app.Job__r.Name;
            } else {
                this.jobName = '';
            }

            this.status = app.Status__c;
            this.applicationDate = app.Application_Date__c;
            this.offerLetterName = null;
        }
    }


    @AuraEnabled(cacheable=true)
    public static List<ApplicationView> getMyApplications(
        Id studentId
    ) {

        List<Application__c> applications = [
            SELECT Id,
                   Name,
                   Job__c,
                   Job__r.Name,
                   Status__c,
                   Application_Date__c
            FROM Application__c
            WHERE Student__c = :studentId
            ORDER BY CreatedDate DESC
        ];


        List<ApplicationView> results =
            new List<ApplicationView>();


        Map<Id, ApplicationView> applicationMap =
            new Map<Id, ApplicationView>();


        for (Application__c app : applications) {

            ApplicationView view =
                new ApplicationView(app);

            results.add(view);

            applicationMap.put(
                app.Id,
                view
            );
        }


        if (!applicationMap.isEmpty()) {

            List<Offer_Letter__c> offers = [
                SELECT Id,
                       Name,
                       Application__c
                FROM Offer_Letter__c
                WHERE Application__c IN :applicationMap.keySet()
            ];


            for (Offer_Letter__c offer : offers) {

                ApplicationView view =
                    applicationMap.get(
                        offer.Application__c
                    );

                if (view != null) {

                    view.offerLetterName =
                        offer.Name;
                }
            }
        }


        return results;
    }


    @AuraEnabled(cacheable=true)
    public static List<Offer_Letter__c> getMyOfferLetters(
        Id studentId
    ) {

        return [
            SELECT Id,
                   Name,
                   Application__c,
                   Application__r.Name,
                   Application__r.Status__c
            FROM Offer_Letter__c
            WHERE Application__r.Student__c = :studentId
            ORDER BY CreatedDate DESC
        ];
    }

}