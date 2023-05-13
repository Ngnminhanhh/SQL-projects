create database Sales_Performance_DQLAB
GO
use Sales_Performance_DQLAB
GO
select *  from Sales
--1. Overal performance of DQLAb by year
select year, 
total_sales,
Number_of_orders,
round(((total_sales - lag(total_sales) over (order by year asc))*100)/lag(total_sales) over (order by year asc),2) as growth_sales,
round(((Number_of_orders - lag(Number_of_orders) over( order by year asc))*100)/lag(Number_of_orders) over( order by year asc),2) as growth_sales
from
(
select year(order_date) as Year,
count(order_id) as Number_of_orders,
sum(sales) as total_sales
from Sales 
where order_status = 'Order Finished'
group by year(order_date)
) as a
group by year,total_sales,number_of_orders
order by year;
--2. Overal performance by subcategory on 2011 and 2012
select 
product_sub_category,
total_sales_2011,
total_sales_2012,
round(((total_sales_2012 - total_sales_2011)*100/total_sales_2011),2) as growth_sales,
total_orders_2011,
total_orders_2012,
round(((total_orders_2012 - total_orders_2011)*100/total_orders_2011),2) as growth_orders
from
(
select
product_sub_category,
sum(case when year(order_date) = 2011 then sales else 0 end) as total_sales_2011,
sum(case when year(order_date) = 2012 then sales else 0 end) as total_sales_2012,
sum(case when year(order_date) = 2011 then 1 else 0 end) as total_orders_2011,
sum(case when year(order_date) = 2012 then 1 else 0 end) as total_orders_2012
from Sales
where order_status = 'Order Finished'
group by product_sub_category) as b
group by product_sub_category,total_sales_2011,total_sales_2012,total_orders_2011,total_orders_2012;

--3. Promotion effectiveness and efficiency by year
select year(order_date) as year,
sum(discount_value) as promotion,
sum(sales) as total_sales,
round((sum(discount_value)/sum(sales)*100),2) as discount_percentage
from Sales 
where order_status = 'Order Finished'
group by year(order_date)
order by year(order_date);

--4. Promotion effectiveness and efficiency by product subcategory in 2012
select 
product_sub_category,
product_category,
sum(discount_value) as promotion,
sum(sales) as total_sales,
round((sum(discount_value)/sum(sales)*100),2) as discount_percentage
from Sales
where year(order_date) = 2012
and order_status = 'Order Finished'
group by product_sub_category, product_category
order by discount_percentage;

--5. Number of customers transactions by year
select 
year(order_date) as year,
count (distinct customer) as number_of_customer 
from Sales
where order_status = 'Order Finished'
group by year(order_date)
order by year(order_date);

--6.New Customers per year
select 
year(first_order_date) as year,
count(distinct customer) as number_of_customer
from
(
select
order_id,
customer,
min(order_date) as first_order_date
from Sales 
where order_status = 'Order Finished'
group by order_id,customer
) as a
group by year(first_order_date)
order by year(first_order_date);