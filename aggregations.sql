-- Q1)
-- How many customers does each city have? 
-- Sort by customer count highest first.

select city , count(customer_id) as city_count 
from customers group by city order by city_count desc;

-- Q2)
-- What is the total balance held in each account type? 
-- Sort by total balance descending.

select account_type , sum(balance) as cat_sum
from accounts group by account_type
order by cat_sum desc;

-- Q3) 
-- What is the average credit score of customers in each city? 
-- Round to 2 decimal places.

select avg(credit_score) 

-- Q4) 
-- Which cities have more than 10 customers? 
-- (This is where HAVING comes in — think about why you can't use WHERE here)



-- Q5) 
-- For each loan type, show the total number of loans, total principal amount, average interest rate, and average EMI. 
-- Round all decimals to 2 places.



-- Q6) 
-- For each customer, show their full name and total number of transactions across all their accounts. 
-- Only show customers who have made at least 5 transactions.



-- Q7) 
-- For each payment_status, how many loan payments exist and what is the average days overdue? 
-- Sort by average days overdue descending.