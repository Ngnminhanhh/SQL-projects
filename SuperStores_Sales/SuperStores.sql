create database SuperStores
GO
Use SuperStores
GO
select * from SuperStores
--Drop necessary columns:
Alter table SuperStores
Drop Column Row_ID;
Alter table SuperStores
Drop Column Postal_Code;
Alter table SuperStores
Drop Column Country; --- only US
Select * from SuperStores;

---SALES AND PROFIT OVER YEAR
select (concat(month(Order_Date) , '/' , year(Order_Date))) as Month,
round(Sum(Sales),2) as total_sales,
round(Sum(Profit),2) as total_profit,
count(distinct Order_ID) as No_of_Orders
from SuperStores
group by Month(Order_Date),Year(Order_Date)
order by Year(Order_Date),Month(Order_Date);

---SALES AND PROFIT BY SHIP MODE
Select
Ship_Mode,
count(distinct Order_ID) as Number_of_orders,
round(sum(sales), 2) as total_sales,
round(sum(profit),2) as total_profit
from SuperStores
group by Ship_Mode;

--SALES AND PROFIT BY SEGMENT
Select
Segment,
count(distinct Order_ID) as Number_of_orders,
round(sum(sales), 2) as total_sales,
round(sum(profit),2) as total_profit
from SuperStores
group by Segment;

---CITY ANALYSIS:
-----1/Top 10 highest selling cities
select 
top 10 city,
round(sum(sales),2) as total_sales
from SuperStores
group by city
order by sum(sales) desc;
---2/Top 10 least selling cities
select 
top 10 city,
round(sum(sales),2) as total_sales
from SuperStores
group by city
order by sum(sales) asc;
---3/Top 10 highest profitable cities:
select 
top 10 city,
round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit
from SuperStores
group by city
order by sum(profit) desc;
--4/Top 10 least profitable cities:
select 
top 10 city,
round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit
from SuperStores
group by city
order by sum(profit) asc;


--- STATE ANALYSIS:
-----1/Top 10 highest selling cities
select 
top 10 state,
round(sum(sales),2) as total_sales
from SuperStores
group by state
order by sum(sales) desc;
---2/Top 10 least selling cities
select 
top 10 state,
round(sum(sales),2) as total_sales
from SuperStores
group by state
order by sum(sales) asc;
---3/Top 10 highest profitable cities:
select 
top 10 state,
round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit
from SuperStores
group by state
order by sum(profit) desc;
--4/Top 10 least profitable cities:
select 
top 10 state,
round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit
from SuperStores
group by state
order by sum(profit) asc;

---REGION ANALYSIS:
select 
region,
count(distinct Order_ID) as No_orders,
round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit
from SuperStores
group by region
order by total_profit desc;


---CATEGORY ANALYSIS:
select 
category,
count(distinct Order_ID) as No_orders,
sum(quantity) as total_quantity,
round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit
from SuperStores
group by category
order by total_profit desc;

---SUB-CATEGORY ANALYSIS:
select 
sub_category,
count(distinct Order_ID) as No_orders,
sum(quantity) as total_quantity,
round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit
from SuperStores
group by Sub_category
order by total_profit desc;


---PRODUCT ANALYSIS:
-----1/Top 10 highest selling cities
select 
top 10 Product_Name,
count(distinct Order_Id) as No_orders,
sum(quantity) as total_quantity,
round(sum(sales),2) as total_sales
from SuperStores
group by Product_Name
order by sum(sales) desc;
---2/Top 10 least selling cities
select 
top 10 Product_Name,
count(distinct Order_Id) as No_orders,
sum(quantity) as total_quantity,
round(sum(sales),2) as total_sales
from SuperStores
group by Product_Name
order by sum(sales) asc;
---3/Top 10 highest profitable cities:
select 
top 10 Product_Name,
count(distinct Order_Id) as No_orders,
sum(quantity) as total_quantity,
round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit
from SuperStores
group by Product_Name
order by sum(profit) desc;
--4/Top 10 least profitable cities:
select 
top 10 Product_Name,
count(distinct Order_Id) as No_orders,
sum(quantity) as total_quantity,
round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit
from SuperStores
group by Product_Name
order by sum(profit) asc;

----CUSTOMER ANALYSIS:Retention rate in 2018
with customer_analysis as
(
select Order_Id,
Order_date,
Customer_id,
Customer_name
from SuperStores
where year(order_date) = 2018
),
first_month as
(
select Customer_id,
datepart(month, min(order_date))as first_month
from customer_analysis
group by Customer_id
),
new_customers_by_month as
(
select
first_month,
count(distinct customer_id) as new_customers
from first_month
group by first_month
),
customers_retention_month as
(
select customer_id,
datepart(month,order_date) as retention_month
from customer_analysis
group by customer_id,
datepart(month,order_date)
),
retained_customers_by_month as
(
select first_month, 
retention_month,
count(customers_retention_month.customer_id) as retained_customers
from customers_retention_month left join first_month 
on customers_retention_month.customer_id = first_month.customer_id
group by first_month, retention_month
)
select retained_customers_by_month.first_month, 
retention_month,
new_customers,
retained_customers,
cast(round(convert(numeric,retained_customers)*100/new_customers,2) as numeric(36,2)) as retention_rate 
from retained_customers_by_month
left join new_customers_by_month
on retained_customers_by_month.first_month = new_customers_by_month.first_month
order by 1,2;

--PRODUCT ANALYSIS
---Top 10 highest profitable Product
SELECT top 10 Product_Name,
sum(Sales) as total_sales,
suM(Profit) as total_profit
from SuperStores
group by product_name
order by Total_profit desc;
--- Top 10 least profitable Product
SELECT top 10 Product_Name,
sum(Sales) as total_sales,
suM(Profit) as total_profit
from SuperStores
group by product_name
order by Total_profit asc;
