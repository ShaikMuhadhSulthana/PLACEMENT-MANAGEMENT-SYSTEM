public class ExternalPlacementSyncJob implements Queueable {

    private Id applicationId;

    public ExternalPlacementSyncJob(Id applicationId) {
        this.applicationId = applicationId;
    }

    public void execute(QueueableContext context) {

        System.debug('ExternalPlacementSyncJob started');
        System.debug('Application Id: ' + applicationId);

        // Simulate external system synchronisation
        System.debug('Synchronising placement information with external system...');

        // After successful synchronisation,
        // start the notification job.
        System.enqueueJob(
            new PlacementNotificationJob(applicationId)
        );

        System.debug('External synchronisation completed successfully');
        System.debug('PlacementNotificationJob has been queued');
    }
}