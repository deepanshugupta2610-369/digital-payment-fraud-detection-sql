CREATE TABLE digital_payment_fraud (

    transaction_id VARCHAR(20),
    user_id VARCHAR(20),

    transaction_amount NUMERIC(12,2),
    transaction_type VARCHAR(50),
    payment_mode VARCHAR(30),

    device_type VARCHAR(30),
    device_location VARCHAR(100),

    account_age_days INT,
    transaction_hour INT,

    previous_failed_attempts INT,
    avg_transaction_amount NUMERIC(12,2),

    is_international INT,
    ip_risk_score NUMERIC(5,2),

    login_attempts_last_24h INT,

    fraud_label INT
);