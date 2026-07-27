# V1) 
-- Create a view called vw_prime_customers that shows all customers with a credit score above 750. 
-- Include customer_id, full name, city, credit_score, and their credit tier using CASE WHEN. 
-- (This view would be used by the pre-approved offers team)

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

create view vw_loan_dashboard as 
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



# V4) 
-- Create a view called vw_transaction_summary that shows per account: 
-- account_id, total transactions, total amount, average amount, and largest single transaction. 
-- (Used by the fraud detection team to spot unusual accounts)

# V5) 
-- Create a view called vw_defaulter_risk that flags customers at risk. 
-- Include full name, city, credit_score, loan_type, loan_status, payment_status, and days_overdue. 
-- Only include customers who have at least one Missed or Late payment. 
-- (The most important view — used by the risk team daily)

# V6) 
-- After creating all views, write the queries to:

# List all views in the database
# Query vw_prime_customers filtered to only Mumbai
# Drop and recreate vw_prime_customers adding joining_date to the columns