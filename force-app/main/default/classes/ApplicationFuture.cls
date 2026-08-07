public class ApplicationFuture {

    @future
    public static void processApplicationAsync(Id applicationId) {

        Application__c applicationRecord = [
            SELECT Id, Name, Status__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        System.debug(
            'Future processing started for Application: '
            + applicationRecord.Id
        );

        System.debug(
            'Application Status: '
            + applicationRecord.Status__c
        );
    }
}