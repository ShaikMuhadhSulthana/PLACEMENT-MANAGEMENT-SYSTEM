Placement Management System – Salesforce

Project Overview

The Placement Management System is a Salesforce-based application designed to manage student placement activities in an organized and automated way.

The system allows students to view eligible placement opportunities, apply for jobs, and manage their applications. It uses Salesforce custom objects, Apex, SOQL, DML, Triggers, Flows, Lightning Web Components, and service-layer architecture to implement the business requirements.

The main objective of the project is to build a scalable and maintainable placement application where the user interface remains simple while the business rules are handled securely in the Salesforce backend.

The project follows the architecture:

User↓Lightning Web Component↓Apex Controller↓Service Layer↓SOQL / DML↓Salesforce Database

Main Features

The Placement Management System provides the following functionality:

Student management

Job management

Application management

Student eligibility checking

CGPA-based eligibility validation

Branch-based eligibility validation

Duplicate application prevention

Application status management

Application date management

Offer letter generation

Email notifications

Bulk-safe Apex processing

Trigger-based automation

Lightning Web Component user interface

Interactive Apply functionality

Salesforce data retrieval

Error handling

Loading, success, empty and error states

Service-layer based business logic

Salesforce Data Model

The application is built using Salesforce custom objects.

Student

The Student object stores student information such as:

Student Name

CGPA

Branch

Other student-related information

Example Salesforce fields:

Student__c
CGPA__c

Job

The Job object stores placement opportunity information such as:

Job Role

Company

Package

Location

Application Deadline

Minimum CGPA

Eligible Branch

The exact field API names depend on the fields created in the Salesforce org.

Application

The Application object connects a student with a job.

It contains information such as:

Student

Job

Application Date

Application Status

The application process is controlled through Apex business rules and Salesforce automation.

Offer Letter

The Offer Letter object stores offer information when a student's application is successfully selected.

An offer letter can be automatically created when the Application status changes to Selected.

Business Rules

The application follows important placement business rules.

A student cannot submit a duplicate application for the same job.

A student must satisfy the required eligibility criteria before applying.

The student's CGPA is checked against the minimum CGPA required by the job.

The student's branch is checked against the eligible branch configured for the job.

Applications are processed through Apex service logic rather than placing business rules directly inside the Lightning Web Component.

When an application is selected, an Offer Letter can be generated automatically.

Application dates and notifications can be handled through Salesforce automation.

Apex Architecture

The project follows a layered Apex architecture.

Apex Controller

The Apex Controller acts as the entry point between the Lightning Web Component and server-side functionality.

The Lightning Web Component calls the controller instead of directly accessing database logic.

Example capability:

submitApplication(studentId, jobId)

Service Layer

The service layer contains the main business logic.

Typical responsibilities include:

Checking student information

Checking job information

Checking duplicate applications

Validating eligibility

Creating applications

Updating application status

Handling application workflows

This approach keeps the business rules outside the user interface.

Data Access

SOQL is used to retrieve Salesforce records.

DML is used to insert, update and manage Salesforce records.

The application follows bulkification principles so that Apex can safely process multiple records.

Trigger Architecture

Triggers respond automatically to important Salesforce record events.

Trigger logic is kept small and delegates business responsibilities to appropriate classes.

This helps prevent large and difficult-to-maintain trigger files.

Lightning Web Components

The project includes Lightning Web Components for the student-facing experience.

The main component is:

placementHome

The component provides the placement home page where students can view available placement opportunities.

A reusable child component is:

jobCard

The jobCard component represents an individual job opportunity and provides the Apply action.

The component relationship is:

placementHome
        |
        | passes job
        ↓
     jobCard
        |
        | Apply event
        ↓
placementHome
        |
        | calls Apex
        ↓
ApplicationController
        |
        ↓
Service Layer
        |
        ↓
Salesforce Database

Placement Home Component

The placementHome component provides the main student interface.

It displays:

Student name

Available jobs

Job role

Job ID

Minimum CGPA

