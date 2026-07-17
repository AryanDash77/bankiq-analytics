-- Q1)
-- Assign a row number to each transaction , ordered by transaction_date. 
-- Display transaction_id, account_id, amount, transaction_date, and the row number.

select transaction_id , account_id , amount , transaction_date ,
row_number() over (order by transaction_date) as row_num
from transactions;

-- Q2)
-- Rank customers by credit score. Show both RANK and DENSE_RANK side by side so you can see the difference. 
-- Display full name, credit score, and both rank columns.

