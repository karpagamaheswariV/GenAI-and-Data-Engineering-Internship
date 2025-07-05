create database if not exists telecomdb;
use telecomdb;

create table if not exists customer_info(customer_id int,customer_name varchar(50),email varchar(50),data_usage decimal(5,2) ,plan_type varchar(50),
signup_date date,total_data_usage varchar(50),customer_status varchar(50),last_update date,phone_home double ,phone_mobile double);

drop table callrecords;

select * from customer_info;
select count(*) from customer_info;
  
create table callrecords(call_id int,customer_id int,	call_start_time datetime	,call_duration int	,call_type varchar(50),call_date date,
call_cost decimal(5,2),call_category varchar(50));

select * from callrecords;
select count(*) from callrecords;


-- 1. Inner Join
select  *
from customer_info ci 
inner join callrecords cr
on ci.customer_id=cr.customer_id;

select count(*) from customer_info ci inner join callrecords cr on ci.customer_id=cr.customer_id;

 -- 2. Left Outer Join
 select  * from customer_info ci  left outer join callrecords cr on ci.customer_id=cr.customer_id;
 select  count(*) from customer_info ci  left outer join callrecords cr on ci.customer_id=cr.customer_id;

-- 3. Right outer join
select  * from customer_info ci  right outer join callrecords cr on ci.customer_id=cr.customer_id;
select  count(*) from customer_info ci  right outer join callrecords cr on ci.customer_id=cr.customer_id;


-- 4. Full outer join
 select  * from customer_info ci  left outer join callrecords cr on ci.customer_id=cr.customer_id 
 union
 select  * from customer_info ci  right outer join callrecords cr on ci.customer_id=cr.customer_id;


 -- to count full outer join records
 SELECT COUNT(*) AS total_rows
FROM (
    SELECT * 
    FROM customer_info ci 
    LEFT OUTER JOIN callrecords cr ON ci.customer_id = cr.customer_id

    UNION

    SELECT * 
    FROM customer_info ci 
    RIGHT OUTER JOIN callrecords cr ON ci.customer_id = cr.customer_id
) AS combined_result;


-- 5. Create service plan table 
create table service_plan(plan_id int,plan_name varchar(30),monthly_cost decimal(10,2),data_limit_gb int,voice_minutes int,sms_limit int);

select * from service_plan;

-- 6. Cross Join
select ci.customer_id, ci.data_usage,
ci.plan_type,ci.total_data_usage,
sp.plan_name, sp.monthly_cost
 from customer_info ci
CROSS JOIN service_plan sp;


-- 7. Subquery(inner query)
-- A subquery is a query nested with another sql query. Usage - Filtering data
select ci.customer_id,ci.customer_name,ci.phone_mobile,(select sum(cr.call_duration) from  callrecords cr  where cr.customer_id=ci.customer_id) 
as total_time_duration
from customer_info ci;


-- Subquery with where
select ci.customer_id, ci.customer_name,
ci.phone_mobile FROM customer_info ci
INNER JOIN callrecords cdr ON
ci.customer_id = cdr.customer_id
WHERE cdr.call_duration >
(select avg(cdr.call_duration) from
callrecords cdr);


-- Subquery with Where
select ci.customer_id, ci.customer_name,
ci.phone_mobile FROM customer_info ci
WHERE ci.customer_id IN (select
cr.customer_id from callrecords cr);


