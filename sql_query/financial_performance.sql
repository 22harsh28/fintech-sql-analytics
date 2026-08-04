USE fintech_db


---> Financial Performances:
--==========================

---1.Total sum of the Balance across all active accounts in the Account table.


select a.CustomerID,c.FullName,ROUND(SUM(a.Balance),3) as Net_balance
from Account as a
JOIN Customer as c 
ON c.CustomerID = a.CustomerID
WHERE c.Status = 'Active'
GROUP BY a.CustomerID,c.FullName


---2.The average duration an account stays open before being closed (__Account Lifespan__)

SELECT AccountID,
       DATEDIFF(MONTH,OpenDate,ClosedDate) as Duration_Months_account_open
FROM Account
WHERE Status='Closed'
ORDER BY Duration_Months_account_open DESC;


---3. Average Account Balance:

SELECT AccountType,
       ROUND(AVG(Balance),2) as average_account_balance
FROM Account
GROUP BY AccountType


----4.Customer Churn Rate:(inactive account *100/Total account)

SELECT ROUND(CAST(SUM(CASE WHEN Status='Closed' THEN 1 END)*100.0/COUNT(AccountID) AS FLOAT),2) as Customer_churn_rate_percnt
FROM Account;

--5.Finding accounts with an active status where the latest TransactionDate in the transact table is greater than 90 days ago.


WITH latest_transaction as (
SELECT a.AccountID,a.Status,
       max(t.TransactionDate) as latest_trans_date
FROM Account as a
JOIN transact as t
ON t.AccountID = a.AccountID
WHERE a.Status = 'Open'
GROUP BY a.AccountID,a.Status)

               SELECT l.AccountID,
                      DATEDIFF(DAY,l.latest_trans_date,'2026-01-01') as after_Days
                FROM latest_transaction as l
                
                WHERE DATEDIFF(DAY,l.latest_trans_date,'2026-01-01')>90
                