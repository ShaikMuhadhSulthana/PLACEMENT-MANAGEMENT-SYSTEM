# Sprint 11 — Integrating Salesforce with External Systems

## 📌 Project: Placement Management System

Sprint 11 focuses on integrating the Salesforce Placement Management System with an external Recruitment System using asynchronous Apex, Named Credentials, External Credentials, REST API callouts, error handling, retry strategy, and idempotency.

---

# 1. 📖 Overview

The Placement Management System manages students, jobs, applications, selections, and offer-related information.

In this sprint, the Salesforce application is integrated with an external Recruitment System.

Whenever a student's application status changes to **Selected**, Salesforce automatically sends the selected candidate's information to the external recruitment system through a REST API.

The integration uses:

- Apex Trigger
- Trigger Handler
- Queueable Apex
- Database.AllowsCallouts
- Named Credential
- External Credential
- Permission Set
- HTTP POST
- JSON serialization
- Integration status tracking
- Error handling
- Retry strategy
- Idempotency strategy

---

# 2. 🎯 Business Problem

The Placement Management System stores candidate selection information inside Salesforce.

However, the external Recruitment System also needs the selected candidate's information.

Manually transferring selected candidate information creates several problems:

- Manual effort
- Data entry errors
- Delayed synchronization
- Duplicate candidate submissions
- Lack of integration monitoring
- Difficulty tracking failed requests

The goal of this integration is to automatically synchronize selected candidates from Salesforce to the external Recruitment System.

---

# 3. 🏗️ Integration Architecture

The integration follows an asynchronous architecture.

```text
                     Salesforce
                         │
                         ▼
                Application__c
                         │
                 Status = Selected
                         │
                         ▼
               ApplicationTrigger
                         │
                         ▼
                  TriggerHandler
                         │
                         ▼
             CandidateSyncQueueable
                         │
                 Queueable Apex
                         │
                         ▼
                 Named Credential
                  Recruitment_API
                         │
                         ▼
               External Credential
                         │
                         ▼
                    HTTP POST
                         │
                         ▼
              External Recruitment API
                         │
                         ▼
                   Webhook.site
````

---

# 4. 🔄 End-to-End Data Flow

The complete integration flow is:

```text
Application Status Updated
          ↓
Status becomes "Selected"
          ↓
ApplicationTrigger executes
          ↓
TriggerHandler.afterUpdate()
          ↓
CandidateSyncQueueable is enqueued
          ↓
Queueable queries Application,
Student and Job information
          ↓
Candidate JSON payload is created
          ↓
HTTP POST request
          ↓
Named Credential
          ↓
External API
          ↓
Response received
          ↓
Integration status updated
```

---

# 5. ⚡ Why Queueable Apex?

Queueable Apex was selected because the external API callout should not block the Salesforce transaction.

The integration uses:

```apex
public class CandidateSyncQueueable
    implements Queueable, Database.AllowsCallouts
```

Queueable Apex provides:

* Asynchronous processing
* Support for callouts
* Better separation between Salesforce transaction and external communication
* Ability to monitor the asynchronous job
* Better scalability than performing the callout directly inside the trigger

---

# 6. 🔥 Trigger Architecture

The trigger is implemented on:

```text
Application__c
```

Events:

```text
before insert
after update
```

The trigger delegates business logic to `TriggerHandler`.

```text
ApplicationTrigger
       │
       ▼
TriggerHandler
       │
       ├── beforeInsert()
       │
       └── afterUpdate()
