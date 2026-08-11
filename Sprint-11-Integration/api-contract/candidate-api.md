# Candidate Recruitment API Contract

## Overview

This API is used by Salesforce to send selected placement candidates
to an external recruitment system.

The API is currently represented as a mock external recruitment endpoint
for Sprint 11 integration testing.

---

## Endpoint

POST /candidates

### Purpose

Create a candidate record in the external recruitment system when a
Salesforce Application is selected.

---

## Request Headers

Content-Type: application/json

---

## Request Body

```json
{
  "studentId": "a0AgK000008Vn1RUAS",
  "name": "Sample Student",
  "email": "student@example.com",
  "branch": "AI & ML",
  "cgpa": 8.0,
  "jobId": "a0JgK0000001234",
  "company": "Example Company",
  "role": "Salesforce Developer",
  "selectionDate": "2026-08-11"
}