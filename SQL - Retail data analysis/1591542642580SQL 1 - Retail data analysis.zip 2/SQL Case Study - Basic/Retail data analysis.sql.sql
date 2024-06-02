--DATA Preparation and Understanding
--Q1 
Select count(*) as total_rows from Customer
Union
Select count(*) as total_rows from prod_cat_info
Union
Select count(*) as total_rows from Transactions

--Q2
select * from Transactions
select count(distinct(transaction_id)) as total_trans from Transactions where Qty < 0

--Q3 
select convert(date,tran_date,105) as Trans_Date from Transactions

--Q4 
SELECT Datediff(Year,Min(convert(date,tran_date,105)),Max(convert(date,tran_date,105)))as Diff_years,
Datediff(MONTH,Min(convert(date,tran_date,105)),Max(convert(date,tran_date,105)))as Diff_MONTHS,
Datediff(DAY,Min(convert(date,tran_date,105)),Max(convert(date,tran_date,105)))as Diff_DAYS
from Transactions

--Q5
SELECT prod_cat,prod_subcat from prod_cat_info
 WHERE prod_subcat ='DIY'

 --DATA ANALYSIS 
 --Q1
SELECT Top 1 Store_type, count(transaction_id) as Total_Trans from Transactions
group by Store_type
order by Total_trans desc


--Q2 
select Gender, count(customer_Id) as Customers_Numbers from Customer
Where Gender = 'F' OR Gender='M'
Group by Gender


--Q3 

Select top 1 city_code, count(customer_Id) as Cutomer_Count from Customer
Group by city_code 
order by count(customer_Id) desc

--Q4
Select * from prod_cat_info

Select prod_cat , count(prod_subcat) as total_Subcat from prod_cat_info
where prod_cat = 'Books' 
group by prod_cat 

--Q5

Select prod_cat_code, max(qty) as Max_prod from Transactions
group by prod_cat_code


--Q6
select * from Transactions
Select * from prod_cat_info

select sum(cast(total_amt as float))as Total_Rev from
 Transactions AS T1
 LEFT JOIN prod_cat_info AS T2
 ON T1.prod_cat_code = T2.prod_cat_code AND T1.prod_subcat_code = T2.prod_sub_cat_code
 WHERE prod_cat = 'Books' or prod_cat = 'Electronics'


 select * from Transactions
 select * from Customer
 select * from prod_cat_info


 --Q7
 Select count(*) as total_count from (
 Select Cust_id, count(transaction_id) as count_Trans from Transactions
 WHERE Qty > 0
 group by cust_id
 having  count(transaction_id) > 10 ) AS T1

 --Q8
 select sum(cast(total_amt as float))as	Combined_Rev from
 Transactions AS T1
Inner JOIN prod_cat_info AS T2
 ON T1.prod_cat_code = T2.prod_cat_code AND T1.prod_subcat_code = T2.prod_sub_cat_code
 WHERE prod_cat in ('Clothing' , 'Electronics') and Store_type = 'Flagship store'

--Q9

 select prod_subcat, SUM(CAST(total_amt AS FLOAT)) as Total_Rev from
 Transactions AS T1
 INNER JOIN prod_cat_info AS T2
 ON T1.prod_cat_code = T2.prod_cat_code AND T1.prod_subcat_code = T2.prod_sub_cat_code
 INNER JOIN Customer AS T3 
 ON T1.cust_id = T3.customer_Id
 WHERE prod_cat = 'Electronics' and Gender = 'M'
 Group by prod_subcat 

--Q10
 Select * from (
 select top 5 prod_subcat , (sum(cast(total_amt as float)) / (select sum(cast(total_amt as float))  from Transactions where qty > 0 )) as Total_Percenatge_Sales
 from prod_cat_info AS T1
 Inner JOIN Transactions AS T2
 ON T1.prod_cat_code= T2.prod_cat_code AND T1.prod_sub_cat_code = T2.prod_subcat_code
 where qty > 0
 Group by prod_subcat
 order by Total_Percenatge_Sales desc) as t4
 join
 (
 select  prod_subcat , (sum(cast(total_amt as float)) / (select sum(cast(total_amt as float)) from Transactions where qty < 0 )) as Total_Percenatge_Returns
 from prod_cat_info AS T1
 Inner JOIN Transactions AS T2
 ON T1.prod_cat_code= T2.prod_cat_code AND T1.prod_sub_cat_code = T2.prod_subcat_code
 where qty < 0
 Group by prod_subcat) as t5 
 on t4.prod_subcat = t5.prod_subcat


 --Q11
--Age of Customers
Select * from (
Select * from (
Select cust_id, DATEDIFF(year,DOB,Max_date) as Age, Revenues from (
select cust_id, DOB, max(convert(date, tran_date, 105)) as Max_date, sum(cast(total_amt as float)) as Revenues from Customer as t1
Join Transactions as t2 
on t1.customer_Id = t2.cust_id 
where qty > 0 
group by cust_id, DOB
 ) as A 
        )  as B
WHERE Age between 25 and 35
		                   ) as C                            
JOIN 
--last 30 days of transactions
(Select cust_id, convert(date,tran_date,105) as tran_date from Transactions 
group by cust_id, convert(date,tran_date,105)
having convert(date,tran_date,105) >= (Select  dateadd(day, -30, max(convert(date,tran_date,105))) as cutoff_date from Transactions)
) as D
ON C.cust_id=D.cust_id

--Q12
 select * from Transactions
 select * from prod_cat_info
 select * from Customer


Select top 1 prod_cat_code, sum(returns) as tot_returns from (
Select prod_cat_code , convert(date,tran_date,105) as tran_date, sum(qty) as Returns
FROM Transactions 
WHERE Qty < 0 
GROUP BY  prod_cat_code, convert(date,tran_date,105)
Having  convert(date, tran_date, 105) >= (select dateadd(MONTH,-3, MAX(convert(date, tran_date, 105))) AS CUTOFF_date from Transactions)
) as A
Group by prod_cat_code
Order by tot_returns

--Q13
Select Store_type, sum(cast(total_amt as float)) as Revenues, sum(qty) as Quantity from Transactions
where Qty > 0
GROUP BY Store_type

-- Q14
Select prod_cat, AVG(cast(total_amt as float)) as average_rev from Transactions AS T1
join prod_cat_info as T2
on T1.prod_cat_code = T2.prod_cat_code AND T1.prod_subcat_code = T2.prod_sub_cat_code
where qty > 0 
group by  prod_cat
having AVG(cast(total_amt as float)) >= ( select AVG(cast(total_amt as float)) from Transactions where qty > 0)

--Q15
Select TOP 5 prod_subcat_code, AVG(cast(total_amt as float)) as average_rev, sum(cast(total_amt as float)) as total_rev from Transactions 
where qty > 0 
group by prod_subcat_code
ORDER BY total_rev DESC





