public class PlacementCategoryBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext context) {

        return Database.getQueryLocator([
            SELECT Id,
                   Name,
                   Status__c,
                   Placement_Category__c
            FROM Application__c
            WHERE Placement_Category__c = NULL
        ]);
    }

    public void execute(
        Database.BatchableContext context,
        List<Application__c> scope
    ) {

        for (Application__c app : scope) {

            if (app.Status__c == 'Selected') {
                app.Placement_Category__c = 'Placed';
            } else {
                app.Placement_Category__c = 'Not Placed';
            }
        }

        if (!scope.isEmpty()) {
            update scope;
        }
    }

    public void finish(Database.BatchableContext context) {

        System.debug('======================================');
        System.debug('Placement Category Batch Completed');
        System.debug('Batch Job Id: ' + context.getJobId());
        System.debug('======================================');
    }
}