# `README.md`

````markdown
# Placement Management System

## Salesforce Placement Management System

A Salesforce-based Placement Management System designed to manage students, jobs, applications, selection processes, offers, notifications, and external recruitment integration.

This project is developed using Salesforce platform technologies including Apex, Lightning Web Components (LWC), Salesforce Flows, SOQL, DML, Queueable Apex, asynchronous processing, REST integrations, Salesforce CLI, Git, and metadata-based deployment.

---

# 📌 Project Overview

The Placement Management System provides a centralized platform for managing the placement lifecycle.

The system supports:

- Student management
- Job management
- Job eligibility
- Student applications
- Application status management
- Selection processing
- Offer management
- Notifications
- Placement statistics
- Lightning Web Components
- Asynchronous Apex processing
- External recruitment integration
- Salesforce metadata management
- Git-based source control
- Salesforce CLI-based deployment

The project is designed to demonstrate how a Salesforce application can be developed, version-controlled, tested, reviewed, and safely deployed.

---

# 🎯 Business Problem

Placement activities often involve multiple entities such as:

- Students
- Jobs
- Applications
- Offers
- Placement officers
- External recruitment systems

Managing these activities manually can result in:

- Duplicate applications
- Incorrect eligibility decisions
- Delayed notifications
- Difficulty tracking application status
- Manual candidate synchronization
- Poor visibility into placement statistics
- Difficult deployment and maintenance processes

The Placement Management System addresses these problems by centralizing placement-related processes inside Salesforce.

---

# 👥 Users

The application is intended for users involved in the placement process.

Typical users include:

### Students

Students can:

- View their profile
- View eligible jobs
- Apply for jobs
- View application status
- View selection/offer information

### Placement Officers

Placement officers can:

- Manage jobs
- Monitor applications
- Track candidate selections
- Manage placement information
- Monitor integration status

### Administrators / Developers

Administrators and developers can:

- Configure Salesforce metadata
- Maintain Apex logic
- Manage permissions
- Deploy metadata
- Monitor asynchronous jobs
- Maintain integrations

---

# 🏗️ Salesforce Project Structure

The project follows the Salesforce DX source format.

```text
PlacementManagementSystem/
│
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/
│           ├── triggers/
│           ├── objects/
│           ├── flows/
│           ├── lwc/
│           └── permissionsets/
│
├── manifest/
│   └── package.xml
│
├── docs/
│   └── Sprint12-Deployment.md
│
├── scripts/
│
├── config/
│
├── .vscode/
├── .sf/
├── .sfdx/
│
├── .gitignore
├── .forceignore
├── sfdx-project.json
├── package.json
└── README.md
````

The chapter recommends separating source code, documentation, scripts, and deployment configuration in a professional repository. 

---

# 🧩 Salesforce Metadata

The project contains Salesforce metadata such as:

* Apex Classes
* Apex Triggers
* Lightning Web Components
* Custom Objects
* Custom Fields
* Flows
* Permission Sets
* Deployment configuration
* Tests
* Documentation

Salesforce metadata represents the structure and behavior of the application.

---

# 🗃️ Code vs Metadata vs Data

The project follows the principle of separating:

```text
Code
 ↓
Apex
LWC

Metadata
 ↓
Objects
Fields
Flows
Permissions

Data
 ↓
Students
Applications
Jobs
Offers
```

Salesforce records such as Student and Application records are business data and should not automatically be treated as source code.

The Sprint 12 chapter specifically emphasizes keeping code, metadata, and business data conceptually separate during development and deployment. 

---

# ⚙️ Apex Architecture

The project uses a layered Apex architecture.

A simplified flow is:

```text
Trigger
   ↓
Trigger Handler
   ↓
Service Classes
   ↓
Business Logic
   ↓
