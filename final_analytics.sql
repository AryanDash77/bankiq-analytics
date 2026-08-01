# Q1)
# Customer Risk Scorecard

# For each customer who has a loan, build a complete risk scorecard showing:
# Full name, city, credit score, credit tier (CASE WHEN)
# Loan type, loan status
# Total number of payments made
# Number of missed payments
# A final risk_grade:
# Missed payments > 3 AND credit score < 600 → 'Grade D'
# Missed payments > 3 OR credit score < 600 → 'Grade C'
# Missed payments > 0 → 'Grade B'
# Else → 'Grade A'

with payment_counts as (
select loan_id, count(*) as total_payments,
count(case when payment_status = 'Missed' then 1 end) as missed_payments
from loan_payments group by loan_id
)  

select concat(c.first_name, ' ', c.last_name) as full_name , c.city , c.credit_score,
pc.loan_id , l.loan_type , l.loan_status , pc.total_payments , pc.missed_payments,
case 
	when pc.missed_payments > 3 and c.credit_score < 600 then 'Grade D'
    when pc.missed_payments > 3 or c.credit_score < 600 then 'Grade C'
    when pc.missed_payments > 0 then 'Grade B'
    else 'Grade A'
end as risk_grade from customers c join loans l on c.customer_id = l.customer_id
join payment_counts pc on l.loan_id = pc.loan_id;

-- Q2)
-- Top 3 Customers per City by Balance
-- For each city, find the top 3 customers ranked by their total account balance. 
-- Display full name, city, total balance, and their rank within the city.

with customer_balance as (
select c.customer_id , concat(c.first_name, ' ', c.last_name) as full_name 
, c.city , sum(a.balance) as total_balance 
from customers c join accounts a on c.customer_id = a.customer_id
group by c.customer_id , full_name , c.city
) , 

ranked as (
select customer_id , full_name , city , total_balance , 
rank() over (partition by city order by total_balance desc) as rnk
from customer_balance
)

select customer_id , full_name , city , total_balance , rnk 
from ranked where rnk <= 3;

# Q3) 
# Monthly Loan Disbursement Trend
# Show month-by-month loan disbursement trends. For each month display:

# Year-month (formatted as 'YYYY-MM')
# Number of loans disbursed
# Total amount disbursed
# Running total of amount disbursed up to that month
# Month-over-month change in total disbursed amount using LAG

with monthly_agg as (
select date_format(disbursement_date , '%Y-%m') as ym ,
count(loan_id) as lc , sum(principal_amount) as amt_dis 
from loans group by ym 
)

select ym , lc , amt_dis ,
sum(amt_dis) over (order by ym) as running_total,
lag(amt_dis) over (order by ym) as prev_month_amt ,
amt_dis - lag(amt_dis) over (order by ym) as mom_change
from monthly_agg;

# Q4) 
# Branch Performance Summary
# For each city produce a full performance report showing:

# Total customers
# Total active accounts
# Total balance across active accounts
# Average credit score
# Total loans disbursed
# Total defaulted loans
# Default rate as a percentage — (defaulted / total loans * 100) rounded to 2 places
# City risk classification:
# Default rate above 30% → 'High Risk City'
# Default rate 15% to 30% → 'Moderate Risk City'
# Below 15% → 'Low Risk City'

