## Fintech SQL Analytics & Risk Engine

## Project Overview
This project features an advanced analytics and risk-monitoring engine built on a relational fintech database consisting of "Customer", "Account", 
& "Transaction (`transact`)" data. 
The goal of this project is to extract deep operational, behavioral, and financial insights to support business growth and mitigate risk.

## DATABASE Schemas: 3 Core tables:
  **Customer**: contains customerID, FullName, Dob, Gender, Region, Email, Status, JoinDate
  **Account**: contains AccountID, customerID, AccountType, OpenDate, closeDate, Status,Balance
  **transact**: contains TransactionID, AccountID, TransactionDate, TransactionAmount, TransactionChannel, ProductID, Status

## Analytics Categories & Metrics Breakdown:
  The project implemnts **15 Advanced sql metrices** categorized into 4 business domains:

  
## 1. Operational & Transactional Scale:

## 2. Behaviourial & risk velocity: 

## 3. Customer Lifecycle:

## 4. Financial Performance:


## Tech stack & SQL concepts demonstrated:

**Database Management System(DBMS)** : Microsoft SQL server
**Advanced SQL Techniques**:
  * Common Table Expressions (CTEs)
  * Window Functions(ROW_NUMBER , ..)
  * Conditional Aggregations(SUM(CASE WHEN ...))
  * Multi-table Joins

## Key Business Insights
   * Identified customers mostly use mobile as their primary channel for the transactions.
   * Customer Churn Rate is 55.44%
