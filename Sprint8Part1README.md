# Placement Management System – Sprint 8: Asynchronous Apex

## Project Overview

The Placement Management System is a Salesforce application designed to manage placement-related activities such as students, jobs, applications, eligibility, application processing, and placement operations. Sprint 8 focuses on Asynchronous Apex and teaches how Salesforce can execute work in the background when that work does not need to block the user's immediate transaction. The main asynchronous Apex mechanisms covered in this sprint are Future Methods, Queueable Apex, Batch Apex, and Scheduled Apex.

The main objective of this sprint is not simply to make everything asynchronous. The objective is to understand which work should happen immediately, which work can happen later, which work involves a large number of records, and which work needs to happen at a particular time.

## Synchronous and Asynchronous Processing

Synchronous processing means the user waits until the current operation finishes. For example, when a student submits an application, the system may immediately check eligibility, check whether a duplicate application exists, save the application, and return the result.

The basic synchronous flow is:

User Request → Business Logic → SOQL/Validation → DML → Transaction Completion → User Response

Asynchronous processing allows Salesforce to perform eligible work separately from the immediate user transaction. The basic flow is:

User Request → Essential Processing → User Response → Background Job → Additional Processing

Asynchronous processing is useful when the user does not need the result of secondary processing immediately, when background work may take longer, when a large number of records need to be processed, or when processing must happen at a particular time.

Asynchronous Apex does not mean that Salesforce Governor Limits disappear. Efficient SOQL, DML, bulkification, error handling, and good Apex design are still required.

## Choosing the Correct Asynchronous Mechanism

The decision should be based on the type of work.

If the user needs the result immediately, synchronous processing is appropriate.

If simple work can happen in the background, a Future Method can be considered.

If structured background processing is required, Queueable Apex can be considered.

If a large number of records must be processed, Batch Apex is appropriate.

If work must happen at a specific time, Scheduled Apex is appropriate.

The decision can be summarized as:

Need the result immediately → Synchronous Processing

Background processing → Future or Queueable

Large-volume processing → Batch Apex

Time-based processing → Scheduled Apex

Time-based large-volume processing → Scheduled Apex can start Batch Apex.

## Existing Apex Structure

Before Sprint 8, the project contained the following Apex classes:

ApplicationService.cls

DataService.cls

TriggerHandler.cls

Sprint 8 adds asynchronous processing classes:

ApplicationFuture.cls

ApplicationQueueable.cls

PlacementAnalyticsBatch.cls

ExpiredJobScheduler.cls

The resulting class structure is:

force-app/
└── main/
    └── default/
        └── classes/
            ├── ApplicationService.cls
            ├── ApplicationService.cls-meta.xml
            ├── DataService.cls
            ├── DataService.cls-meta.xml
            ├── TriggerHandler.cls
            ├── TriggerHandler.cls-meta.xml
            ├── ApplicationFuture.cls
            ├── ApplicationFuture.cls-meta.xml
            ├── ApplicationQueueable.cls
            ├── ApplicationQueueable.cls-meta.xml
            ├── PlacementAnalyticsBatch.cls
            ├── PlacementAnalyticsBatch.cls-meta.xml
            ├── ExpiredJobScheduler.cls
            └── ExpiredJobScheduler.cls-meta.xml

## Future Apex

A Future Method allows a static Apex method to execute asynchronously. It is useful for simple background processing where the user does not need to wait for the operation to finish.

The project contains ApplicationFuture.cls.

Example implementation:

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

The method receives the Application Id and retrieves the Application record inside the asynchronous method.

The execution flow is:

Application Submitted → Immediate Transaction → Application Saved → Future Job Submitted → Future Executes Later → Application Retrieved → Background Processing

An Application Id can be retrieved through Execute Anonymous using:

List<Application__c> applications = [
    SELECT Id, Name, Status__c
    FROM Application__c
    LIMIT 10
];

for (Application__c app : applications) {

    System.debug(
        'Application Id: ' + app.Id +
        ' | Name: ' + app.Name +
        ' | Status: ' + app.Status__c
    );
}

The Future Method can then be tested using:

Application__c app = [
    SELECT Id
    FROM Application__c
    LIMIT 1
];

ApplicationFuture.processApplicationAsync(app.Id);

System.debug(
    'Future job submitted for Application: ' + app.Id
);

The debug log can be checked to verify the execution.

## Queueable Apex

Queueable Apex represents a structured unit of asynchronous work. It is useful when background processing requires a dedicated class and a more structured job-oriented design.