Database / External Integration
```

The trigger delegates processing to handler classes rather than placing all business logic directly inside the trigger.

This helps with:

* Maintainability
* Reusability
* Bulk processing
* Testing
* Separation of concerns

---

# 🔥 Trigger-Based Processing

Application-related changes are handled using Salesforce Apex triggers.

The trigger delegates processing to:

```text
TriggerHandler
```

The handler is responsible for coordinating:

* Application validation
* Statistics processing
* Notifications
* External recruitment synchronization

---

# ⚡ Asynchronous Processing

The project uses asynchronous Apex where appropriate.

Examples include:

* Queueable Apex
* Future Apex
* Batch Apex
* Scheduled processing

Asynchronous processing is useful when work should happen independently from the original Salesforce transaction.

---

# 🚀 Queueable Apex

Queueable Apex is used for the external recruitment integration.

The selected candidate flow is:

```text
Application Status
       ↓
Selected
       ↓
Application Trigger
       ↓
Trigger Handler
       ↓
CandidateSyncQueueable
       ↓
Named Credential
       ↓
External API
```

The Queueable class implements:

```apex
Queueable
Database.AllowsCallouts
```

This allows the external REST callout to be performed asynchronously.

---

# 🌐 External Integration

The Placement Management System integrates with an external recruitment system.

The integration is triggered when an application changes to:

```text
Selected
```

The selected candidate information is sent through an HTTP POST request.

The integration architecture is:

```text
Salesforce
    ↓
Application
    ↓
Trigger
    ↓
Trigger Handler
    ↓
Queueable Apex
    ↓
Named Credential
    ↓
External Credential
    ↓
REST API
    ↓
External Recruitment System
```

---

# 📦 Candidate Integration Payload

The candidate synchronization payload contains information such as:

```json
{
    "selectionDate": "YYYY-MM-DD",
    "jobName": "Salesforce Developer",
    "jobId": "JOB_ID",
    "cgpa": 10,
    "email": "candidate@example.com",
    "name": "Candidate Name",
    "studentId": "STUDENT_ID",
    "applicationId": "APPLICATION_ID"
}
```

The actual identifiers and candidate information depend on the Salesforce records being processed.

---

# 🔐 Authentication

External API authentication is handled using Salesforce:

* Named Credentials
* External Credentials
* Principal configuration
* Permission Set access

The Apex code references the Named Credential instead of directly hardcoding authentication details.

Example:

```apex
request.setEndpoint('callout:Recruitment_API');
```

This separates integration configuration and credentials from application code.

---

# 🖥️ Lightning Web Components

The project uses Lightning Web Components to provide interactive Salesforce user experiences.

The repository contains LWC components under:

```text
force-app/main/default/lwc/
```

Examples implemented during the Placement Management System development include components for:

* Student Portal
* Student Profile
* Student Summary
* Eligible Jobs
* Job Card
* Application-related UI
* Empty-state handling
* Parent-child communication

LWC communication includes:

```text
Parent → Child
Child → Parent
```

Custom events are used where child components need to communicate information back to parent components.

---

# 🔄 Application Flow

The major student application flow is:

```text
Student Profile
       ↓
Profile Saved
       ↓
Eligible Jobs Refresh
       ↓
Eligible Jobs Displayed
       ↓
Student Clicks Apply
       ↓
JobCard
       ↓
EligibleJobs
       ↓
Apex
       ↓
Application Created
       ↓
My Applications
       ↓
Application Status
       ↓
