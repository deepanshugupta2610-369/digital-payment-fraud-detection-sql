/*==============================================================
 PROJECT : Digital Payment Fraud Detection Analysis
 PHASE   : 1 - Data Validation & Data Quality Assessment
 PURPOSE : Ensure the dataset is complete, reliable and ready
           for business analysis.
==============================================================*/

/*--------------------------------------------------------------
Check whether all records have been imported successfully.
--------------------------------------------------------------*/

SELECT COUNT(*) AS total_transactions
FROM digital_payment_fraud;



/*--------------------------------------------------------------
Missing values may impact fraud analysis and business decisions.
--------------------------------------------------------------*/

SELECT

COUNT(*)-COUNT(transaction_id) AS transaction_id,

COUNT(*)-COUNT(user_id) AS user_id,

COUNT(*)-COUNT(transaction_amount) AS transaction_amount,

COUNT(*)-COUNT(transaction_type) AS transaction_type,

COUNT(*)-COUNT(payment_mode) AS payment_mode,

COUNT(*)-COUNT(device_type) AS device_type,

COUNT(*)-COUNT(device_location) AS device_location,

COUNT(*)-COUNT(account_age_days) AS account_age_days,

COUNT(*)-COUNT(transaction_hour) AS transaction_hour,

COUNT(*)-COUNT(previous_failed_attempts) AS previous_failed_attempts,

COUNT(*)-COUNT(avg_transaction_amount) AS avg_transaction_amount,

COUNT(*)-COUNT(is_international) AS is_international,

COUNT(*)-COUNT(ip_risk_score) AS ip_risk_score,

COUNT(*)-COUNT(login_attempts_last_24h) AS login_attempts_last_24h,

COUNT(*)-COUNT(fraud_label) AS fraud_label

FROM digital_payment_fraud;




/*--------------------------------------------------------------
Each transaction should have a unique Transaction ID.
--------------------------------------------------------------*/

SELECT

transaction_id,

COUNT(*) AS duplicate_count

FROM digital_payment_fraud

GROUP BY transaction_id

HAVING COUNT(*)>1;



/*--------------------------------------------------------------
Fraud flag should contain only valid values (0 or 1).
--------------------------------------------------------------*/

SELECT DISTINCT fraud_label

FROM digital_payment_fraud;



/*--------------------------------------------------------------
Review categorical values used in business analysis.
--------------------------------------------------------------*/

SELECT DISTINCT transaction_type
FROM digital_payment_fraud;

SELECT DISTINCT payment_mode
FROM digital_payment_fraud;

SELECT DISTINCT device_type
FROM digital_payment_fraud;


/*--------------------------------------------------------------
Identify unrealistic values before analysis.
--------------------------------------------------------------*/

SELECT

MIN(transaction_amount) AS minimum_amount,
MAX(transaction_amount) AS maximum_amount,

MIN(account_age_days) AS minimum_account_age,
MAX(account_age_days) AS maximum_account_age,

MIN(transaction_hour) AS earliest_hour,
MAX(transaction_hour) AS latest_hour,

MIN(ip_risk_score) AS minimum_ip_risk,
MAX(ip_risk_score) AS maximum_ip_risk

FROM digital_payment_fraud;



