USE fintech_db

--===> Volume & Activity Metrics (Operational Scale):
--=========================================================


-->1. Total number of Accounts and total sum of Balance by Account types.

SELECT  AccountType,
        count(AccountID) as no_of_accounts,
        ROUND(sum(Balance),2) as sum_of_Transaction
FROM Account
GROUP BY AccountType;


-->2. Breakdown percentage of transaction volume and value across different values of TransactionChannel

WITH trans_channels AS(
            SELECT TransactionChannel,   
                   COUNT(TransactionID) AS Transaction_Volume,
                   ROUND(SUM(TransactionAmount),2) AS Transaction_Value
            FROM transact
            GROUP BY TransactionChannel)

SELECT c1.TransactionChannel,
       ROUND(CAST(c1.Transaction_Volume *100.0/(SELECT SUM(Transaction_Volume) FROM trans_channels)AS FLOAT),2) AS transaction_volume_percentage,
       ROUND(CAST(c1.Transaction_Value  *100.0/(SELECT SUM(Transaction_Value) FROM trans_channels)AS FLOAT),2) AS transaction_amount_percentage
FROM trans_channels as c1 



-->3. Percentage of Transactions  based on TransactionType.

WITH cte AS (
            SELECT TransactionType,
            Count(TransactionID) as volume_of_transaction
            FROM transact
            GROUP BY TransactionType)

SELECT TransactionType,
       ROUND(CAST(volume_of_transaction *100.0/(SELECT sum(volume_of_transaction) from cte)AS FLOAT),2) AS Transact_percent
       FROM cte



--->4. TOP 30 transaction months by financial worth from 2020 to 2025

SELECT TOP 30
       FORMAT(TransactionDate,'yyyy MMM') as Transaction_Month,     
       ROUND(SUM(TransactionAmount),2) as Total_Transaction
FROM transact
GROUP BY  FORMAT(TransactionDate,'yyyy MMM')
ORDER BY  Total_Transaction DESC,MIN(TransactionDate)

---NOTE: if we want to know which year ,out of top 30, has how much transactions then we can use the above as cte (TOP_MONTHS) and run the following query :

/*SELECT YEAR(Transaction_Month) as Year,
      
       SUM(Total_Transaction) as total_transaction
FROM TOP_MONTHS
GROUP BY YEAR(Transaction_Month)
ORDER BY SUM(Total_Transaction) DESC;*/


-- 5.From 2024 to 2025, TOP 10 Busiest Months in terms of transaction activity

SELECT TOP 10
      FORMAT(TransactionDate,'yyyy-MMM') as Month,
      COUNT(TransactionID) as Transaction_activity
FROM  transact
WHERE TransactionDate>'2023-12-31' AND TransactionDate<='2025-12-31'
GROUP BY FORMAT(TransactionDate,'yyyy-MMM')
ORDER BY Transaction_activity DESC;



---6.Find the customer IDs Who has made 'Medium' transactions, their no.of transactions and average transactions. 
--'Categorize the Transaction Amount into Small(<=1000) , Medium(>1000 & <=5000) , Large(>5000)'.

SELECT sub.CustomerID,sub.FullName,
       count(sub.TransactionID) as no_of_medium_transactions,
       ROUND(AVG(sub.TransactionAmount),2) AS average_medium_transaction
FROM (                                          
      SELECT t.TransactionID,                    ----Categorisation table 
             t.TransactionAmount,
             a.CustomerID,
             a.AccountType,
             c.FullName,
            CASE 
                 WHEN t.TransactionAmount<=1000 THEN 'Small'      
                 WHEN t.TransactionAmount>1000 AND t.TransactionAmount<=3000 THEN 'Medium'
                 WHEN t.TransactionAmount>3000 THEN 'Large'
            END  AS Transaction_Category
       FROM transact AS t
       JOIN Account AS a                  ---JOINING  Account table for fetching account type
             ON t.AccountID=a.AccountID
       JOIN Customer as c                 ---JOINING Customer table for fetching customer name
             ON c.CustomerID=a.CustomerID) AS sub
WHERE sub.Transaction_Category='Medium'
GROUP BY sub.CustomerID ,sub.FullName
ORDER BY no_of_medium_transactions DESC;



---7.Find the months having negative net cash flow (highest to lowest)

SELECT Month,
       Net_Cash_Flow 
FROM(                                            ------------calculation of credit and debit amount monthwise
     SELECT FORMAT(TransactionDate,'yyyy-MMM') as Month,
            ROUND(SUM(CASE WHEN TransactionType='Credit' THEN TransactionAmount END),2) as Credit_Amount,
            ROUND(SUM(CASE WHEN TransactionType='Debit' THEN TransactionAmount END),2) as Debit_Amount,
            ROUND(SUM(CASE WHEN TransactionType='Credit' THEN TransactionAmount END)-SUM(CASE WHEN TransactionType='Debit' THEN TransactionAmount END),2) AS Net_Cash_Flow
     From transact
     GROUP BY FORMAT(TransactionDate,'yyyy-MMM')
     
     ) AS cash_flow
WHERE Net_Cash_Flow<0
ORDER BY Net_Cash_Flow ASC;    ----because net cash flow is negative ,so ASC  will give highest negative first