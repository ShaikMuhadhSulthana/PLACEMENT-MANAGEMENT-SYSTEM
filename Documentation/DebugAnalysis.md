# Debug Analysis

## Problem Statement

The following code is unsafe:

```apex
for(Application__c app : Trigger.new){

Student__c student = [

SELECT Id, CGPA__c
FROM Student__c
WHERE Id = :app.Student__c

];

if(student.CGPA__c >= 7){

app.Status__c='Eligible';

update app;

}

}
```

## Problems

### Problem 1

SOQL query inside loop.

### Problem 2

DML statement inside loop.

### Problem 3

One query executed for every record.

### Problem 4

One update executed for every record.

### Problem 5

Can exceed SOQL Governor Limits.

### Problem 6

Can exceed DML Governor Limits.

### Problem 7

Poor performance.

### Problem 8

Not scalable.

## Correct Design

- Collect IDs.
- Query once.
- Store in a Map.
- Process in memory.
- Update records together.

## Conclusion

Bulkified code is efficient, scalable, and follows Salesforce best practices.