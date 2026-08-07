public class OfferPostProcessingJob implements Queueable {

    private Id offerLetterId;

    public OfferPostProcessingJob(Id offerLetterId) {
        this.offerLetterId = offerLetterId;
    }

    public void execute(QueueableContext context) {

        Offer_Letter__c offerLetter = [
            SELECT Id,
                   Name,
                   Application__c,
                   Job__c,
                   Offer_Date__c,
                   Status__c,
                   Student__c
            FROM Offer_Letter__c
            WHERE Id = :offerLetterId
            LIMIT 1
        ];

        System.debug('======================================');
        System.debug('Offer Letter Post Processing Started');
        System.debug('Offer Letter Id: ' + offerLetter.Id);
        System.debug('Offer Number: ' + offerLetter.Name);
        System.debug('Application Id: ' + offerLetter.Application__c);
        System.debug('Job Id: ' + offerLetter.Job__c);
        System.debug('Offer Date: ' + offerLetter.Offer_Date__c);
        System.debug('Status: ' + offerLetter.Status__c);
        System.debug('Student Id: ' + offerLetter.Student__c);
        System.debug('Offer Letter Post Processing Completed');
        System.debug('======================================');
    }
}