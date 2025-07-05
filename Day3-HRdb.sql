-- ADVANCE SQL QUERY

create database if not exists hrdb;
use hrdb;

select * from hr_employeetable;
select count(*) from hr_employeetable;

ALTER TABLE hr_employeetable RENAME TO hr_employee;
select * from hr_employee;

-- 1. To find all employee having income greater than average employee income
select  `Employee Number` from  hr_employee where `Monthly Income` >(select avg(`Monthly Income`) from  hr_employee);

-- 2. Find all employee having monthly income equal to maximum employee income 
select  * from  hr_employee where `Monthly Income` = (select max(`Monthly Income`) from  hr_employee);
select  `Employee Number`,`Gender`,`Monthly Income`,`Monthly Rate`  from  hr_employee where `Monthly Income` = (select max(`Monthly Income`) from  hr_employee);

-- 3. Show summary of hr employee dataset
select count(*) as TotalEmployee ,count(distinct Department)as TotalDepartments,
count(distinct `Job Role`) as TotalJobRoles,
sum(`Monthly Income`) as Total_CTC,
min(`Monthly Income`) as Minimum_sal,
max(`Monthly Income`) as Maximum_sal from hr_employee;

-- WINDOW FUNCTIONS
-- 4. Cumulative sum of total working years by each dept in hremployee table
select Department, sum(`Total Working Years`) as Total_Working_Yrs from hr_employee group by(Department);

-- over() 
-- partition by --> dept start counting from 1 for each dept 
select `Employee Number` ,Department,`Total Working Years`,sum(`Total Working Years`) 
over(partition by Department order by `Employee Number`) as Cumulative_Working_Year from hr_employee;

-- 5. Window function - Rank()
-- To find rank of employee with each job role and ranked by monthly income.
select `Employee Number` ,Department,`total working years`,`Job Role`,`Monthly Income`,`Marital Status`,
rank()
over(partition by `Job Role` order by `monthly income` desc) as Employee_Rank from hr_employee;
-- in this the output the rank if 2 are same income then the rank will be same eg 32 and 32 but the next rank will start from 34 not 33


-- DENSE_RANK()
-- to solve this 

select `Employee Number` ,Department,`total working years`,`Job Role`,`Monthly Income`,`Marital Status`,
dense_rank()
over(partition by `Job Role` order by `monthly income` desc) as Employee_Rank from hr_employee;
-- IT WILL NOT CHANGE THE SEQUENCE THAT IS 32 32 AND NEXT NUMBER WILL BE 33 NOT 34 NOT LIKE THE RANK().


