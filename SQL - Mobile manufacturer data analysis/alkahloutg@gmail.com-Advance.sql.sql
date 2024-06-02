--SQL Advance Case Study


--Q1--BEGIN 
	Select State, count(IDCustomer) as count_customers, YEAR(CONVERT(DATE, Date, 103)) AS Year from FACT_TRANSACTIONS AS T1
	JOIN 
	DIM_LOCATION AS T2
	ON T1.IDLocation = T2.IDLocation
	JOIN 
	DIM_MODEL AS T3 ON T1.IDModel = T3.IDModel
	where YEAR(CONVERT(DATE, Date, 103)) >= 2005
	Group by State,YEAR(CONVERT(DATE, Date, 103))








--Q1--END

--Q2--BEGIN
SELECT top 1 State, Manufacturer_Name ,COUNT(Manufacturer_Name) AS ITEM FROM DIM_LOCATION AS T1
JOIN 
FACT_TRANSACTIONS AS T2
ON T1.IDLocation = T2.IDLocation
JOIN
DIM_MODEL AS T3
ON T2.IDModel = T3.IDModel 
JOIN 
DIM_MANUFACTURER AS T4 ON T3.IDManufacturer = T4.IDManufacturer
Where Country = 'US' AND Manufacturer_Name = 'Samsung'
Group by State, Manufacturer_Name











--Q2--END

--Q3--BEGIN      
	
Select State, ZipCode, IDModel,count(IDCustomer) as Count_Transaction from FACT_TRANSACTIONS AS T1
JOIN 
DIM_LOCATION AS T2
ON T1.IDLocation = T2.IDLocation
group by State, ZipCode, IDModel








--Q3--END

--Q4--BEGIN

Select Model_Name, Manufacturer_Name, Min(TotalPrice) as TotalPrice from FACT_TRANSACTIONS AS T1
JOIN 
DIM_MODEL AS T2
ON T1.IDModel = T2.IDModel
JOIN
DIM_MANUFACTURER AS T3 ON T2.IDManufacturer = T3.IDManufacturer
Group by Model_Name, Manufacturer_Name
Order by TotalPrice ASC





--Q4--END

--Q5--BEGIN

Select  T1.IDModel ,Sum(Quantity) as Total_Qty,AVG(TotalPrice) as Average_Price from FACT_TRANSACTIONS AS T1
JOIN 
DIM_MODEL AS T2
ON T1.IDModel = T2.IDModel
JOIN 
DIM_MANUFACTURER AS T3
ON T2.IDManufacturer = T3.IDManufacturer
Group by  T1.IDModel
Order By Average_Price DESC










--Q5--END

--Q6--BEGIN

SELECT Customer_Name, AVG(TotalPrice) as Amount_Spent, YEAR(CONVERT(DATE, Date, 103)) AS Year from FACT_TRANSACTIONS AS T1
JOIN 
DIM_CUSTOMER AS T2
ON T1.IDCustomer = T2.IDCustomer
Group by Customer_Name , YEAR(CONVERT(DATE, Date, 103))
Having YEAR(CONVERT(DATE, Date, 103))= '2009' AND AVG(TotalPrice) > 500
Order by  Amount_Spent DESC





--Q6--END
	
--Q7--BEGIN 
select * from ( 
SELECT TOP 5 IDModel from FACT_TRANSACTIONS 
where YEAR(date) =  2008
Group by IDModel, YEAR(date)
Order by sum(Quantity) DESC
) as A

Intersect

select * from ( 
SELECT TOP 5 IDModel from FACT_TRANSACTIONS 
where YEAR(date) =  2009
Group by IDModel, YEAR(date)
Order by sum(Quantity) DESC	
) as B

Intersect
select * from ( 
SELECT TOP 5 IDModel from FACT_TRANSACTIONS 
where YEAR(date) =  2010
Group by IDModel, YEAR(date)
Order by sum(Quantity) DESC
) as C











--Q7--END
	
--Q8--BEGIN
Select *  from (
Select TOP 1 * from (
Select TOP 2 Manufacturer_Name, SUM(TotalPrice) as Sales, YEAR(CONVERT(DATE, Date, 103)) AS Year from FACT_TRANSACTIONS AS T1 
JOIN 
DIM_MODEL AS T2
ON T1.IDModel = T2.IDModel
JOIN 
DIM_MANUFACTURER AS T3
ON T2.IDManufacturer = T3.IDManufacturer
where YEAR(CONVERT(DATE, Date, 103)) =  2009
group by Manufacturer_Name, YEAR(CONVERT(DATE, Date, 103))
Order by Sales desc
) as A
Order by Sales desc
) as B

Union 
 
Select *  from (
Select TOP 1 * from (
Select TOP 2 Manufacturer_Name, SUM(TotalPrice) as Sales, YEAR(CONVERT(DATE, Date, 103)) AS Year from FACT_TRANSACTIONS AS T1 
JOIN 
DIM_MODEL AS T2
ON T1.IDModel = T2.IDModel
JOIN 
DIM_MANUFACTURER AS T3
ON T2.IDManufacturer = T3.IDManufacturer
where YEAR(CONVERT(DATE, Date, 103)) =  2010
group by Manufacturer_Name, YEAR(CONVERT(DATE, Date, 103))
Order by Sales desc
) as C
Order by Sales desc
) as D













--Q8--END
--Q9--BEGIN
Select Manufacturer_Name from FACT_TRANSACTIONS AS T1 
JOIN 
DIM_MODEL AS T2
ON T1.IDModel = T2.IDModel
JOIN 
DIM_MANUFACTURER AS T3
ON T2.IDManufacturer = T3.IDManufacturer
WHERE  YEAR(CONVERT(DATE, Date, 103)) =  2010
group by Manufacturer_Name

except 

Select Manufacturer_Name from FACT_TRANSACTIONS AS T1 
JOIN 
DIM_MODEL AS T2
ON T1.IDModel = T2.IDModel
JOIN 
DIM_MANUFACTURER AS T3
ON T2.IDManufacturer = T3.IDManufacturer
WHERE  YEAR(CONVERT(DATE, Date, 103)) =  2009
group by Manufacturer_Name













--Q9--END

--Q10--BEGIN
Select *, ((AVG_Spend- lag_spend)/ lag_spend) as Change_Percentage from (
Select *, lag(AVG_Spend,1) over ( partition by IDCustomer order by year) as lag_spend from (
Select IDCustomer, Year(date) AS YEAR, AVG(TotalPrice) as AVG_Spend, SUM(Quantity) AS TOTAL_QTY from FACT_TRANSACTIONS  
WHERE IDCustomer IN (Select TOP 10 IDCustomer from FACT_TRANSACTIONS 
                      Group by IDCustomer
                      ORDER BY SUM(TotalPrice) DESC)
Group by IDCustomer,Year(date)
) AS A 
) AS B








--Q10--END
	