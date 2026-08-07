public class ExpiredJobScheduler implements Schedulable {

    public void execute(SchedulableContext context) {

        List<Job__c> expiredJobs = [
            SELECT Id, Name, Closing_Date__c
            FROM Job__c
            WHERE Closing_Date__c < :Date.today()
        ];

        System.debug(
            'Expired jobs found: ' + expiredJobs.size()
        );

        for (Job__c job : expiredJobs) {

            System.debug(
                'Expired Job: ' + job.Name
            );
        }
    }
}