USE fintech_db


--Customer Analytics Metrics:-
 --===================================

---1.Percentage of Active Customers Region wise:

SELECT  Region,
        ROUND(CAST(SUM(CASE WHEN Status='Active' THEN 1 END)*100.0/(SELECT COUNT(CustomerID) as cnt FROM Customer WHERE Status='Active')AS FLOAT),2) AS Active_customer_percent 
FROM Customer
GROUP BY Region
ORDER BY Active_customer_percent DESC;


---2.Average no. of Accounts per customer ID

SELECT ROUND(CAST(SUM(cnt)*1.0/COUNT(CustomerID)AS FLOAT),2) as account_per_customerID
FROM (
      SELECT CustomerID,
             COUNT(AccountID) as cnt
      FROM Account
      GROUP BY CustomerID
      ) as sub;


---3.Customers who currently hold more than 1 active accounts.

SELECT  
       DISTINCT c.CustomerID,
       c.FullName,
       SUM(CASE WHEN c.Status='Active' THEN 1 END) AS no_of_active_accounts  
FROM Account AS A
INNER JOIN Customer AS c
       ON c.CustomerID = A.CustomerID

GROUP BY  c.CustomerID,
          c.FullName
HAVING SUM(CASE WHEN c.Status='Active' THEN 1 END)>=2;