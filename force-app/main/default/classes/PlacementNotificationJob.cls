public class PlacementNotificationJob implements Queueable {

    private Id offerLetterId;

    public PlacementNotificationJob(Id offerLetterId) {
        this.offerLetterId = offerLetterId;
    }

    public void execute(QueueableContext context) {

        Offer_Letter__c offerLetter = [
            SELECT Id,
                   Name,
                   Status__c,
                   Student__c,
                   Job__c
            FROM Offer_Letter__c
            WHERE Id = :offerLetterId
            LIMIT 1
        ];

        System.debug('======================================');
        System.debug('PLACEMENT NOTIFICATION JOB STARTED');
        System.debug('Offer Letter: ' + offerLetter.Name);
        System.debug('Student: ' + offerLetter.Student__c);
        System.debug('Job: ' + offerLetter.Job__c);
        System.debug('Status: ' + offerLetter.Status__c);

        // Simulating notification preparation.
        System.debug('Placement notification prepared successfully.');

        System.debug('PLACEMENT NOTIFICATION JOB COMPLETED');
        System.debug('======================================');
    }
}