Eligible branch

Application deadline

Apply button

The component also handles the Apply event generated by the child Job Card component.

The component sends the actual Salesforce record IDs to Apex.

Example:

Student ID:
a0AgK000008Vn1RUAS

Example Salesforce Job IDs used during testing:

a0BgK00000aD9dRUAS
a0BgK00000aGd0fUAC

These IDs are Salesforce record IDs and are different from display values such as JOB001 or JOB002.

Job Card Component

The jobCard component is responsible for displaying and handling actions for an individual job.

The parent component passes the job record to the child component.

The child component receives the job using:

@api job;

When the student clicks Apply, the child component dispatches a custom event:

this.dispatchEvent(
    new CustomEvent('apply', {
        detail: this.job.Id
    })
);

The Salesforce Job record ID is passed to the parent component.

The parent then calls Apex using the Student ID and Job ID.

Parent-Child Communication

The project demonstrates communication between Lightning Web Components.

The parent component:

placementHome

passes data to:

jobCard

using an @api property.

The child component sends information back to the parent using a custom event.

The communication flow is:

Parent
  ↓
@api job
  ↓
Child Job Card
  ↓
Custom Event
  ↓
Parent handleApply()

Apex Application Workflow

When the student clicks Apply, the following process occurs:

Student clicks Apply
        ↓
Job Card handles click
        ↓
Job ID is sent through custom event
        ↓
placementHome receives Job ID
        ↓
Student ID + Job ID sent to Apex
        ↓
ApplicationController
        ↓
Application Service
        ↓
Business validation
        ↓
Duplicate check
        ↓
Eligibility check
        ↓
Application creation
        ↓
Success / Error response

Eligibility Validation

The eligibility validation is handled on the Salesforce backend.

The system checks the student's actual Salesforce record.

Example query:

SELECT Id, Name, CGPA__c
FROM Student__c
WHERE Id = 'a0AgK000008Vn1RUAS'

The student's CGPA was verified directly from Salesforce rather than relying only on hard-coded values in the Lightning Web Component.

Job records were also verified using Salesforce record IDs.

Example:

SELECT Id, Name
FROM Job__c
WHERE Id IN ('a0BgK00000aD9dRUAS', 'a0BgK00000aGd0fUAC')

Error Handling

The Lightning Web Component handles Apex failures using Promise error handling.

Example:

.catch(error => {
    console.error(
        'Application failed:',
        JSON.stringify(error)
    );
});

This allows errors returned by Apex to be inspected during development and testing.

Business validation errors such as CGPA eligibility failures are handled by the backend business logic.

Salesforce Automation

Salesforce automation is used where appropriate for business processes.

The project can use Salesforce Flows for tasks such as:

Automatically setting application dates

Sending email notifications

Creating Offer Letter records

Automating record-based processes

This reduces unnecessary Apex code for simple automation requirements.

Bulkification

The Apex implementation follows Salesforce bulkification principles.

The application avoids performing SOQL queries and DML operations unnecessarily inside loops.

Collections such as Lists, Sets and Maps can be used to process multiple records efficiently.

This is important because Salesforce enforces governor limits.

Governor Limits

Salesforce governor limits restrict the amount of resources that Apex code can consume during a transaction.

Important limits include:

SOQL query limits

DML statement limits

CPU time

Heap size

Callout limits

The project follows bulk-safe Apex practices to work efficiently within these limits.

Technologies Used

Salesforce
Apex
SOQL
DML
Lightning Web Components
JavaScript
HTML
Salesforce Flows
Salesforce Triggers
Service Layer Architecture
VS Code
Salesforce CLI
Git
GitHub

Development Tools

The project was developed using:

Visual Studio Code
Salesforce Extension Pack
Salesforce CLI
Salesforce Developer Org
Git
GitHub

Project Structure

The Salesforce project follows the standard Salesforce DX structure.