The project contains ApplicationQueueable.cls.

Example implementation:

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

The Queueable job can be submitted using Execute Anonymous:

Application__c app = [
    SELECT Id
    FROM Application__c
    LIMIT 1
];

Id jobId = System.enqueueJob(
    new ApplicationQueueable(app.Id)
);

System.debug(
    'Queueable Job Id: ' + jobId
);

The execution flow is:

Application Event → Create Queueable Job → Salesforce Async Queue → execute() → Background Processing

Queueable Apex is useful for structured background processing, especially when the asynchronous operation needs more organization than a simple Future Method.

Future and Queueable are both asynchronous, but Queueable provides a more structured job model.

Future is suitable for simple asynchronous work.

Queueable is suitable for structured asynchronous work.

## Batch Apex

Batch Apex is designed for processing large datasets. Instead of processing a very large number of records in one transaction, Salesforce processes them in manageable batches.

The basic Batch Apex flow is:

start() → Identify Records → execute() → Process Each Batch → finish() → Complete Overall Job

The project contains PlacementAnalyticsBatch.cls.

Example implementation:

public class PlacementAnalyticsBatch
    implements Database.Batchable<SObject> {

    public Database.QueryLocator start(
        Database.BatchableContext context
    ) {

        return Database.getQueryLocator(
            'SELECT Id, Name, Status__c FROM Application__c'
        );
    }

    public void execute(
        Database.BatchableContext context,
        List<Application__c> scope
    ) {

        System.debug(
            'Processing batch of ' + scope.size() + ' applications.'
        );

        for (Application__c applicationRecord : scope) {

            System.debug(
                'Processing Application: '
                + applicationRecord.Id
            );
        }
    }

    public void finish(
        Database.BatchableContext context
    ) {

        System.debug(
            'Placement Analytics Batch completed.'
        );
    }
}

The start() method identifies the records that need to be processed.

The execute() method processes each group of records.

The finish() method executes after all batches are completed.

The Batch Apex class can be tested using Execute Anonymous:

Id jobId = Database.executeBatch(
    new PlacementAnalyticsBatch(),
    200
);

System.debug(
    'Batch Job Id: ' + jobId
);

The value 200 represents the batch size.

The conceptual flow is:

Application Records → Batch Size 200 → Batch 1 → Batch 2 → Batch 3 → ... → finish()

Batch Apex is appropriate when the application needs to process a large volume of records.

## Batch Apex Deployment Issue and Resolution

During deployment of PlacementAnalyticsBatch.cls, a deployment error occurred:

ERROR: classes/PlacementAnalyticsBatch.cls-meta.xml: Invalid api version:0.0

The issue was caused by an invalid API version in the metadata file. The metadata file contained an invalid value such as:

<apiVersion>0.0</apiVersion>

Salesforce does not accept 0.0 as a valid API version.

The solution was to update the API version in PlacementAnalyticsBatch.cls-meta.xml to a valid Salesforce API version matching the project's Apex configuration.

This demonstrated that an Apex class consists of both the .cls file and its corresponding .cls-meta.xml file, and both must contain valid configuration.

## Scheduled Apex

Scheduled Apex allows Apex code to execute at a specified time. Unlike a Trigger, which executes because of a record event, Scheduled Apex uses time as the event.

Example:

Every morning at 5:00 AM → Run Processing

The project contains ExpiredJobScheduler.cls.

Example implementation:

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

The Scheduler checks whether Closing_Date__c is earlier than today's date:

Closing_Date__c < :Date.today()

This identifies jobs whose closing date has already passed.

The processing flow is:

Scheduled Time → ExpiredJobScheduler → Query Job__c → Check Closing_Date__c → Find Expired Jobs → Process Results

The Scheduler can be registered using Execute Anonymous:

String cronExpression = '0 0 5 * * ?';

Id jobId = System.schedule(
    'Daily Expired Job Processing',
    cronExpression,
    new ExpiredJobScheduler()
);

System.debug(
    'Scheduled Job Id: ' + jobId
);

The Cron expression 0 0 5 * * ? represents a daily scheduled execution at 5:00 AM.

## Apex Jobs

Asynchronous Apex jobs can be monitored from Salesforce.

The navigation is:

Salesforce → Setup → Quick Find → Apex Jobs

The Apex Jobs page can be used to monitor asynchronous processing.

The page can be checked for information such as:

Job Type

Status

Created Date

Completed Date

Number of Errors

Possible statuses include:

Queued

Processing

Completed