Offer Information
```

---

# 📊 Major Salesforce Entities

The Placement Management System contains Salesforce objects representing placement-related information.

Major business entities include:

```text
Student
Job
Application
Offer
```

Additional Salesforce metadata and objects may be present depending on the modules included in the project.

---

# 🧪 Testing

Testing is an important part of the deployment process.

The project uses Apex testing to verify Salesforce business logic.

Tests should verify:

* Application creation
* Validation rules
* Business logic
* Trigger behavior
* Bulk processing
* Asynchronous processing
* Integration behavior where applicable

Before deployment, Apex tests should be executed and successful.

---

# 🔧 Salesforce CLI

The project uses the modern Salesforce CLI.

CLI verification:

```bash
sf --version
```

The CLI provides command-line access for:

* Authentication
* Metadata retrieval
* Metadata deployment
* Org management
* Testing
* Project operations

The Sprint 12 chapter specifically introduces `sf` as the modern Salesforce CLI command form. 

---

# 🔑 Salesforce Org Authentication

The project uses an org alias:

```text
MyOrg
```

Verify authenticated orgs:

```bash
sf org list
```

Expected configuration:

```text
Alias: MyOrg
Status: Connected
```

Always verify the target org before performing deployment.


# 📦 Metadata Manifest

The project contains:

```text
manifest/package.xml
```

The manifest defines the Salesforce metadata types that can be retrieved or deployed.

Example structure:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">

    <types>
        <members>*</members>
        <name>ApexClass</name>
    </types>

    <types>
        <members>*</members>
        <name>ApexTrigger</name>
    </types>

    <types>
        <members>*</members>
        <name>CustomObject</name>
    </types>

    <types>
        <members>*</members>
        <name>CustomField</name>
    </types>

    <types>
        <members>*</members>
        <name>LightningComponentBundle</name>
    </types>

    <types>
        <members>*</members>
        <name>Flow</name>
    </types>

    <types>
        <members>*</members>
        <name>PermissionSet</name>
    </types>

    <types>
        <members>*</members>
        <name>CustomMetadata</name>
    </types>

    <version>67.0</version>

</Package>
```

---

# 📥 Metadata Retrieval

Metadata can be retrieved from the Salesforce org using:

```bash
sf project retrieve start \
    --manifest manifest/package.xml \
    --target-org MyOrg
```

This retrieves metadata from Salesforce into the local Salesforce DX project.

---

# 🌿 Git Branching Strategy

The project uses Git for source control.

The main branch is:

```text
main
```

Sprint 12 development is performed on:

```text
sprint-12-deployment
```

The development workflow is:

```text
main
 ↓
Feature Branch
 ↓
Development
 ↓
Commit
 ↓
Push
 ↓
Pull Request
 ↓
Review
 ↓
Merge
```

The Sprint 12 chapter emphasizes that the repository is the development record while the Salesforce org is an environment. 

---

# 🔄 Git Workflow

Typical workflow:

```bash
git status
```

Create a feature branch:

```bash
git switch -c sprint-12-deployment
```

Stage changes:

```bash
git add .
```

Commit:

```bash
git commit -m "Add Sprint 12 deployment workflow"
```

Push:

```bash
git push -u origin sprint-12-deployment
```

Create a Pull Request on GitHub.

After review, merge the Pull Request into `main`.

---

# 📌 Git Best Practices

The repository should contain source-controlled artifacts such as:

* Apex classes
* Triggers
* LWC components
* Object metadata
* Fields
* Flows
* Permission metadata
* Tests
* Documentation
* Deployment configuration

Business data such as Student and Application records should not automatically be committed as source code.

This separation is explicitly emphasized in the Sprint 12 chapter. 

---

# 🚀 Deployment

Metadata deployment is performed using Salesforce CLI.

Example:

```bash
sf project deploy start \
    --source-dir force-app \
    --target-org MyOrg
```

Before deployment, verify:

```text
Target Org
Feature Branch
Commit
Metadata
```

---

# 🧪 Deployment Testing

After deployment:

1. Check deployment result.
2. Run Apex tests.
3. Verify the target Salesforce org.
4. Manually test the feature.
5. Confirm that expected metadata exists.
6. Confirm that business functionality works.

---



### Application Functionality

Verify the relevant business process through the Salesforce UI.

### Apex Tests

Confirm that the required tests execute successfully.

---

# 🏖️ Sandboxes

A Sandbox is a Salesforce environment used for development, testing, staging, or other non-production purposes.

Typical environments may include:

```text
Development
     ↓
QA
     ↓
UAT
     ↓
Production
```

Sandboxes help teams validate changes before production deployment.

---

# 🧪 Scratch Orgs