```

---

# 7. 🎯 Selected Candidate Detection

The integration only runs when an application changes to:

```text
Selected
```

The handler compares the new and old status values.

Conceptually:

```apex
if (
    application.Status__c == 'Selected' &&
    oldApplication.Status__c != 'Selected'
) {
    System.enqueueJob(
        new CandidateSyncQueueable(application.Id)
    );
}
```

This prevents the integration from being unnecessarily triggered when the application remains in the same status.

---

# 8. 🚀 CandidateSyncQueueable

The Queueable class is responsible for:

1. Retrieving the Application
2. Retrieving Student information
3. Retrieving Job information
4. Building the JSON payload
5. Sending the HTTP POST request
6. Processing the HTTP response
7. Updating integration tracking fields

The class implements:

```apex
Queueable
Database.AllowsCallouts
```

---

# 9. 📦 Candidate Payload

The external Recruitment System receives the following information:

```json
{
  "selectionDate": "2026-08-11",
  "jobName": "Salesforce Developer",
  "jobId": "a0BgK00000aGd0fUAC",
  "cgpa": 10,
  "email": "sana@gmail.com",
  "name": "Sana",
  "studentId": "a0AgK000008Vn1RUAS",
  "applicationId": "a0CgK000010lYD4UAM"
}
```

---

# 10. 📋 API Request Fields

| Field         | Description                   | Salesforce Source         |
| ------------- | ----------------------------- | ------------------------- |
| applicationId | Unique application identifier | Application__c.Id         |
| studentId     | Student identifier            | Application__c.Student__c |
| name          | Candidate name                | Student__r.Name           |
| email         | Candidate email               | Student__r.Email__c       |
| cgpa          | Candidate CGPA                | Student__r.CGPA__c        |
| jobId         | Job identifier                | Application__c.Job__c     |
| jobName       | Job name                      | Job__r.Name               |
| selectionDate | Date candidate was selected   | Date.today()              |

---

# 11. 🌐 HTTP Integration

The Queueable creates an HTTP request:

```text
Method:
POST
```

Endpoint:

```text
callout:Recruitment_API
```

The endpoint is referenced through a Salesforce Named Credential rather than hardcoding the external URL in Apex.

Request header:

```text
Content-Type: application/json
```

---

# 12. 🔐 Authentication and Security

The integration uses Salesforce's modern Named Credential architecture.

```text
Apex
  ↓
Named Credential
  ↓
External Credential
  ↓
Principal / Permission Set
  ↓
External API
```

Sensitive authentication information is not stored directly inside Apex code.

This provides:

* Centralized endpoint configuration
* Better credential management
* Improved security
* Separation of code and authentication configuration
* Easier maintenance

---

# 13. 🏷️ Named Credential

Named Credential used:

```text
Recruitment_API
```

The Apex code references it as:

```apex
request.setEndpoint('callout:Recruitment_API');
```

This prevents the external endpoint from being hardcoded in Apex.

---

# 14. 🔑 External Credential

The integration also uses:

```text
Recruitment_API_Credential
```

The External Credential manages authentication and authorization configuration.

A principal is configured and the required access is provided through the appropriate Permission Set.

---

# 15. 👤 Permission Set

The integration user requires access to the configured External Credential / principal.

The Permission Set provides the required access so Salesforce can use the external credential during the callout.

---

# 16. 📡 External System

For development and testing, the external endpoint was represented using:

```text
Webhook.site
```

Webhook.site was used to verify that Salesforce successfully crossed the Salesforce boundary and transmitted the JSON payload.

The webhook received the complete candidate payload.

---

# 17. ✅ Successful Integration

A successful HTTP response is identified using:

```apex
if (
    response.getStatusCode() >= 200 &&
    response.getStatusCode() < 300
)
```

When the external system returns a successful 2xx response:

```text
Integration_Status__c = Sent
```

and:

```text
Integration_Error__c = blank
```

---

# 18. ❌ Error Handling

For a non-2xx HTTP response, Salesforce marks the integration as:

```text
Integration_Status__c = Failed
```

The HTTP status code and response body are stored in:

```text
Integration_Error__c
```

Example:

```text
HTTP 400: Bad Request
```

This allows administrators and developers to understand why an integration failed.

---

# 19. ⚠️ Exception Handling

Unexpected Apex or HTTP exceptions are caught using:

```apex
catch (Exception e)
```

When an exception occurs:

```text
Integration_Status__c = Failed
```

The exception message is stored in:

```text
Integration_Error__c
```

The integration attempt timestamp is also updated.

---

# 20. 🕒 Integration Monitoring

The following fields are used to monitor the integration:

### Integration Status

```text
Integration_Status__c
```

Possible values include:

```text
Sent
Failed
```

### Last Integration Attempt

```text
Last_Integration_Attempt__c
```

Stores the date and time of the most recent integration attempt.

### Integration Error

```text
Integration_Error__c
```

Stores the error message returned by the external system or Salesforce.

---

# 21. 🔁 Retry Strategy

Temporary external failures can occur because of:

* API downtime
* Network problems
* Temporary server errors
* Timeout
* Service unavailability

The current design records failed integrations as:

```text
Integration_Status__c = Failed
```

A controlled retry can then re-enqueue:

```apex
new CandidateSyncQueueable(applicationId)
```

The retry attempt can be monitored using:

```text
Last_Integration_Attempt__c
```

and the reason for the previous failure can be reviewed using:

```text
Integration_Error__c
```

A controlled retry strategy is preferred over automatically chaining unlimited Queueable jobs because unlimited retries could create repeated callouts and unnecessary processing.

---

# 22. 🛡️ Idempotency Strategy

Duplicate submissions must be prevented when the same candidate/application is sent more than once.

The Salesforce:

```text
Application Id
```

is used as the unique integration reference.

The JSON request contains:

```json
{
  "applicationId": "..."
}
```

The external system can use `applicationId` as an idempotency key.

Conceptually:

```text
Same Application ID
        ↓
