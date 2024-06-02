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

 --Q7
 Select Cust_id, count(transaction_id) as count_Trans from Transactions
 group by cust_id
 having  count(transaction_id) > 10

