USE fintech_db

--===> Velocity and frequency Metrices:
--========================================


---1.Total Number of Transactions made by each Active customers in the last 2 years (to know the active customers):

SELECT  sub.CustomerID,
        c.FullName,
        SUM(sub.transaction_count) as total_transactions
FROM (                                            ----table for count of transaction of customers yearwise for last 2 years
      Select  
            YEAR(t.TransactionDate)as year,
             a.CustomerID,
             Count(t.TransactionID) as transaction_count
       FROM transact as t
       JOIN Account as a
           ON t.AccountID = a.AccountID
           WHERE t.TransactionDate Between '2024-01-01' AND '2025-12-31'
       GROUP BY YEAR(t.TransactionDate),a.CustomerID
       ) as sub

JOIN Customer as c                              ---JOINING Customer table to get the full name of customer ID
     ON c.CustomerID=sub.CustomerID
WHERE c.Status='Active'
GROUP BY sub.CustomerID,c.FullName
ORDER BY total_transactions DESC
 