Same Candidate Application
        ↓
Do not create duplicate external candidate
```

This allows the external Recruitment System to safely recognize repeated requests.

---

# 23. 🔄 Synchronous vs Asynchronous Integration

This integration uses an:

```text
Asynchronous
```

pattern.

### Synchronous

In a synchronous design:

```text
Salesforce transaction
        ↓
HTTP callout
        ↓
Wait for response
        ↓
Transaction continues
```

### Asynchronous

Our implementation uses:

```text
Salesforce transaction
        ↓
Queueable Job
        ↓
HTTP callout
        ↓
External API
```

The asynchronous approach reduces coupling between the Salesforce transaction and the external API.

---

# 24. 🧩 Integration Pattern

The integration follows:

```text
Trigger → Handler → Queueable → Named Credential → REST API
```

Responsibilities are separated:

### Trigger

Detects Salesforce record changes.

### TriggerHandler

Contains orchestration logic.

### Queueable

Performs asynchronous processing and the HTTP callout.

### Named Credential

Stores the external endpoint configuration.

### External Credential

Manages authentication configuration.

### External System

Receives and processes candidate information.

---

# 25. 📊 Integration Status Lifecycle

```text
Application
     │
     │ Status changes to Selected
     ▼
Queueable Created
     │
     ▼
HTTP Request
     │
     ├───────────────┐
     │               │
     ▼               ▼
   2xx             Non-2xx
     │               │
     ▼               ▼
   Sent            Failed
                     │
                     ▼
               Error Stored
```

---

# 26. 🧪 Testing Performed

The following tests were performed.

## Test 1 — Queueable Execution

The Queueable was successfully submitted using:

```apex
System.enqueueJob(
    new CandidateSyncQueueable(applicationId)
);
```

Result:

```text
Status = Completed
NumberOfErrors = 0
```

---

## Test 2 — Selected Application

The Queueable checks:

```apex
applicationRecord.Status__c == 'Selected'
```

Only selected candidates are synchronized.

---

## Test 3 — Successful HTTP Request

The external endpoint successfully received the HTTP POST request.

Result:

```text
Integration_Status__c = Sent
```

---

## Test 4 — Webhook Verification

Webhook.site successfully received the request.

The final verified payload contained:

```json
{
  "selectionDate": "2026-08-11",
  "jobName": "Salesforce Developer",
  "jobId": "a0BgK00000aGd0fUAC",
  "cgpa": 10,
  "email": "sana@gmail.com",
  "name": "Sana",
  "studentId": "a0AgK000008Vn1RUAS",
  "applicationId": "a0CgK000010lYD4UAM"
}
```

This confirms that Salesforce successfully crossed the integration boundary and transmitted the complete candidate information.

---

# 27. 🧪 Verification Queries

## Verify Application

```sql
SELECT Id,
       Name,
       Status__c,
       Integration_Status__c,
       Last_Integration_Attempt__c,
       Integration_Error__c
FROM Application__c
WHERE Name = 'APP-005'
```

---

## Verify Queueable Job

```sql
SELECT Id,
       Status,
       NumberOfErrors,
       CreatedDate,
       CompletedDate
FROM AsyncApexJob
WHERE JobType = 'Queueable'
ORDER BY CreatedDate DESC
LIMIT 1
```

---

## Verify Candidate Information

```sql
SELECT Id,
       Name,
       Student__r.Name,
       Student__r.Email__c,
       Student__r.CGPA__c,
       Job__r.Name
