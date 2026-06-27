select* from loans;
select* from loan_payments;
select* from transactions;
select* from accounts;

-- Q1. 
-- Show all customers along with their account details. 
-- Display customer_id, full name, city, account_type, balance, and account_status.

select c.customer_id , concat(c.first_name,'',c.last_name) as full_name , c.city ,
a.account_type , a.balance , a.account_status from Customers c join Accounts a
on c.customer_id = a.customer_id;

-- Q2) Find all customers who do not have a loan. 
-- Display their customer_id, full name, and city.

select c.customer_id , concat(c.first_name,' ',c.last_name) as full_name ,
c.city from customers c left join loans l
on c.customer_id = l.customer_id
where l.loan_id is null;

-- Q3) Show all transactions along with the customer who owns that account. 
-- Display transaction_id, full name, account_type, transaction_type, amount, and transaction_date.

select t.transaction_id , concat(c.first_name,' ',c.last_name) as full_name ,
a.account_type , t.transaction_type , t.amount , t.transaction_date
from transactions t join accounts a on t.account_id = a.account_id
join customers c on a.customer_id = c.customer_id;

-- Q4) Show all active loans along with the customer details. 
-- Display full name, city, loan_type, principal_amount, emi_amount, and loan_status.

select concat(c.first_name,' ',c.last_name) as full_name ,
c.city , l.loan_type , l.principal_amount , l.emi_amount ,
l.loan_status from customers c join loans l on
c.customer_id = l.customer_id where l.loan_status = 'Active';

-- Q5) Find all accounts that have never had a transaction. 
-- Display account_id, full name, account_type, and balance.

select a.account_id , concat(c.first_name,' ',c.last_name) as full_name ,
a.account_type , a.balance from accounts a join customers c 
on a.customer_id = c.customer_id left join transactions t
on a.account_id = t.account_id where t.transaction_id is null;

-- Q6) Show the complete loan payment picture — display full name, loan_type, 
-- principal_amount, payment_date, amount_paid, and payment_status.

select concat(c.first_name,' ',c.last_name) as full_name ,
l.loan_type , l.principal_amount , lp.payment_date , lp.amount_paid ,
lp.payment_status from customers c join loans l on
c.customer_id = l.customer_id join loan_payments lp
on l.loan_id = lp.loan_id;