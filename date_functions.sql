-- Q1)
-- For each customer, extract the year and month they joined. 
-- Display full name, joining_date, join_year, and join_month. Filter for customers who joined in 2022.

select concat(first_name,' ',last_name) as full_name , joining_date ,
year(joining_date) as join_year , month(joining_date) as join_month 
from customers;

-- Q2) 
-- For each active loan, calculate how many days it has been since disbursement. 
-- Display loan_id, loan_type, disbursement_date, and days_active. 
-- Sort by days_active descending.

select loan_id , loan_type , disbursement_date ,
datediff(curdate(), disbursement_date) as days_active
from loans where loan_status = 'Active' order by 4 desc;

-- Q3) 
-- For each loan, calculate the expected end date — disbursement date plus tenure in months. 
-- Display loan_id, loan_type, disbursement_date, tenure_months, and expected_end_date.

# Q4)
# For each loan, calculate how many months it has been active using TIMESTAMPDIFF. 
# Then compare that to the tenure — if months active exceeds tenure, flag it as 'Overdue', otherwise 'On Track'. 
# Display loan_id, loan_type, tenure_months, months_active, and status_flag. (CASE WHEN + TIMESTAMPDIFF together)

# Q5) 
# Group transactions by year and month using DATE_FORMAT. 
# Show total transactions and total amount per month. 
# Sort chronologically. 

# Q6) 
# Calculate the age of each customer as of today using TIMESTAMPDIFF. 
# Display full name, date_of_birth, and age. Filter for customers above 40.

# Q7) 
# For each customer, show how many days it has been since they joined the bank. 
# Categorise their tenure:

# Above 2000 days → 'Long-term'
# 1000 to 2000 days → 'Mid-term'
# Below 1000 days → 'New'
