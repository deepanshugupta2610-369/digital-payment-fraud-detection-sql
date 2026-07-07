/*==============================================================
 PHASE : 2 - Exploratory Data Analysis
 PURPOSE:
 Understand transaction behaviour before identifying
 fraud patterns.
==============================================================*/


/*--------------------------------------------------------------
Measure the proportion of fraudulent transactions.
--------------------------------------------------------------*/

SELECT

fraud_label,

COUNT(*) AS total_transactions

FROM digital_payment_fraud

GROUP BY fraud_label;


/*--------------------------------------------------------------
Calculate overall fraud percentage.
--------------------------------------------------------------*/

SELECT

ROUND(

100.0*SUM(fraud_label)/COUNT(*),

2

) AS fraud_percentage

FROM digital_payment_fraud;



/*--------------------------------------------------------------
Understand transaction value distribution.
--------------------------------------------------------------*/

SELECT

MIN(transaction_amount) AS minimum_amount,

MAX(transaction_amount) AS maximum_amount,

ROUND(AVG(transaction_amount),2) AS average_amount

FROM digital_payment_fraud;


/*--------------------------------------------------------------
Identify the most frequently used transaction types.
--------------------------------------------------------------*/

SELECT

transaction_type,

COUNT(*) AS total_transactions

FROM digital_payment_fraud

GROUP BY transaction_type

ORDER BY total_transactions DESC;



/*--------------------------------------------------------------
Understand customer payment preferences.
--------------------------------------------------------------*/

SELECT

payment_mode,

COUNT(*) AS total_transactions

FROM digital_payment_fraud

GROUP BY payment_mode

ORDER BY total_transactions DESC;



/*--------------------------------------------------------------
Identify commonly used customer devices.
--------------------------------------------------------------*/

SELECT

device_type,

COUNT(*) AS total_transactions

FROM digital_payment_fraud

GROUP BY device_type

ORDER BY total_transactions DESC;



/*--------------------------------------------------------------
Identify peak transaction hours.
--------------------------------------------------------------*/

SELECT

transaction_hour,

COUNT(*) AS total_transactions

FROM digital_payment_fraud

GROUP BY transaction_hour

ORDER BY transaction_hour;
