-- Q1)
-- Find all customers whose credit score is above the average credit score of all customers. 
-- Display full name, city, and credit score.

select concat(first_name,' ',last_name) as full_name , city ,
credit_score from customers where credit_score > 
(select avg(credit_score) from customers);

-- Q2) 
-- Find all customers who have at least one Home loan. 
-- Display full name and city. 

select concat(first_name,' ',last_name) as full_name , city 
from customers where customer_id in 
(select customer_id from loans where loan_type = 'Home');

-- Q3) 
-- Find all customers who have never taken any loan. 
-- Display full name and city. 

select concat(first_name,' ',last_name) as full_name , city
from customers where customer_id not in 
(select customer_id from loans); 

-- Q4) 
-- From the transactions table, find the average transaction amount per account, 
-- then find all accounts whose average is above the overall average. 
-- Display account_id and their average transaction amount. 

select account_id , avg(amount) as avg_amt from transactions
group by account_id having avg_amt > 
(select avg(amount) from transactions);

-- Q5) 
-- For each customer, find their highest account balance and show it alongside their name. 

select concat(first_name,' ',last_name) as full_name ,
(select max(balance) from accounts where accounts.customer_id = customers.customer_id)
as highest_bal from customers;

-- Q6) 
-- Find all customers who have at least one active account. 

select customer_id , concat(first_name,' ',last_name) as full_name
from customers where exists
(select 1 from accounts where accounts.customer_id = customers.customer_id and account_status = 'Active');

-- Q7) 
-- Find all transactions where the amount is greater than the average transaction amount of that specific merchant category. 
-- Display transaction_id, merchant_category, and amount.

select transaction_id , merchant_category , amount
from transactions t1 where amount > 
(select avg(amount) from transactions t2 where t2.merchant_category = t1.merchant_category);

-- Q8) 
-- Find all customers whose credit score is higher than the average credit score of customers in their own city. 
-- Display full name, city, and credit score. (Correlated subquery — compare each customer against their city's average, not the overall average)

select concat(first_name,' ',last_name) as full_name , city ,
credit_score from customers c1 where credit_score >
(select avg(credit_score) from customers c2 where c2.city = c1.city);

-- Q9) 
-- Find all loans where the EMI amount is greater than the average EMI of that specific loan type. 
-- Display loan_id, loan_type, emi_amount. 

select loan_id , loan_type , emi_amount
from loans l1 where emi_amount > 
(select avg(emi_amount) from loans l2 where l2.loan_type = l1.loan_type);

-- Q10) 
-- Find all customers who have at least one transaction above 40,000 across any of their accounts. 
-- Use EXISTS. Display full name and city. (EXISTS across 3 tables — customers → accounts → transactions)

select concat(c.first_name,' ',c.last_name) as full_name , c.city 
from customers c where exists 
(select 1 from accounts a where a.customer_id = c.customer_id
and exists ( select 1 from transactions t where 
t.account_id = a.account_id and t.amount > 40000));

-- Q11) 
-- For each account, show account_id, account_type, 
-- and the total number of transactions in that account compared to the average number of transactions per account. 
-- Only show accounts that have more transactions than the average. (Correlated subquery in HAVING)

select a.account_id , a.account_type , count(t.transaction_id) as total_ts
from accounts a left join transactions t on a.account_id = t.account_id
group by a.account_id , a.account_type
having total_ts > (select avg(txn_ct)
from ( select count(transaction_id) as txn_ct
from transactions group by account_id)
as account_txn_counts);