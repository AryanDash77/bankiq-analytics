# ─────────────────────────────────────────────────────────
# BANKIQ ANALYTICS — Task 2: Data Loading
# Inserts realistic data into all 5 tables
# Libraries: mysql-connector-python, faker
# ─────────────────────────────────────────────────────────

import mysql.connector
import random
from faker import Faker
from datetime import date, timedelta

fake = Faker('en_IN')  
random.seed(42)        

# ── DATABASE CONNECTION ───────────────────────────────────
conn = mysql.connector.connect(
    host     = "localhost",
    user     = "root",         
    password = "pass321", 
    database = "bankiq_analytics"
)
cursor = conn.cursor()
print("Connected to bankiq_analytics")

# ── HELPER: random date between two dates ─────────────────
def random_date(start, end):
    return start + timedelta(days=random.randint(0, (end - start).days))

# ─────────────────────────────────────────────────────────
# TABLE 1: CUSTOMERS (100 rows)
# ─────────────────────────────────────────────────────────
print("Inserting customers...")

cities  = ['Mumbai', 'Delhi', 'Bangalore', 'Chennai', 'Hyderabad',
           'Pune', 'Kolkata', 'Ahmedabad', 'Jaipur', 'Bhubaneswar']
states  = ['Maharashtra', 'Delhi', 'Karnataka', 'Tamil Nadu', 'Telangana',
           'Maharashtra', 'West Bengal', 'Gujarat', 'Rajasthan', 'Odisha']

customers = []
for i in range(100):
    city_idx = random.randint(0, 9)
    dob      = random_date(date(1965, 1, 1), date(2000, 12, 31))
    joining  = random_date(date(2018, 1, 1), date(2024, 6, 30))
    score    = random.randint(300, 900)

    customers.append((
        fake.first_name(),
        fake.last_name(),
        dob,
        cities[city_idx],
        states[city_idx],
        fake.unique.email(),
        fake.phone_number()[:15],
        joining,
        score
    ))

cursor.executemany("""
    INSERT INTO customers
    (first_name, last_name, date_of_birth, city, state,
     email, phone, joining_date, credit_score)
    VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)
""", customers)
print(f"  → {cursor.rowcount} customers inserted")

# ─────────────────────────────────────────────────────────
# TABLE 2: ACCOUNTS (150 rows — some customers have 2)
# ─────────────────────────────────────────────────────────
print("Inserting accounts...")

account_types = ['Savings', 'Checking', 'Fixed Deposit']
statuses      = ['Active', 'Active', 'Active', 'Inactive', 'Closed']  # weighted

accounts = []
for cust_id in range(1, 101):
    num_accounts = random.choices([1, 2], weights=[60, 40])[0]
    for _ in range(num_accounts):
        accounts.append((
            cust_id,
            random.choice(account_types),
            round(random.uniform(500, 500000), 2),
            random_date(date(2018, 1, 1), date(2024, 6, 30)),
            random.choice(statuses)
        ))

cursor.executemany("""
    INSERT INTO accounts
    (customer_id, account_type, balance, opened_date, status)
    VALUES (%s,%s,%s,%s,%s)
""", accounts)
print(f"  → {cursor.rowcount} accounts inserted")

# ─────────────────────────────────────────────────────────
# TABLE 3: TRANSACTIONS (1000 rows)
# ─────────────────────────────────────────────────────────
print("Inserting transactions...")

merchant_cats = ['Groceries', 'Salary', 'Utilities', 'EMI Payment',
                 'Travel', 'Healthcare', 'Entertainment', 'Transfer',
                 'Investment', 'Insurance']
descriptions  = ['Online transfer', 'ATM withdrawal', 'POS payment',
                 'NEFT credit', 'UPI debit', 'Direct deposit',
                 'Auto debit', 'IMPS transfer']

# get all valid account IDs
cursor.execute("SELECT account_id FROM accounts")
account_ids = [row[0] for row in cursor.fetchall()]

