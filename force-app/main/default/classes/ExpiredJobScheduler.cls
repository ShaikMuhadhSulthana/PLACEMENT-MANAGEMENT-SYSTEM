public class ExpiredJobScheduler implements Schedulable {

    public void execute(SchedulableContext context) {

        List<Job__c> expiredJobs = [
            SELECT Id, Name, Closing_Date__c, Status__c
            FROM Job__c
            WHERE Closing_Date__c < :Date.today()
            AND Status__c = 'Open'
        ];

        for (Job__c job : expiredJobs) {
            job.Status__c = 'Expired';
        }

        if (!expiredJobs.isEmpty()) {
            update expiredJobs;
        }

        System.debug('Expired jobs updated: ' + expiredJobs.size());
    }
}