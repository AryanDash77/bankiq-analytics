-- Q1) 
-- Categorise every customer into a credit tier based on their credit score. 
-- Use these bands which are standard in Indian banking:

# 800 and above → 'Excellent'
# 700 to 799 → 'Good'
# 600 to 699 → 'Fair'
# below 600 → 'Poor'

-- Display full name, credit score, and credit tier. Sort by credit score descending.

select customer_id , concat(first_name,' ',last_name) as full_name , credit_score , 
case
		when credit_score >= 800 then 'Excellent'
		when credit_score >= 700 then 'Good'
		when credit_score >= 600 then 'Fair'
		else 'Poor'
end as credit_category from customers;

# Q2) 
-- For each account, classify the balance into:

# Above 200,000 → 'High Value'
# 50,000 to 200,000 → 'Medium Value'
# Below 50,000 → 'Low Value'

# Display account_id, account_type, balance, and balance_category.

select account_id , account_type , balance ,
case
	when balance > 200000 then 'High Value'
    when balance >= 50000 then 'Median Value'
    else 'Low Value'
end as balance_category from accounts;

# Q3)
-- For each loan payment, classify the payment behaviour:

# 'On-time' → 'Good Payer'
# 'Late' with days_overdue under 30 → 'Slightly Late'
# 'Late' with days_overdue 30 or above → 'Seriously Late'
# 'Missed' → 'Defaulter Risk'

# Display payment_id, loan_id, payment_status, days_overdue, and payment_behaviour.

select payment_id , loan_id , payment_status , days_overdue , 
case 
	when payment_status = 'On-time' then 'Good Player'
    when payment_status = 'Late' and days_overdue < 30 then 'Slightly Late'
    when payment_status = 'Late' and days_overdue >= 30 then 'Seriously Late'
    else 'Defaulter Risk'
end as payment_behaviour from loan_payments;

# Q4)
-- By city, count how many customers fall into each credit tier — Excellent, Good, Fair, Poor — all in one row per city. 



# Q5)
-- For each customer who has a loan, flag their overall risk level based on two conditions together:

# credit score below 600 AND loan status is Defaulted → 'Critical Risk'
# credit score below 600 OR loan status is Defaulted → 'High Risk'
# Everything else → 'Normal'

# Display full name, credit score, loan type, loan status, and risk flag.

# Q6) 
-- Classify each transaction by size:

# Above 30,000 → 'Large'
# 10,000 to 30,000 → 'Medium'
# Below 10,000 → 'Small'

# Then count how many transactions fall into each category per merchant_category. Display merchant_category, and counts for each size.

# Q7) 
-- For each customer, show their name, credit score, highest account balance, and a final 'Priority' flag:

# Credit score above 750 AND balance above 100,000 → 'Priority A'
# Credit score above 750 OR balance above 100,000 → 'Priority B'
# Everything else → 'Standard'