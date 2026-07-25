# V1) 
-- Create a view called vw_prime_customers that shows all customers with a credit score above 750. 
-- Include customer_id, full name, city, credit_score, and their credit tier using CASE WHEN. 
-- (This view would be used by the pre-approved offers team)

# V2) 
-- Create a view called vw_loan_dashboard that joins customers and loans. 
-- Include full name, city, loan_type, principal_amount, emi_amount, loan_status, and months active using TIMESTAMPDIFF. 
-- (This view would be used by the loans monitoring team)

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