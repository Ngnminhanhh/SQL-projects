create database hotel_revenue
GO
use hotel_revenue
GO
select * from year_2018
select * from year_2019
select * from year_2020
select * from market_segment
select * from meal_cost
---drop column agent and company
alter table year_2018
drop column agent
alter table year_2018
drop column company

alter table year_2019
drop column agent
alter table year_2019
drop column company

alter table year_2020
drop column agent
alter table year_2020
drop column company

--Combine 3 tables year_2018;year_2019;year_2020
select * from year_2018
union
select * from year_2019
union 
select * from year_2020

--Hotel revenue by year
with cte_hotels as 
(
select * from year_2018
union
select * from year_2019
union 
select * from year_2020
) 
select 
arrival_date_year,
hotel,
round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue
from cte_hotels
group by arrival_date_year,hotel;

---join 3 tables
with cte_hotels as 
(
select * from year_2018
union
select * from year_2019
union 
select * from year_2020
) 
select * from cte_hotels 
left join market_segment on cte_hotels.market_segment = market_segment.market_segment
left join meal_cost on cte_hotels.meal = meal_cost.meal;

--Net sales by year
with cte_hotels as 
(
select * from year_2018
union
select * from year_2019
union 
select * from year_2020
) 
select 
arrival_date_year,
hotel,
round(sum((cte_hotels.stays_in_week_nights + cte_hotels.stays_in_weekend_nights)*cte_hotels.adr*market_segment.discount),2) as net_sales
from cte_hotels 
left join market_segment on cte_hotels.market_segment = market_segment.market_segment
group by arrival_date_year,hotel;
--Number of the customers required car parking spaces
with cte_hotels as 
(
select * from year_2018
union 
select * from year_2019
union 
select * from year_2020
) 
select 
arrival_date_year,
hotel,
required_car_parking_spaces,
count(required_car_parking_spaces) as quantity
from cte_hotels
where required_car_parking_spaces > 0
group by arrival_date_year,hotel,required_car_parking_spaces;

--Number of the bookings were canceled by year
with cte_hotels as 
(
select * from year_2018
union 
select * from year_2019
union 
select * from year_2020
) 
select arrival_date_year, 
hotel,
count(is_canceled) as booking_canceled
from cte_hotels
where is_canceled= '1'
group by arrival_date_year,hotel;
---Revenue by month 
select 
arrival_date_year,
arrival_date_month,
round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue
from year_2018
group by arrival_date_year,arrival_date_month
order by revenue asc;

select 
arrival_date_year,
arrival_date_month,
round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue
from year_2019
group by arrival_date_year,arrival_date_month
order by revenue asc;

select 
arrival_date_year,
arrival_date_month,
round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue
from year_2020
group by arrival_date_year,arrival_date_month
order by revenue asc;

--Customer type
with cte_hotels as 
(
select * from year_2018
union 
select * from year_2019
union 
select * from year_2020
) 
select 
arrival_date_year,
customer_type,
count(customer_type) as quantity
from cte_hotels
group by arrival_date_year,customer_type;
--Number of booking by country
with cte_hotels as 
(
select * from year_2018
union
select * from year_2019
union 
select * from year_2020
) 
select distinct
arrival_date_year,
country,
count(country) as number_of_booking
from cte_hotels
group by
arrival_date_year,country
order by arrival_date_year;

--Meal type rate
with cte_hotels as 
(
select * from year_2018
union
select * from year_2019
union 
select * from year_2020
) 
select distinct
arrival_date_year,
meal,
round((count(meal)*100)/(select count(meal) from cte_hotels),2) as type_meal_rate
from cte_hotels 
group by arrival_date_year,meal
order by arrival_date_year;
---Number of Booking per Room Type
with cte_hotels as 
(
select * from year_2018
union
select * from year_2019
union 
select * from year_2020
) 
select distinct
assigned_room_type,
count(assigned_room_type) as quantity
from cte_hotels
group by assigned_room_type;

--revenue by market segment 
with cte_hotels as 
(
select * from year_2018
union
select * from year_2019
union 
select * from year_2020
) 
select 
cte_hotels.market_segment,
round(sum((cte_hotels.stays_in_week_nights + cte_hotels.stays_in_weekend_nights)*cte_hotels.adr*market_segment.discount),2) as revenue
from cte_hotels 
left join market_segment on cte_hotels.market_segment = market_segment.market_segment
group by cte_hotels.market_segment;
--Number of booking per desposit type
with cte_hotels as 
(
select * from year_2018
union
select * from year_2019
union 
select * from year_2020
) 
select distinct
deposit_type,
count(deposit_type) as quantity
from cte_hotels
group by deposit_type;