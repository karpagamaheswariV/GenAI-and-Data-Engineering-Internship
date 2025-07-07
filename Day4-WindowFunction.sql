use hrdb;
select * from hrdb.hr_employee;

-- schema for the table
describe hr_employee;


-- WINDOW FUNCTIONS
-- 1. Cumulative sum of total working years by each dept in hremployee table
select Department, sum(`Total Working Years`) as Total_Working_Yrs from hr_employee group by(Department);

-- over() 
-- partition by --> dept start counting from 1 for each dept 
select `Employee Number` ,Department,`Total Working Years`,sum(`Total Working Years`) 
over(partition by Department order by `Employee Number`) as Cumulative_Working_Year from hr_employee;

-- 2. Window function - Rank()
-- To find rank of employee with each job role and ranked by monthly income.
select `Employee Number` ,Department,`total working years`,`Job Role`,`Monthly Income`,`Marital Status`,
rank()
over(partition by `Job Role` order by `monthly income` desc) as Employee_Rank from hr_employee;
-- in this the output the rank if 2 are same income then the rank will be same eg 32 and 32 but the next rank will start from 34 not 33


-- 3. DENSE_RANK()
-- to solve this 

select `Employee Number` ,Department,`total working years`,`Job Role`,`Monthly Income`,`Marital Status`,
dense_rank()
over(partition by `Job Role` order by `monthly income` desc) as Employee_Rank from hr_employee;
-- IT WILL NOT CHANGE THE SEQUENCE THAT IS 32 32 AND NEXT NUMBER WILL BE 33 NOT 34 NOT LIKE THE RANK().

-- 4. ROWNUMBER()
-- Assign unique numbers to each employee for each job role based on employee number and year at company
select `Employee number`,`job role`,`monthly income`,`years at company`,row_number() 
over(partition by `Job Role` order by `Employee number` asc) as Unique_Emp_num from hr_employee;


-- Assign unique numbers to each employee for each job role based on year at company
select `Employee number`,`job role`,`monthly income`,`years at company`,row_number() 
over(partition by `Job Role` order by `years at company` desc) as Unique_years_at_company from hr_employee;

-- 5. LEAD() -> NEXT VALUE 
-- Write a sql query to each employee's monthly income with next employee's income
select `Employee number`,`job role`,`monthly income`,`years at company`,lead(`monthly income`) 
over(order by `Employee number` ) as Next_Employee_Income from hr_employee;

-- 6. LAG() -> PREVIOUS VALUE 
-- Write a sql query to each employee's monthly income with previous employee's income
select `Employee number`,`job role`,`monthly income`,`years at company`,lag(`monthly income`) 
over(order by `Employee number` ) as Previous_Employee_Income from hr_employee;

-- 7.NTILE() -> used to divides the result set into a specified number of buckets and assign a buckets to each row
-- ntile(4)-> number 4 denotes the no of buckets 
-- Divide employees into four equal buckets on basics of their years of experience within each job role
select `Employee number`,`job role`,`monthly income`,`years at company`,`total working years` ,ntile(5) 
over(partition by `job role` order by `total working years` ) as Buckets from hr_employee;

-- 8. PERCENT_RANK() -> the percentile will be from 0 to 1
-- Calculate percentile rank based on each employee's salary hike.
select `Employee number`,`job role`,`monthly income`,`years at company`,`total working years` ,`Percent Salary hike`,percent_rank() 
over( order by `Percent Salary hike` ) as salary_percent_rank from hr_employee;

-- 9. NTH_VALUE() 
-- Get second highest experienced employee from each job role.
select `Employee number`,`job role`,`monthly income`,`years at company`,`total working years` ,`Percent Salary hike`,
nth_value(`total working years`,2)
over( partition by `job role` order by`total working years` desc ) as second_highest_emp from hr_employee;

-- 10. Write a query to compare current employee income with next employee income in each job role.
-- `monthly income` - lead(`monthly income`) diff btw current and next
select `Employee number`,`job role`,`monthly income`,lead(`monthly income`) over(order by `Employee number` ) as Next_Emp_Income,
(`monthly income` - lead(`monthly income`) over(order by `Employee number` )) as Difference_in_Employee_Income from hr_employee  ;