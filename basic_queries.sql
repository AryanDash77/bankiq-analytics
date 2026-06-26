select* from accounts where balance<5000;

select account_status from accounts;

SELECT COUNT(*) FROM transactions WHERE merchant_category IS NULL;

select* from customers limit 5;

-- Q1)
-- Find all customers with a credit score above 750. 
-- Show their customer_id, first_name, last_name, city, 
-- and credit_score.
-- Sort by credit score highest first.

select customer_id , first_name , last_name , city ,
credit_score from customers order by credit_score desc;

-- Q2)
-- Show the top 10 customers by credit score. 
-- Display their full name as a single column called full_name, 
-- along with city and credit_score.

select concat(first_name, ' ' ,last_name) as full_name , city ,
credit_score  from customers order by credit_score desc; 

-- Q3)
-- What are all the unique cities and states 
-- our customers come from? Sort by state, then city.

select distinct city , state from customers
order by 2,1;

-- Q4)
-- Find all customers whose credit score falls 
-- between 620 and 699. Sort by credit score descending.

select customer_id , concat(first_name, ' ' ,last_name) as full_name ,
credit_score , city from customers where credit_score between 620 and 699
order by 3;

-- Q5)
-- The marketing team wants to run a Gmail campaign. 
-- Find all customers with a Gmail email address.

select concat(first_name, ' ' ,last_name) as full_name ,
email from customers where email is not null;

-- Q6)
-- Show all accounts belonging to customers from Mumbai, 
-- Delhi, Bangalore, Chennai, or Hyderabad. 
-- Include their name, city, account type, and balance.

select concat(first_name, ' ' ,last_name) as full_name , 
city , account_type , balance from customers join accounts
on customers.customer_id = accounts.customer_id where city in 
('Mumbai','Delhi','Bangalore','Chennai','Hyderabad');

-- Q7) 
-- Find all transactions where merchant_category 
-- has no value recorded.

select transaction_id , account_id , amount , transaction_date ,
merchant_category from transactions where
merchant_category is null;

-- Q8) 
-- Find all accounts that are either Inactive or Closed 
-- AND have a balance below 5000. 
-- Sort by balance lowest first.

select concat(first_name, ' ' ,last_name) as full_name ,
account_type , balance , account_status from accounts join 
customers on accounts.customer_id = customers.customer_id
where account_status in ('Inactive','Closed') and balance<5000
order by balance ;