force-app
└── main
    └── default
        ├── classes
        │   ├── ApplicationController.cls
        │   ├── ApplicationController.cls-meta.xml
        │   ├── ApplicationService.cls
        │   ├── ApplicationService.cls-meta.xml
        │   ├── DataService.cls
        │   ├── DataService.cls-meta.xml
        │   └── ...
        │
        ├── lwc
        │   ├── placementHome
        │   │   ├── placementHome.html
        │   │   ├── placementHome.js
        │   │   └── placementHome.js-meta.xml
        │   │
        │   └── jobCard
        │       ├── jobCard.html
        │       ├── jobCard.js
        │       └── jobCard.js-meta.xml
        │
        ├── objects
        │   ├── Student__c
        │   ├── Job__c
        │   ├── Application__c
        │   └── Offer_Letter__c
        │
        └── flows
            └── Salesforce automation flows

Testing

The application was tested directly inside the Salesforce environment.

Testing included:

Student record retrieval
Job record retrieval
Student CGPA validation
Job eligibility validation
Duplicate application validation
Application submission
Application status changes
Offer letter generation
Lightning Web Component rendering
Job card rendering
Apply button interaction
Parent-child communication
Apex invocation
Error handling

LWC Debugging

During development, browser Developer Tools were used to verify component behaviour.

Important logs included:

Job Card Job Id:
Apply clicked for Salesforce Job Id:
Student Id:
Application submitted successfully:
Application failed:

These logs helped verify that the correct Salesforce record IDs were being passed from the child component to the parent component and then to Apex.

Important Salesforce ID Concept

Salesforce record IDs must be used when an Apex parameter is declared as:

Id jobId

Values such as:

JOB001
JOB002

are not Salesforce record IDs.

Actual Salesforce record IDs look like:

a0BgK00000aD9dRUAS
a0BgK00000aGd0fUAC

Therefore, the Lightning Web Component must send the actual Salesforce Job record ID when calling Apex.

Key Engineering Principles

The project follows several important software engineering principles.

Business logic should not be duplicated inside the user interface.

Components should represent clear user capabilities.

Apex should contain reusable business logic.

The service layer should contain business rules.

Triggers should remain small and delegate responsibilities.

SOQL and DML should be handled efficiently.

The platform should be used for capabilities that Salesforce already provides.

Components should be small and reusable.

Parent-child communication should be explicit.

User interfaces should consider loading, success, empty and error states.

The UI should hide backend complexity from the user.

User Experience

The student should not need to understand:

SOQL
Apex
DML
Triggers
Governor Limits
Salesforce Objects
Service Classes

The student should simply see:

Welcome, Student

Available Placement Opportunities

Salesforce Developer
Minimum CGPA: ...
Eligible Branch: ...
Application Deadline: ...

[ APPLY ]

The technical complexity remains behind the interface.

Future Enhancements

Possible future improvements include:

Dynamic job retrieval from Salesforce
Automatic student identification
Application status dashboard
Job search and filtering
Job details page
Interview schedule
Offer letter dashboard
Toast notifications
Loading spinner
Empty-state messages
Improved error messages
Pagination
Application withdrawal
Placement Officer dashboard
Recruiter dashboard
Advanced reporting

Project Outcome

The Placement Management System demonstrates how Salesforce can be used to build an end-to-end business application.

The project combines:

Data Model
+
SOQL
+
DML
+
Apex
+
Service Layer
+
Triggers
+
Flows
+
Lightning Web Components
+
Parent-Child Communication
+
Business Rules
+
User Experience

The final architecture separates the user interface from the business logic and data access layers.

This makes the application easier to understand, test, maintain and extend.

Conclusion

The Placement Management System provides a complete Salesforce-based solution for managing student placement activities.

The project demonstrates practical Salesforce development concepts including Apex, SOQL, DML, triggers, service-layer architecture, governor limits, automation, Lightning Web Components, event handling and Salesforce data integration.

The most important architectural principle followed throughout the project is:

The UI should provide the user experience, while the backend protects the business rules.

This approach allows the Placement Management System to remain maintainable and scalable as additional placement features are introduced.