Scratch Orgs are temporary Salesforce environments used for development and testing.

They are useful when teams want isolated environments that can be created from project configuration.

A typical development approach can be:

```text
Source Code
     ↓
Scratch Org
     ↓
Development
     ↓
Testing
     ↓
Deployment
```

---

# 📦 Changesets

Salesforce Changesets provide a Salesforce-native mechanism for moving metadata between related Salesforce orgs.

They can be useful when working with environments such as:

```text
Sandbox
   ↓
Production
```

Changesets are one deployment approach, while Salesforce CLI and source-driven development provide another.

---

# 🔗 Metadata API

Salesforce metadata can be represented as source files and moved between environments using metadata deployment mechanisms.

The Salesforce CLI provides commands that work with Salesforce metadata and deployment workflows.

---

# ⚖️ Deployment Approaches

Possible Salesforce deployment approaches include:

### Salesforce CLI

```text
Source
 ↓
CLI
 ↓
Target Org
```

Advantages:

* Scriptable
* Developer friendly
* Git friendly
* Reproducible

### Changesets

```text
Sandbox
 ↓
Changeset
 ↓
Target Org
```

Useful for Salesforce-native deployment workflows.

### Scratch Org Development

```text
Source
 ↓
Scratch Org
 ↓
Testing
 ↓
Deployment
```

Useful for source-driven development and isolated development environments.

---

# 🛡️ Deployment Safety

A professional deployment should not be treated as simply:

```text
Run command
 ↓
Hope it works
```

Instead:

```text
Verify Org
     ↓
Verify Branch
     ↓
Verify Commit
     ↓
Verify Metadata
     ↓
Deploy
     ↓
Run Tests
     ↓
Manual Verification
     ↓
Document
```

---

# 📝 Sprint 12 Deployment Documentation

Sprint 12 deployment documentation is maintained in:

```text
docs/Sprint12-Deployment.md
```

This document records:

* Salesforce CLI verification
* Org authentication
* Metadata retrieval
* Git branch
* Deployment process
* Testing
* Verification

---

# 📁 Recommended Repository Structure

The Sprint 12 project is intended to evolve toward a professional repository structure:

```text
placement-management-system/
│
├── README.md
│
├── force-app/
│
├── docs/
│   ├── architecture/
│   ├── api/
│   ├── deployment/
│   └── decisions/
│
├── screenshots/
│
├── tests/
│
├── scripts/
│
├── manifest/
│   └── package.xml
│
├── config/
│
├── .gitignore
├── .forceignore
├── sfdx-project.json
└── package.json
```

The chapter's production-ready project specifically asks for `README.md`, `force-app`, documentation sections, screenshots, tests, and `.gitignore`. 

---

# 🔐 Security Considerations

The project should not commit:

* Passwords
* Access tokens
* Private credentials
* Sensitive personal information
* Environment-specific secrets

Authentication for external integrations should be managed through Salesforce credential mechanisms such as Named Credentials and External Credentials.

---

# 📋 Deployment Checklist

Before deployment:

```text
[ ] Correct Salesforce org verified
[ ] Correct Git branch verified
[ ] Correct commit verified
[ ] Metadata reviewed
[ ] Tests prepared
[ ] Deployment command reviewed
```

During deployment:

```text
[ ] Deployment started
[ ] Deployment result monitored
[ ] Errors reviewed
```

After deployment:

```text
[ ] Apex tests executed
[ ] Metadata verified
[ ] Feature manually tested
[ ] Target org verified
[ ] Deployment documented
```

---

# ✅ Sprint 12 Definition of Done

The Sprint 12 workflow is considered complete when:

* [ ] Git repository exists
* [ ] Branching strategy is documented
* [ ] Feature branch is used
* [ ] Pull Request is reviewed
* [ ] Salesforce metadata is source-controlled
* [ ] Salesforce CLI authentication works
* [ ] Metadata can be retrieved
* [ ] Metadata can be deployed
* [ ] Apex tests run successfully
* [ ] Target org is verified
* [ ] Deployment is documented

