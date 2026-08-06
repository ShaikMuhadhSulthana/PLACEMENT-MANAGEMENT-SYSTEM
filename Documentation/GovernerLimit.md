# Governor Limits

## Introduction

Governor Limits are restrictions imposed by Salesforce to ensure that every transaction uses shared platform resources fairly. Salesforce is a multi-tenant platform where multiple organizations share the same infrastructure.

## Why Governor Limits Exist

Governor Limits prevent one transaction from consuming excessive resources, ensuring stability and performance for all organizations.

## Common Governor Limits

| Resource | Limit |
|----------|------:|
| SOQL Queries | 100 |
| Records Retrieved | 50,000 |
| DML Statements | 150 |
| DML Records | 10,000 |
| CPU Time | 10,000 ms |
| Heap Size | 6 MB |

## Best Practices

- Avoid SOQL queries inside loops.
- Avoid DML statements inside loops.
- Process records in bulk.
- Use Lists, Sets, and Maps.
- Query related records only once.
- Perform DML outside loops.

## Conclusion

Understanding Governor Limits helps developers build scalable and reliable Salesforce applications.