Failed

Aborted

Future, Queueable, Batch, and Scheduled processing can be associated with asynchronous jobs that can be monitored through Salesforce's job and scheduling interfaces.

## Testing Process

The testing process followed during Sprint 8 was:

Create Apex Class → Save Code → Deploy to Salesforce → Open Execute Anonymous → Run Test Code → Check Debug Logs → Check Apex Jobs → Capture Screenshot

The same overall process was followed for Future, Queueable, Batch, and Scheduled Apex.

Future testing used ApplicationFuture.processApplicationAsync().

Queueable testing used System.enqueueJob().

Batch testing used Database.executeBatch().

Scheduled testing used System.schedule().

## Application Id Retrieval

When an Application Id was required for testing, the following Apex code could be used:

List<Application__c> applications = [
    SELECT Id, Name, Status__c
    FROM Application__c
    LIMIT 10
];

for (Application__c app : applications) {

    System.debug(
        'Application Id: ' + app.Id +
        ' | Name: ' + app.Name +
        ' | Status: ' + app.Status__c
    );
}

This displays Application Ids in the debug log.

A single Application can also be retrieved using:

Application__c app = [
    SELECT Id
    FROM Application__c
    LIMIT 1
];

The Id can then be passed to Future or Queueable processing.

## Execute Anonymous Test Commands

Future:

Application__c app = [
    SELECT Id
    FROM Application__c
    LIMIT 1
];

ApplicationFuture.processApplicationAsync(app.Id);

System.debug(
    'Future job submitted for Application: ' + app.Id
);

Queueable:

Application__c app = [
    SELECT Id
    FROM Application__c
    LIMIT 1
];

Id jobId = System.enqueueJob(
    new ApplicationQueueable(app.Id)
);

System.debug(
    'Queueable Job Id: ' + jobId
);

Batch:

Id jobId = Database.executeBatch(
    new PlacementAnalyticsBatch(),
    200
);

System.debug(
    'Batch Job Id: ' + jobId
);

Scheduled:

String cronExpression = '0 0 5 * * ?';

Id jobId = System.schedule(
    'Daily Expired Job Processing',
    cronExpression,
    new ExpiredJobScheduler()
);

System.debug(
    'Scheduled Job Id: ' + jobId
);

## Business Scenarios

For immediate eligibility validation, synchronous processing is appropriate because the student needs the result immediately.

For simple background processing after an application is submitted, Future or Queueable Apex can be considered.

For structured background processing, Queueable Apex is appropriate.

For processing a large number of historical application records, Batch Apex is appropriate.

For identifying expired jobs every day, Scheduled Apex is appropriate.

For time-based large-volume processing, Scheduled Apex can start Batch Apex.

## Asynchronous Apex Comparison

| Feature | Future | Queueable | Batch | Scheduled |
|---|---|---|---|---|
| Asynchronous | Yes | Yes | Yes | Yes |
| Background Processing | Yes | Yes | Yes | Yes |
| Large Dataset | Not ideal | Not ideal | Best suited | Can start Batch |
| Time Based | No | No | No | Yes |
| Structured Job | Limited | Strong | Strong | Strong |
| Main Purpose | Simple Async Work | Structured Async Work | Large Data Processing | Time-Based Processing |

## Overall Project Architecture

The Placement Management System now has both immediate and asynchronous processing.

The architecture can be represented as:

PLACEMENT MANAGEMENT SYSTEM

Application Event → ApplicationService → Immediate Processing

Background Work → Future / Queueable → Background Processing

Large Dataset → Batch Apex → Batch Processing

Time-Based Event → Scheduled Apex → Scheduled Processing

A more detailed conceptual architecture is:

PLACEMENT MANAGEMENT SYSTEM
|
+-- Immediate Business Logic
|       |
|       +-- ApplicationService
|       +-- DataService
|       +-- TriggerHandler
|
+-- Asynchronous Processing
        |
        +-- ApplicationFuture
        |
        +-- ApplicationQueueable
        |
        +-- PlacementAnalyticsBatch
        |
        +-- ExpiredJobScheduler

## Combining Asynchronous Mechanisms

Asynchronous mechanisms can be combined when a business requirement needs more than one asynchronous characteristic.

For example:

Scheduled Apex → Start Batch Apex → Process Large Dataset → Finish

A possible business requirement could be:

Every Sunday → Start Placement Analytics → Process Applications in Batches → Complete Analytics Processing

This combines the time-based capability of Scheduled Apex with the large-volume capability of Batch Apex.

