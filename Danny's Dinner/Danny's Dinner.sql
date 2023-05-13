create database Case_study1
GO
Use Case_study1
GO

create table members
( 
customer_id varchar(1) primary key,
join_date date
)
GO
create table menu
(
product_id int primary key,
product_name varchar(5),
price int
)

GO
create table sales 
(
customer_id varchar (1),
order_date date,
product_id int
constraint fk_product foreign key(product_id) references menu(product_id)
)
GO

insert dbo.menu
values 
(1,'sushi',10),
(2,'curry',15),
(3,'ramen',12)
GO

insert dbo.members
values
('A','2021/01/07'),
('B','2021/01/09')
GO

insert dbo.sales
values
('A','2021/01/01',1),
('A','2021/01/01',2),
('A','2021/01/07',2),
('A','2021/01/10',3),
('A','2021/01/11',3),
('A','2021/01/11',3),
('B','2021/01/01',2),
('B','2021/01/02',2),
('B','2021/01/04',1),
('B','2021/01/11',1),
('B','2021/01/16',3),
('B','2021/02/01',3),
('C','2021/01/01',3),
('C','2021/01/01',3),
('C','2021/01/07',3);
GO

select * from dbo.members
select * from dbo.sales
select * from dbo.menu

--1/ What is the total amount each customer spent at the restaurant?
select sales.customer_id, sum(menu.price) as total_amount
from dbo.sales
join dbo.menu
on sales.product_id = menu.product_id 
group by sales.customer_id;
--2/How many days has each customer visited the restaurant?
select customer_id, count(distinct(order_date)) as date_visit
from dbo.sales
group by customer_id;
--3/What was the first item from the menu purchased by each customer?
with Firt_item as
(select
sales.customer_id, 
sales.order_date,
menu.product_name,
RANK() over(partition by sales.customer_id order by sales.order_date) as rank_date
from dbo.sales join dbo.menu
on sales.product_id = menu.product_id
group by sales.customer_id, sales.order_date, menu.product_name
)
select * from Firt_item
where rank_date = 1;
--4/What is the most purchased item on the menu and how many times was it purchased by all customers?
select top(1) menu.product_name, count(sales.product_id) as amount_purchase
from dbo.sales join dbo.menu
on sales.product_id = menu.product_id
group by menu.product_name
order by count(sales.product_id) desc
--5/Which item was the most popular for each customer?
with popular_item as
(
select 
sales.customer_id,
menu.product_name,
count(sales.product_id) as amount_product,
RANK() over(partition by customer_id order by count(sales.product_id)) as rank 
from dbo.sales join dbo. menu
on sales.product_id = menu.product_id
group by sales.customer_id, menu.product_name
)
select * from popular_item
where rank = 1
--6/Which item was purchased first by the customer after they became a member?
with item_member as
( 
select sales.customer_id, sales.order_date, menu.product_name,
rank() over( partition by sales.customer_id order by sales.order_date) as rank_date
from 
(dbo.sales join dbo. menu on sales.product_id = menu.product_id)
join dbo.members on sales.customer_id = members.customer_id
where sales.order_date >= members.join_date
group by sales.customer_id,sales.order_date,menu.product_name
)
select * from item_member
where rank_date=1
--7/Which item was purchased just before the customer became a member?
with item_member as
( 
select sales.customer_id, sales.order_date, menu.product_name,
rank() over( partition by sales.customer_id order by sales.order_date) as rank_date
from 
(dbo.sales join dbo. menu on sales.product_id = menu.product_id)
join dbo.members on sales.customer_id = members.customer_id
where sales.order_date < members.join_date
group by sales.customer_id,sales.order_date,menu.product_name
)
select * from item_member
where rank_date=1
--8/What is the total items and amount spent for each member before they became a member?
select sales.customer_id,
count(sales.product_id) as total_item,
sum(menu.price) as amount_spent
from dbo.sales
join dbo.members on sales.customer_id = members.customer_id
join dbo.menu on sales.product_id = menu.product_id
where sales.order_date < members.join_date
group by sales.customer_id;
--9/If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
with points as
(
select product_id,
case when product_id = 1 then price*20
else price*10
end as point
from dbo.menu 
) 
select sales.customer_id, sum(points.point) as total_point
from dbo.sales join points
on sales.product_id = points. product_id
group by sales.customer_id;
/*--10/In the first week after a customer joins the program (including their join date) they earn 
2x points on all items, not just sushi - how many points do customer A and B have at the end of January?*/
with dates as
(
select *,
dateadd(day,6, join_date) as program_date,
EOMONTH('2021/01/31') as end_January
from dbo.members
)
select sales.customer_id,
sum
(case 
when menu.product_id = 1 then menu.price * 20
when sales.order_date between dates.join_date and dates.program_date then menu.price*20
else menu.price*10
end) as points
from sales join dates on sales.customer_id = dates.customer_id
join menu on sales.product_id = menu.product_id
where sales.order_date < dates.end_January
group by sales.customer_id