These are the Definition of Done items specified by the Sprint 12 chapter. 

---

# 🔄 Sprint 12 Workflow

The complete workflow is:

```text
Salesforce Org
      ↓
Metadata Retrieval
      ↓
Local Salesforce DX Project
      ↓
Git Feature Branch
      ↓
Development / Metadata Change
      ↓
Git Commit
      ↓
Push
      ↓
Pull Request
      ↓
Code Review
      ↓
Merge
      ↓
Deploy
      ↓
Run Tests
      ↓
Manual Verification
      ↓
Documentation
```

The chapter's deployment workflow explicitly progresses through feature branch creation, change, commit, push, Pull Request, review, merge, deployment, testing, manual verification, and documentation. 

---

# 🧠 Sprint 12 Learning Outcomes

After completing Sprint 12, the developer should be able to:

* Explain why Salesforce development requires version control
* Understand Git repositories and branches
* Understand commits, pulls and pushes
* Understand Salesforce metadata and source code
* Use Salesforce CLI
* Authenticate Salesforce orgs
* Retrieve metadata
* Deploy metadata
* Understand Sandboxes
* Understand Scratch Orgs
* Understand Changesets
* Understand Metadata API deployment
* Compare Salesforce development approaches
* Resolve basic Git conflicts
* Build a professional Salesforce repository
* Demonstrate a deployment workflow
* Explain how the Placement Management System can move toward production

---

# 🔮 Version 2 Improvements

Potential future improvements include:

* More comprehensive automated testing
* Improved deployment automation
* CI/CD integration
* More robust monitoring
* Better error reporting
* Automated rollback strategies
* Improved integration retry mechanisms
* More granular permission management
* Improved user experience
* More comprehensive deployment validation
* Automated quality checks

---

# 👨‍💻 Development Philosophy

The project follows the principle:

```text
Source Control
      ↓
Reproducibility
      ↓
Testing
      ↓
Review
      ↓
Safe Deployment
```

The Salesforce org is treated as an environment, while Git serves as the source-controlled development record.

---

# 🏁 Project Status

## Placement Management System

Core Salesforce application:

**Implemented**

## Sprint 11

External recruitment integration:

**Completed**

## Sprint 12

Git + Salesforce CLI + Metadata + Deployment workflow:

**In Progress**

---

# 📚 Key Commands

### Check Salesforce CLI

```bash
sf --version
```

### List authenticated orgs

```bash
sf org list
```

### Check Git status

```bash
git status
```

### Check branches

```bash
git branch
```

### Create feature branch

```bash
git switch -c sprint-12-deployment
```

### Retrieve metadata

```bash
sf project retrieve start \
    --manifest manifest/package.xml \
    --target-org MyOrg
```

### Deploy metadata

```bash
sf project deploy start \
    --source-dir force-app \
    --target-org MyOrg
```

### Stage changes

```bash
git add .
```

### Commit changes

```bash
git commit -m "Complete Sprint 12 deployment workflow"
```

### Push branch

```bash
git push -u origin sprint-12-deployment
```

---

# 🎉 Conclusion

The Placement Management System demonstrates the development of a Salesforce application from business requirements through implementation, integration, source control, metadata management, testing, and deployment.

Sprint 12 extends the project beyond Salesforce development by introducing a professional software delivery workflow based on:

```text
Git
+
Salesforce CLI
+
Metadata
+
Feature Branches
+
Code Review
+
Testing
+
Deployment
```

The final goal is not simply to have working Salesforce functionality.

The goal is to make the application:

```text
Version Controlled
       ↓
Reproducible
       ↓
Testable
       ↓
Reviewable
       ↓
Deployable
       ↓
Maintainable
```

---

# 👩‍💻 Project

**Placement Management System**

**Platform:** Salesforce

**Development Tools:**

* Salesforce
* Salesforce CLI
* VS Code
* Git
* GitHub

**Source Format:** Salesforce DX

**API Version:** 67.0
