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

select city , round(avg(credit_score),2) as avg_cc 
from customers group by city;

-- Q4) 
-- Which cities have more than 10 customers? 
-- (This is where HAVING comes in — think about why you can't use WHERE here)

select city , count(customer_id) as city_count
from customers group by city
having city_count > 10 ;

-- Q5) 
-- For each loan type, show the total number of loans, total principal amount, average interest rate, and average EMI. 
-- Round all decimals to 2 places.

select loan_type , count(loan_id) as loan_count ,
round(sum(principal_amount),2) as total_pa , round(avg(interest_rate),2) as avg_ir ,
round(avg(emi_amount),2) as avg_emi from loans group by loan_type;

-- Q6) 
-- For each customer, show their full name and total number of transactions across all their accounts. 
-- Only show customers who have made at least 5 transactions.

select concat(c.first_name,' ',c.last_name) as full_name ,
count(t.transaction_id) as trans_count from customers c join
accounts a on a.customer_id = c.customer_id join transactions t 
on a.account_id = t.account_id group by full_name
having trans_count >= 5;

-- Q7) 
-- For each payment_status, how many loan payments exist and what is the average days overdue? 
-- Sort by average days overdue descending.

select payment_status , count(payment_id) as lp_count ,
avg(days_overdue) as avg_od from loan_payments 
group by payment_status order by avg_od desc;