## Engineering Lessons Learned

The first important lesson is that not everything should happen asynchronously. Operations that the user needs immediately should remain synchronous.

The second lesson is that asynchronous processing does not remove Salesforce Governor Limits. Efficient SOQL, DML, bulkification, and error handling remain important.

The third lesson is that the correct asynchronous mechanism depends on the workload.

Future is useful for simple background work.

Queueable is useful for structured background processing.

Batch is useful for large datasets.

Scheduled Apex is useful for time-based execution.

The fourth lesson is that asynchronous mechanisms can work together.

For example:

Scheduled Apex → Batch Apex

can support scheduled large-volume processing.

The fifth lesson is that metadata files are important. The deployment issue with PlacementAnalyticsBatch.cls-meta.xml demonstrated that an invalid API version can prevent deployment even when the Apex class itself does not contain a file-level code error.

## Screenshot Evidence

Screenshots were captured during implementation and testing.

The evidence includes the Future Apex code and test, Queueable Apex code and test, Batch Apex code and test, Scheduled Apex code and test, and Apex Jobs verification.

Recommended screenshot organization is:

screenshots/
├── future-code.png
├── future-test.png
├── queueable-code.png
├── queueable-test.png
├── batch-code.png
├── batch-test.png
├── scheduled-code.png
├── scheduled-test.png
└── apex-jobs.png

These screenshots serve as evidence that the asynchronous Apex implementations were created, executed, tested, and verified.

## Interview Questions and Answers

### What is Asynchronous Apex?

Asynchronous Apex allows Salesforce to execute eligible work separately from the immediate user transaction.

### Why is asynchronous processing useful?

It is useful when the user does not need to wait for secondary processing to complete.

### What are the main asynchronous Apex mechanisms?

Future Methods, Queueable Apex, Batch Apex, and Scheduled Apex.

### What is a Future Method?

A Future Method allows a static Apex method to execute asynchronously.

### What is Queueable Apex?

Queueable Apex represents a structured asynchronous job that Salesforce places into its processing queue.

### When should Batch Apex be used?

Batch Apex should be considered when a large number of records must be processed in manageable chunks.

### What are the three main Batch Apex methods?

start(), execute(), and finish().

### What is Scheduled Apex?

Scheduled Apex allows Apex code to execute at a specified time.

### Can Scheduled Apex start Batch Apex?

Yes. Scheduled Apex can start Batch Apex when processing needs to happen at a particular time and involves a large dataset.

### Does asynchronous Apex remove Governor Limits?

No. Asynchronous Apex still operates within Salesforce platform limits.

### Why is Queueable useful?

Queueable provides a structured job-oriented model for asynchronous processing and is useful when background work needs more organization than a simple Future Method.

### Why should every operation not be asynchronous?

Some operations require an immediate result. For example, eligibility validation and duplicate application checking may need to happen before the user receives the result of an application submission.

## Sprint 8 Completion

Implementation completed:

ApplicationFuture.cls – Completed

ApplicationQueueable.cls – Completed

PlacementAnalyticsBatch.cls – Completed

ExpiredJobScheduler.cls – Completed

Future Apex – Implemented and tested

Queueable Apex – Implemented and tested

Batch Apex – Implemented and tested

Scheduled Apex – Implemented and tested

Application Id retrieval – Tested

Execute Anonymous – Used

Debug Logs – Checked

Apex Jobs – Checked

Screenshots – Captured

Documentation – Completed

Batch metadata API version issue – Resolved

## Final Conclusion

Sprint 8 introduced Asynchronous Apex into the Placement Management System. The project now demonstrates Future Methods, Queueable Apex, Batch Apex, and Scheduled Apex.

Future Apex provides a mechanism for simple background processing.

Queueable Apex provides structured asynchronous processing.

Batch Apex provides a mechanism for processing large datasets in manageable groups.

Scheduled Apex provides time-based execution.

The most important architectural lesson from this sprint is that the developer should decide when the work needs to happen before choosing the Apex mechanism.

Immediate work should happen synchronously.

Simple background work can use Future Apex.

Structured background work can use Queueable Apex.

Large-volume processing can use Batch Apex.

Time-based processing can use Scheduled Apex.

Time-based large-volume processing can combine Scheduled Apex with Batch Apex.

The final architecture therefore supports both immediate business processing and background processing while keeping responsibilities separated and making the application more scalable.

## Sprint 8 Final Status

========================================
SPRINT 8 – COMPLETED
========================================

# End of Sprint 8