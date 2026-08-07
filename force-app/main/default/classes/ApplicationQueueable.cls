public class ApplicationQueueable implements Queueable {

    private Id applicationId;

    public ApplicationQueueable(Id applicationId) {
        this.applicationId = applicationId;
    }

    public void execute(QueueableContext context) {

        Application__c applicationRecord = [
            SELECT Id, Name, Status__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        System.debug(
            'Queueable processing started for Application: '
            + applicationRecord.Id
        );

        System.debug(
            'Application Status: '
            + applicationRecord.Status__c
        );
    }
}