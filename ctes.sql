-- Q1) 
-- Using a CTE, find all customers with a credit score above 750, 
-- then from that CTE select only those from Mumbai or Delhi. 

with mum_del as (
select concat(first_name,' ',last_name) as full_name , city , credit_score
from customers where credit_score > 750)

select full_name , city , credit_score from mum_del
where city in ('Mumbai','Delhi');

-- Q2) 
-- Using a CTE, calculate the total transaction amount per account, 
-- then select only accounts whose total exceeds 500,000. 
-- Display account_id and total amount.

with total_txn as (
select account_id , sum(amount) as total_trans 
from transactions group by account_id)

select account_id , total_trans from total_txn
where total_trans > 500000;

-- Q3) 
-- Write two CTEs — one for high value customers (credit score > 750) 
-- and one for active loans. Then JOIN them to find high value customers who also have active loans. 
-- Display full name, credit score, loan type, and principal amount.

with cc_750 as (
select customer_id , concat(first_name,' ',last_name) as full_name , credit_score
from customers where credit_score > 750) ,

act_loans as (
select customer_id , loan_type , principal_amount from loans
where loan_status = 'Active')

select c.full_name , c.credit_score ,
a.loan_type , a.principal_amount from
cc_750 c join act_loans a on c.customer_id = a.customer_id;

-- Q4) 
-- Write a CTE that calculates each customer's total number of accounts and total balance across all accounts. 
-- Then from that CTE, find customers with more than 1 account and total balance above 100,000.

with noc as (
select customer_id , count(account_id) as ac_ct , sum(balance) as sbal
from accounts group by customer_id)

select customer_id , ac_ct , sbal from noc
where ac_ct > 1 and sbal > 100000;

-- Q5) 
-- Rewrite your Q5 from Task 6 (highest account balance per customer) using a CTE instead of a correlated subquery. 

with hbal as (
select c.customer_id , concat(c.first_name,' ',c.last_name) as full_name , a.balance as bal
from customers c join accounts a on c.customer_id = a.customer_id)

select customer_id , full_name , max(bal) from hbal
group by customer_id , full_name;

-- Q6)
-- Business report — using CTEs, calculate for each city: total customers, average credit score, 
-- total loan amount disbursed, and number of defaulted loans. 

with customer_stats as (
select city , count(customer_id) as cc , avg(credit_score) as acc
from customers group by city) ,

loans_stats as (
select c.city , sum(l.principal_amount) as ts , count(case when l.loan_status = 'Defaulted' then 1 end) as lc 
from customers c join loans l on c.customer_id = l.customer_id
group by c.city)

select cs.city , cs.cc , cs.acc , ls.ts , ls.lc
from customer_stats cs join loans_stats ls on cs.city = ls.city;