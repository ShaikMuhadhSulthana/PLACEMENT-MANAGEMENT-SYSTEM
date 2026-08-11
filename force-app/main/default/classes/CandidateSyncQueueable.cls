public class CandidateSyncQueueable implements Queueable, Database.AllowsCallouts {

    private Id applicationId;

    public CandidateSyncQueueable(Id applicationId) {
        this.applicationId = applicationId;
    }

    public void execute(QueueableContext context) {

        Application__c applicationRecord = [
            SELECT Id,
                   Name,
                   Student__c,
                   Student__r.Name,
                   Student__r.Email__c,
                   Student__r.CGPA__c,
                   Job__c,
                   Job__r.Name,
                   Status__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        if (applicationRecord.Status__c != 'Selected') {
            return;
        }

        HttpRequest request = new HttpRequest();

        request.setEndpoint('callout:Recruitment_API');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        Map<String, Object> requestBody = new Map<String, Object>();

        requestBody.put('applicationId', applicationRecord.Id);
        requestBody.put('studentId', applicationRecord.Student__c);
        requestBody.put('name', applicationRecord.Student__r.Name);
        requestBody.put('email', applicationRecord.Student__r.Email__c);
        requestBody.put('cgpa', applicationRecord.Student__r.CGPA__c);
        requestBody.put('jobId', applicationRecord.Job__c);
        requestBody.put('jobName', applicationRecord.Job__r.Name);
        requestBody.put('selectionDate', Date.today());
        System.debug('### NEW CANDIDATE PAYLOAD ### ' + JSON.serialize(requestBody));

        request.setBody(JSON.serialize(requestBody));
        System.debug('FINAL REQUEST BODY = ' + request.getBody());

        Http http = new Http();

        try {

            HttpResponse response = http.send(request);

            applicationRecord.Last_Integration_Attempt__c = System.now();

            if (response.getStatusCode() >= 200 &&
                response.getStatusCode() < 300) {

                applicationRecord.Integration_Status__c = 'Sent';
                applicationRecord.Integration_Error__c = null;

            } else {

                applicationRecord.Integration_Status__c = 'Failed';

                applicationRecord.Integration_Error__c =
                    'HTTP ' +
                    response.getStatusCode() +
                    ': ' +
                    response.getBody();
            }

        } catch (Exception e) {

            applicationRecord.Last_Integration_Attempt__c = System.now();

            applicationRecord.Integration_Status__c = 'Failed';

            applicationRecord.Integration_Error__c =
                e.getMessage();
        }

        update applicationRecord;
    }
}