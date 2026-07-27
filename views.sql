# V1) 
-- Create a view called vw_prime_customers that shows all customers with a credit score above 750. 
-- Include customer_id, full name, city, credit_score, and their credit tier using CASE WHEN. 
-- (This view would be used by the pre-approved offers team)

-- Credit Tier

# 800 and above → 'Excellent'
# 700 to 799 → 'Good'
# 600 to 699 → 'Fair'
# Below 600 → 'Poor'

create view vw_prime_customers as
select customer_id , concat(first_name, ' ', last_name) as full_name ,
city , credit_score , 
case 
	when credit_score >= 800 then 'Excellent'
    when credit_score >= 700 then 'Good'
    when credit_score >= 600 then 'Fair'
    else 'Poor'
end as credit_tier from customers;

select* from vw_prime_customers;

# V2) 
-- Create a view called vw_loan_dashboard that joins customers and loans. 
-- Include full name, city, loan_type, principal_amount, emi_amount, loan_status, and months active using TIMESTAMPDIFF. 
-- (This view would be used by the loans monitoring team)

# Loan Status Flag

# loan_status = 'Defaulted' → 'High Risk'
# loan_status = 'Active' AND months active exceeds tenure → 'Overdue'
# loan_status = 'Active' → 'On Track'
# Else → 'Closed' 

create or replace view vw_loan_dashboard as 
select concat(c.first_name, ' ', c.last_name) as full_name , c.city , l.loan_type , l.tenure_months ,
l.principal_amount , l.emi_amount , l.loan_status ,  timestampdiff(month, l.disbursement_date , curdate()) as months_active,
case
	when l.loan_status = 'Defaulted' then 'High Risk'
    when l.loan_status = 'Active' and timestampdiff(month, l.disbursement_date , curdate()) > l.tenure_months then 'Overdue'
    when l.loan_status = 'Active' then 'On Track'
    else 'Closed'
end as loan_status_flag from customers c join loans l on c.customer_id = l.customer_id;

select* from vw_loan_dashboard;

# V3) 
-- Create a view called vw_city_performance that shows per city: 
-- total customers, average credit score rounded to 2 places, total accounts, and total balance. 
-- (This is a management summary view)

create view vw_city_performance as
select c.city , count(c.customer_id) as total_customers , round(avg(c.credit_score), 2) as avg_cc ,
count(a.account_id) as total_accounts , sum(a.balance) as total_bal 
from customers c join accounts a on c.customer_id = a.customer_id group by c.city;

select* from vw_city_performance;

# V4) 
-- Create a view called vw_transaction_summary that shows per account: 
-- account_id, total transactions, total amount, average amount, and largest single transaction. 
-- (Used by the fraud detection team to spot unusual accounts)

create or replace view vw_transaction_summary as
select t1.account_id , count(t1.transaction_id) as total_ts , sum(t1.amount) as total_amount ,
avg(t1.amount) as avg_amount , (select max(amount) from transactions t2 where t1.account_id = t2.account_id)
as highest_ts from transactions t1 group by t1.account_id;

select* from vw_transaction_summary;

# V5) 
-- Create a view called vw_defaulter_risk that flags customers at risk. 
-- Include full name, city, credit_score, loan_type, loan_status, payment_status, and days_overdue. 
-- Only include customers who have at least one Missed or Late payment. 
-- (The most important view — used by the risk team daily)

# Risk Level Flag

# payment_status = 'Missed' AND credit_score < 600 → 'Critical Risk'
# payment_status = 'Missed' → 'High Risk'
# payment_status = 'Late' → 'Moderate Risk'
# Else → 'Monitor'

create view vw_defaulter_risk as
select concat(c.first_name, ' ', c.last_name) as full_name , c.city , c.credit_score ,
l.loan_type , l.loan_status , lp.payment_status , lp.days_overdue ,
case 
	when lp.payment_status = 'Missed' and c.credit_score < 600 then 'Critical Risk'
    when lp.payment_status = 'Missed' then 'High Risk'
    when lp.payment_status = 'Late' then 'Moderate Risk'
    else 'Monitor'
end as risk_level_flag from customers c join loans l on c.customer_id = l.customer_id
join loan_payments lp on l.loan_id = lp.loan_id;

select* from vw_defaulter_risk;

# V6) 
-- After creating all views, write the queries to:

# List all views in the database
# Query vw_prime_customers filtered to only Mumbai
# Drop and recreate vw_prime_customers adding joining_date to the columns

select* from vw_prime_customers;
select* from vw_loan_dashboard;
select* from vw_city_performance;
select* from vw_transaction_summary;
select* from vw_defaulter_risk;

select* from vw_prime_customers where city = 'Mumbai';

drop view if exists vw_prime_customers;

create view vw_prime_customers as
select customer_id , concat(first_name, ' ', last_name) as full_name ,
city , credit_score , joining_date ,
case 
	when credit_score >= 800 then 'Excellent'
    when credit_score >= 700 then 'Good'
    when credit_score >= 600 then 'Fair'
    else 'Poor'
end as credit_tier from customers;

select* from vw_prime_customers;