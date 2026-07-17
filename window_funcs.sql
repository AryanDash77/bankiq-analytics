-- Q1)
-- Assign a row number to each transaction , ordered by transaction_date. 
-- Display transaction_id, account_id, amount, transaction_date, and the row number.

select transaction_id , account_id , amount , transaction_date ,
row_number() over (order by transaction_date) as row_num
from transactions;

-- Q2)
-- Rank customers by credit score. Show both RANK and DENSE_RANK side by side so you can see the difference. 
-- Display full name, credit score, and both rank columns.

select concat(first_name , ' ' , last_name) as full_name , 
credit_score , rank() over (order by credit_score) as rnk ,
dense_rank() over (order by credit_score) as drnk
from customers;

-- Q3) Within each city, rank customers by credit score highest first. 
-- Display full name, city, credit score, and their rank within their city. 

select concat(first_name , ' ' , last_name) as full_name ,
city , credit_score , rank() over (partition by city
order by credit_score desc) as rnk from customers;

-- Q4) 
-- For each account, show each transaction amount alongside the previous transaction amount using LAG. 
-- Display account_id, transaction_date, amount, and prev_amount. 

-- Q5) 
-- For each account, show each transaction amount alongside the next transaction amount using LEAD. 
-- Q6) 
-- Calculate a running total of transaction amounts per account ordered by date. 
-- Display account_id, transaction_date, amount, and running_total.
-- Q7) 
-- Calculate a 3-transaction moving average of amounts per account. 
-- Display account_id, transaction_date, amount, and moving_avg. (Hint: use ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
-- Q8) 
-- For each city, show each customer alongside the highest credit score in their city and the lowest credit score in their city. 
-- Use FIRST_VALUE and LAST_VALUE. (Hint: ORDER BY credit score DESC for FIRST_VALUE to give you the highest)