create database IMDB_analysis
GO
Use IMDB_analysis
GO
select * from IMDB_analysis

alter table IMDB_analysis
drop column Num;
---1/Total movies by year
select year(released) as year, count(ID) as number_movies
from IMDB_analysis
group by year(released);

--2/ Total movies by country
select country, count(ID) as number_movies
from IMDB_analysis
group by country
order by count(ID) desc;
--3.Top runtime 
select min(runtime) from IMDB_analysis
select max(runtime) from IMDB_analysis;
with cte_runtime 
as
(
select ID,
case
when runtime between 50 and 70 then '[50,70]'
when runtime between 71 and 100 then '(70,100]'
when runtime between 101 and 130 then '(100;130]'
when runtime between 131 and 160 then '(130,160]'
when runtime between 161 and 190 then '(160,190]'
when runtime between 191 and 210 then '(190,210]'
when runtime between 211 and 240 then '(210,240]'
when runtime between 241 and 270 then '(240,270]'
else '(270,300]'
end as run_time
from IMDB_analysis
group by runtime,ID
) 
select run_time,count(ID) as number_movies
from cte_runtime
group by run_time
order by count(ID) desc;
--4. Top 10 genre
select * from IMDB_analysis;
select top 10 genre, count(ID) as number_movies
from IMDB_analysis
group by genre
order by count(ID) desc;
--5. Top 10 movies with the highest rating
select top 10 ID, title, year, country, rating
from IMDB_analysis
order by rating desc;
--6. Top 10 movies with the highest votes
select top 10 ID, title, year, country, votes
from IMDB_analysis
order by rating desc;
----7/ Total movies by country
select language, count(ID) as number_movies
from IMDB_analysis
group by language
order by count(ID) desc;
--8/The director with the most movies
select top 5 director, count(ID) as number_movies
from IMDB_analysis
group by director
order by count(ID) desc;
--9/The movies by rating
select top 5 title, votes
from IMDB_analysis
order by votes desc;
--10. The movies with a rating of 9.0 and more
select title,rating, votes
from IMDB_analysis
where rating >= 9
order by rating desc;