-- ─────────────────────────────────────────
-- BANKIQ ANALYTICS — DATABASE SETUP
-- Task 1: DDL — Schema Creation
-- ─────────────────────────────────────────

CREATE DATABASE IF NOT EXISTS bankiq_analytics;
USE bankiq_analytics;

-- ── TABLE 1: CUSTOMERS ──────────────────
CREATE TABLE customers (
    customer_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    date_of_birth DATE         NOT NULL,
    city          VARCHAR(50),
    state         VARCHAR(50),
    email         VARCHAR(100) NOT NULL UNIQUE,
    phone         VARCHAR(15),
    joining_date  DATE         NOT NULL,
    credit_score  INT          CHECK (credit_score BETWEEN 300 AND 900)
);

-- ── TABLE 2: ACCOUNTS ───────────────────
CREATE TABLE accounts (
    account_id   INT AUTO_INCREMENT PRIMARY KEY,
    customer_id  INT NOT NULL,
    account_type ENUM('Savings', 'Checking', 'Fixed Deposit') NOT NULL,
    balance      DECIMAL(12,2) DEFAULT 0.00,
    opened_date  DATE          NOT NULL,
    status       ENUM('Active', 'Inactive', 'Closed') DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ── TABLE 3: TRANSACTIONS ───────────────
CREATE TABLE transactions (
    transaction_id   INT AUTO_INCREMENT PRIMARY KEY,
    account_id       INT  NOT NULL,
    transaction_type ENUM('Credit', 'Debit') NOT NULL,
    amount           DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    transaction_date DATE          NOT NULL,
    description      VARCHAR(100),
    merchant_category VARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- ── TABLE 4: LOANS ──────────────────────
CREATE TABLE loans (
    loan_id           INT AUTO_INCREMENT PRIMARY KEY,
    customer_id       INT  NOT NULL,
    loan_type         ENUM('Personal', 'Home', 'Auto', 'Education') NOT NULL,
    principal_amount  DECIMAL(12,2) NOT NULL,
    interest_rate     DECIMAL(5,2)  NOT NULL,
    tenure_months     INT           NOT NULL,
    disbursement_date DATE          NOT NULL,
    status            ENUM('Active', 'Closed', 'Defaulted') DEFAULT 'Active',
    emi_amount        DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ── TABLE 5: LOAN PAYMENTS ──────────────
CREATE TABLE loan_payments (
    payment_id     INT AUTO_INCREMENT PRIMARY KEY,
    loan_id        INT  NOT NULL,
    payment_date   DATE NOT NULL,
    amount_paid    DECIMAL(10,2) NOT NULL,
    payment_status ENUM('On-time', 'Late', 'Missed') NOT NULL,
    days_overdue   INT DEFAULT 0,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);



SELECT 'customers'    AS table_name, COUNT(*) AS row_count FROM customers    UNION ALL
SELECT 'accounts'                  , COUNT(*)         FROM accounts                UNION ALL
SELECT 'transactions'              , COUNT(*)         FROM transactions             UNION ALL
SELECT 'loans'                     , COUNT(*)         FROM loans                   UNION ALL
SELECT 'loan_payments'             , COUNT(*)         FROM loan_payments;


ALTER TABLE accounts RENAME COLUMN status TO account_status;

ALTER TABLE loans RENAME COLUMN status to loan_status;