transactions = []
for _ in range(1000):
    transactions.append((
        random.choice(account_ids),
        random.choice(['Credit', 'Debit']),
        round(random.uniform(100, 50000), 2),
        random_date(date(2022, 1, 1), date(2024, 12, 31)),
        random.choice(descriptions),
        random.choice(merchant_cats)
    ))

cursor.executemany("""
    INSERT INTO transactions
    (account_id, transaction_type, amount,
     transaction_date, description, merchant_category)
    VALUES (%s,%s,%s,%s,%s,%s)
""", transactions)
print(f"  → {cursor.rowcount} transactions inserted")

# ─────────────────────────────────────────────────────────
# TABLE 4: LOANS (80 rows)
# ─────────────────────────────────────────────────────────
print("Inserting loans...")

loan_types = ['Personal', 'Home', 'Auto', 'Education']
loan_statuses = ['Active', 'Active', 'Active', 'Closed', 'Defaulted']

# interest rates by loan type
rate_map = {
    'Personal' : (10.5, 18.0),
    'Home'     : (7.5,  9.5),
    'Auto'     : (8.5,  12.0),
    'Education': (9.0,  13.5)
}
# principal ranges by loan type
principal_map = {
    'Personal' : (50000,   500000),
    'Home'     : (1000000, 8000000),
    'Auto'     : (200000,  1500000),
    'Education': (100000,  1000000)
}

loans = []
# pick 80 random customers to have loans
loan_customers = random.sample(range(1, 101), 80)

for cust_id in loan_customers:
    ltype     = random.choice(loan_types)
    principal = round(random.uniform(*principal_map[ltype]), 2)
    rate      = round(random.uniform(*rate_map[ltype]), 2)
    tenure    = random.choice([12, 24, 36, 48, 60, 84, 120, 180, 240])
    disburse  = random_date(date(2019, 1, 1), date(2023, 12, 31))
    status    = random.choice(loan_statuses)

    # EMI formula: P * r * (1+r)^n / ((1+r)^n - 1)
    r   = (rate / 100) / 12
    emi = round(principal * r * (1 + r)**tenure / ((1 + r)**tenure - 1), 2)

    loans.append((
        cust_id, ltype, principal, rate,
        tenure, disburse, status, emi
    ))

cursor.executemany("""
    INSERT INTO loans
    (customer_id, loan_type, principal_amount, interest_rate,
     tenure_months, disbursement_date, status, emi_amount)
    VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
""", loans)
print(f"  → {cursor.rowcount} loans inserted")

# ─────────────────────────────────────────────────────────
# TABLE 5: LOAN PAYMENTS (400 rows)
# ─────────────────────────────────────────────────────────
print("Inserting loan payments...")

cursor.execute("SELECT loan_id, emi_amount, disbursement_date, status FROM loans")
loan_rows = cursor.fetchall()

payment_statuses = ['On-time', 'On-time', 'On-time', 'Late', 'Missed']  # weighted

loan_payments = []
for (loan_id, emi, disburse_date, lstatus) in loan_rows:
    # defaulted loans get more missed payments
    if lstatus == 'Defaulted':
        pay_pool = ['On-time', 'Late', 'Late', 'Missed', 'Missed']
    else:
        pay_pool = payment_statuses

    num_payments = random.randint(3, 8)
    for i in range(num_payments):
        pay_date = disburse_date + timedelta(days=30 * (i + 1))
        pstatus  = random.choice(pay_pool)
        overdue  = random.randint(5, 45) if pstatus == 'Late' else \
                   random.randint(46, 120) if pstatus == 'Missed' else 0

        loan_payments.append((
            loan_id,
            pay_date,
            emi,
            pstatus,
            overdue
        ))

cursor.executemany("""
    INSERT INTO loan_payments
    (loan_id, payment_date, amount_paid, payment_status, days_overdue)
    VALUES (%s,%s,%s,%s,%s)
""", loan_payments)
print(f"  → {cursor.rowcount} loan payments inserted")

# ── COMMIT & CLOSE ────────────────────────────────────────
conn.commit()
cursor.close()
conn.close()
print("\n✅ All data loaded successfully into bankiq_analytics!")