FROM Application__c
WHERE Name = 'APP-005'
```

---

# 28. 📁 Project Structure

The Sprint 11 project can be organized as:

```text
Sprint-11-Integration/
│
├── README.md
│
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/
│           │   ├── CandidateSyncQueueable.cls
│           │   ├── CandidateSyncQueueable.cls-meta.xml
│           │   ├── TriggerHandler.cls
│           │   └── ...
│           │
│           └── triggers/
│               └── ApplicationTrigger.trigger
│
├── architecture/
│   ├── integration-flow.png
│   ├── sequence-diagram.png
│   └── integration-pattern.png
│
├── screenshots/
│   ├── named-credential.png
│   ├── external-credential.png
│   ├── permission-set.png
│   ├── queueable-success.png
│   ├── application-status-sent.png
│   └── webhook-payload.png
│
└── learning-notes/
    └── sprint-11.md
```

---

# 29. 📸 Evidence Collected

Important evidence for this sprint includes:

* Application status changed to Selected
* CandidateSyncQueueable source code
* Named Credential configuration
* External Credential configuration
* Principal configuration
* Permission Set configuration
* Queueable execution
* AsyncApexJob status
* Integration Status = Sent
* Last Integration Attempt timestamp
* Webhook.site request
* Complete candidate JSON payload

---

# 30. 🧠 Key Learnings

### 1. Salesforce does not directly expose credentials inside Apex

Named Credentials and External Credentials provide a secure abstraction for external integrations.

### 2. Callouts should be handled asynchronously when appropriate

Queueable Apex allows the external callout to happen outside the original Salesforce transaction.

### 3. Integration success is more than an HTTP request

A production-ready integration should consider:

* Error handling
* Retry strategy
* Idempotency
* Monitoring
* Authentication
* API contracts
* Logging

### 4. JSON serialization simplifies API communication

Apex maps can be serialized using:

```apex
JSON.serialize(requestBody)
```

### 5. Integration monitoring is essential

Fields such as:

```text
Integration_Status__c
Last_Integration_Attempt__c
Integration_Error__c
```

make it possible to monitor external communication.

### 6. Idempotency prevents duplicates

Using `applicationId` as the unique integration reference allows the external system to recognize repeated submissions.

---

# 31. 🏆 Sprint 11 Completion Status

| Area                   | Status     |
| ---------------------- | ---------- |
| Trigger Integration    | ✅ Complete |
| Trigger Handler        | ✅ Complete |
| Queueable Apex         | ✅ Complete |
| Callout Support        | ✅ Complete |
| Named Credential       | ✅ Complete |
| External Credential    | ✅ Complete |
| Principal              | ✅ Complete |
| Permission Set         | ✅ Complete |
| REST POST              | ✅ Complete |
| Candidate Payload      | ✅ Complete |
| Response Handling      | ✅ Complete |
| Error Handling         | ✅ Complete |
| Integration Monitoring | ✅ Complete |
| Retry Strategy         | ✅ Defined  |
| Idempotency Strategy   | ✅ Defined  |
| External API Testing   | ✅ Complete |
| Webhook Verification   | ✅ Complete |
| Documentation          | ✅ Complete |

---

# 32. 🎉 Final Result

The Sprint 11 integration successfully connects Salesforce with an external Recruitment System.

The final architecture is:

```text
Application__c
      │
      │ Status = Selected
      ▼
ApplicationTrigger
      │
      ▼
TriggerHandler
      │
      ▼
CandidateSyncQueueable
      │
      ▼
Named Credential
      │
      ▼
External Credential
      │
      ▼
HTTP POST
      │
      ▼
External Recruitment API
      │
      ▼
Webhook.site
```

The external system receives the selected candidate's:

```text
Student ID
Name
Email
CGPA
Job ID
Job Name
Application ID
Selection Date
```

The Salesforce system records the integration result using:

```text
Integration_Status__c
Last_Integration_Attempt__c
Integration_Error__c
```

The integration was successfully tested end-to-end, including verification of the complete JSON payload at the external endpoint.

---

# 🚀 Sprint 11 — COMPLETE

**Salesforce → Queueable Apex → Named Credential → External API → Candidate JSON → Successful Response**

The Salesforce Placement Management System has successfully crossed the Salesforce boundary and integrated with an external recruitment system.

