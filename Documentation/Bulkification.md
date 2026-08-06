# Bulkification in Salesforce

## What is Bulkification?

Bulkification is the process of designing Apex code so that it can process one record or many records efficiently within the same transaction.

## Why Bulkification?

Without bulkification:

- SOQL queries increase rapidly.
- DML statements increase rapidly.
- Governor Limits are exceeded.
- Transactions fail.

## Bulk Processing Pattern

1. Receive all records.
2. Collect required IDs.
3. Perform one SOQL query.
4. Store records in Maps.
5. Process records in memory.
6. Collect modified records.
7. Perform one DML operation.

## Collections

### List

Stores multiple records.

Example:

List<Application__c>

### Set

Stores unique values.

Example:

Set<Id>

### Map

Stores key-value pairs.

Example:

Map<Id, Student__c>

## Advantages

- Better performance
- Fewer database calls
- Governor Limit compliance
- Scalable design

## Conclusion

Bulkification is one of the most important principles in Salesforce development.