-- ============================================================
--   DIGITAL PAYMENT FRAUD DETECTION
--   SQL Business Case Study
-- ============================================================
--   Author   : Deepanshu Gupta
--   Role     : Data Analyst (Portfolio Project)
--   Tool     : PostgreSQL
--   Dataset  : 7,500 Transactions | 15 Features
--   Table    : digital_payment_fraud
-- ============================================================
--
--   BUSINESS CONTEXT
--   ----------------
--   A digital payments company processes thousands of UPI,
--   Card, NetBanking, and Wallet transactions every day.
--   Even a small percentage of fraud causes major financial
--   loss and damages customer trust.
--
--   This analysis answers 12 key business questions asked
--   by the stakeholders — using SQL aggregate functions,
--   GROUP BY, and CASE WHEN logic.
--
-- ============================================================


-- ============================================================
-- CATEGORY A — FRAUD OVERVIEW
-- ============================================================


-- ------------------------------------------------------------
-- Q1 | OVERALL FRAUD RATE & VALUE AT RISK
-- ------------------------------------------------------------
-- Business Question:
--   What percentage of our total transactions are fraudulent,
--   and what is the total monetary value at risk?
--
-- Why it matters:
--   This is the headline metric — it tells the CEO and
--   leadership how big the fraud problem is in both
--   volume (count) and financial terms (INR).
-- ------------------------------------------------------------

SELECT
    COUNT(*)                                                  AS total_transactions,

    -- Count only rows where fraud_label = 1 (fraudulent)
    SUM(CASE WHEN fraud_label = 1 THEN 1 ELSE 0 END)         AS fraud_transactions,

    -- Fraud rate as a percentage of total transactions
    ROUND(
        SUM(CASE WHEN fraud_label = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 2
    )                                                         AS fraud_rate_pct,

    -- Total INR value of all fraudulent transactions
    ROUND(
        SUM(CASE WHEN fraud_label = 1
            THEN transaction_amount ELSE 0 END)::NUMERIC, 2
    )                                                         AS value_at_risk_inr

FROM digital_payment_fraud;

-- Result  : 489 fraud out of 7,500 total = 6.52% fraud rate
-- Insight : ~₹1.18 Crore worth of transactions were fraudulent


-- ------------------------------------------------------------
-- Q2 | AVERAGE TRANSACTION AMOUNT — FRAUD VS. LEGITIMATE
-- ------------------------------------------------------------
-- Business Question:
--   Is there a noticeable difference between the average
--   transaction amount for fraud vs. legitimate transactions?
--
-- Why it matters:
--   If fraudsters target only high-value transactions,
--   we can apply stricter checks above a certain amount.
--   If not, amount alone isn't a useful fraud signal.
-- ------------------------------------------------------------

SELECT
    fraud_label,                                              -- 0 = Legitimate, 1 = Fraud
    COUNT(*)                                                  AS transaction_count,
    ROUND(AVG(transaction_amount)::NUMERIC, 2)                AS avg_amount_inr,
    ROUND(MIN(transaction_amount)::NUMERIC, 2)                AS min_amount_inr,
    ROUND(MAX(transaction_amount)::NUMERIC, 2)                AS max_amount_inr

FROM digital_payment_fraud
GROUP BY fraud_label
ORDER BY fraud_label;

-- Result  : Avg fraud txn ≈ ₹24,256 | Avg legit txn ≈ ₹24,852
-- Insight : Amounts are nearly identical — fraudsters blend in
--           with normal transactions, so amount alone is NOT
--           a reliable fraud filter.


-- ============================================================
-- CATEGORY B — PAYMENT CHANNEL & TRANSACTION TYPE RISK
-- ============================================================


-- ------------------------------------------------------------
-- Q3 | FRAUD RATE BY PAYMENT MODE
-- ------------------------------------------------------------
-- Business Question:
--   Which payment mode (UPI / Card / NetBanking / Wallet)
--   has the highest fraud rate?
--
-- Why it matters:
--   Helps the Product team identify which payment channel
--   has the weakest fraud controls so they can prioritize
--   security improvements on that channel.
-- ------------------------------------------------------------

SELECT
    payment_mode,
    COUNT(*)                                                  AS total_transactions,
    SUM(CASE WHEN fraud_label = 1 THEN 1 ELSE 0 END)         AS fraud_count,

    -- Fraud rate per payment mode
    ROUND(
        SUM(CASE WHEN fraud_label = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 2
    )                                                         AS fraud_rate_pct

FROM digital_payment_fraud
GROUP BY payment_mode
ORDER BY fraud_rate_pct DESC;

-- Result  : Card payments have the highest fraud count (135 cases)
-- Insight : Strengthen authentication (OTP / 3D Secure)
--           specifically for Card transactions


-- ------------------------------------------------------------
-- Q4 | FRAUD BY TRANSACTION TYPE
-- ------------------------------------------------------------
-- Business Question:
--   Which transaction type (Payment / Withdrawal / Transfer)
--   sees the most fraud?
--
-- Why it matters:
--   Certain transaction types are more exploitable than others.
--   Knowing which type is highest-risk helps the Risk team
--   add targeted friction (e.g., extra OTP step) to
--   only those flows, without disrupting all users.
-- ------------------------------------------------------------

SELECT
    transaction_type,
    COUNT(*)                                                  AS total_txns,
    SUM(CASE WHEN fraud_label = 1 THEN 1 ELSE 0 END)         AS fraud_count,

    -- Fraud rate per transaction type
    ROUND(
        SUM(CASE WHEN fraud_label = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 2
    )                                                         AS fraud_rate_pct

FROM digital_payment_fraud
GROUP BY transaction_type
ORDER BY fraud_rate_pct DESC;

-- Result  : Withdrawals = 170 fraud cases | Transfers = 160 cases
-- Insight : Add an extra confirmation step for Withdrawal and
--           Transfer requests above a set amount threshold


-- ============================================================
-- CATEGORY C — BEHAVIOURAL & ACCOUNT RISK SIGNALS
-- ============================================================


-- ------------------------------------------------------------
-- Q5 | PREVIOUS FAILED ATTEMPTS VS. FRAUD RATE
-- ------------------------------------------------------------
-- Business Question:
--   Do users with more previous failed attempts show
--   a higher fraud rate?
--
-- Why it matters:
--   Failed attempts signal someone might be testing stolen
--   credentials. If fraud rate spikes at a certain threshold,
--   we know exactly when to trigger a hard block or re-auth.
-- ------------------------------------------------------------

SELECT
    previous_failed_attempts,                                 -- Values: 0, 1, 2, 3, 4
    COUNT(*)                                                  AS total_txns,
    SUM(CASE WHEN fraud_label = 1 THEN 1 ELSE 0 END)         AS fraud_count,

    -- Fraud rate at each level of failed attempts
    ROUND(
        SUM(CASE WHEN fraud_label = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 2
    )                                                         AS fraud_rate_pct

FROM digital_payment_fraud
GROUP BY previous_failed_attempts
ORDER BY previous_failed_attempts;

-- Result  : Fraud rate gradually rises as failed attempts increase
-- Insight : Consider mandatory re-verification once an account
--           crosses 3 previous failed attempts


-- ------------------------------------------------------------
-- Q6 | ACCOUNT AGE VS. FRAUD RISK
-- ------------------------------------------------------------
-- Business Question:
--   Are newer accounts more prone to fraud than older ones?
--
-- Why it matters:
--   New accounts are often created by fraudsters to exploit
--   sign-up bonuses or bypass trust limits. Segmenting by
--   account age helps validate (or disprove) this assumption.
-- ------------------------------------------------------------

SELECT
    -- Bucket continuous account_age_days into readable segments
    CASE
        WHEN account_age_days < 30  THEN 'New (< 30 days)'
        WHEN account_age_days < 180 THEN 'Recent (30-180 days)'
        WHEN account_age_days < 365 THEN 'Established (180-365 days)'
        WHEN account_age_days < 730 THEN 'Mature (1-2 years)'
        ELSE                             'Loyal (> 2 years)'
    END                                                       AS account_age_segment,

    COUNT(*)                                                  AS total_txns,
    SUM(CASE WHEN fraud_label = 1 THEN 1 ELSE 0 END)         AS fraud_count,

    ROUND(
        SUM(CASE WHEN fraud_label = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 2
    )                                                         AS fraud_rate_pct

FROM digital_payment_fraud
GROUP BY account_age_segment
ORDER BY MIN(account_age_days);    -- Order by actual age, not alphabetically

-- Result  : Fraud is spread fairly evenly across all age segments
-- Insight : New accounts are NOT dramatically riskier in this
--           dataset — a useful honest finding that challenges
--           the common assumption


-- ------------------------------------------------------------
-- Q7 | LOGIN ATTEMPTS IN LAST 24H AS A FRAUD SIGNAL
-- ------------------------------------------------------------
-- Business Question:
--   Does a high number of login attempts in the last 24 hours
--   correlate with fraud? (Account takeover indicator)
--
-- Why it matters:
--   Multiple rapid login attempts often indicate a brute-force
--   or credential-stuffing attack. If fraud rate rises with
--   login attempts, this becomes a reliable real-time alert.
-- ------------------------------------------------------------

SELECT
    login_attempts_last_24h,                                  -- Values: 1 to 9
    COUNT(*)                                                  AS total_txns,
    SUM(CASE WHEN fraud_label = 1 THEN 1 ELSE 0 END)         AS fraud_count,

    ROUND(
        SUM(CASE WHEN fraud_label = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 2
    )                                                         AS fraud_rate_pct

FROM digital_payment_fraud
GROUP BY login_attempts_last_24h
ORDER BY login_attempts_last_24h;

-- Result  : Fraud rate trends slightly higher at 7+ login attempts
-- Insight : Flag accounts with unusually high login activity
--           (7+ attempts in 24h) for extra verification


-- ------------------------------------------------------------
-- Q8 | IP RISK SCORE VS. FRAUD LIKELIHOOD
-- ------------------------------------------------------------
-- Business Question:
--   Is there a relationship between IP risk score and the
--   likelihood of a transaction being fraudulent?
--
-- Why it matters:
--   IP risk scores come from IP intelligence tools that
--   flag VPNs, Tor nodes, or known fraud IPs. If high scores
--   align with fraud, this signal can be used in real-time
--   blocking rules.
-- ------------------------------------------------------------

SELECT
    -- Group the continuous 0.0-1.0 score into 5 risk buckets
    CASE
        WHEN ip_risk_score < 0.2 THEN 'Very Low (0.0-0.2)'
        WHEN ip_risk_score < 0.4 THEN 'Low (0.2-0.4)'
        WHEN ip_risk_score < 0.6 THEN 'Medium (0.4-0.6)'
        WHEN ip_risk_score < 0.8 THEN 'High (0.6-0.8)'
        ELSE                          'Very High (0.8-1.0)'
    END                                                       AS ip_risk_bucket,

    COUNT(*)                                                  AS total_txns,
    SUM(CASE WHEN fraud_label = 1 THEN 1 ELSE 0 END)         AS fraud_count,

    ROUND(
        SUM(CASE WHEN fraud_label = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 2
    )                                                         AS fraud_rate_pct

FROM digital_payment_fraud
GROUP BY ip_risk_bucket
ORDER BY MIN(ip_risk_score);

-- Result  : No sharp spike in fraud rate with IP risk score alone
-- Insight : ip_risk_score works better as one signal among many,
--           not as a standalone fraud filter


-- ============================================================
-- CATEGORY D — GEOGRAPHIC & DEVICE ANALYSIS
-- ============================================================


-- ------------------------------------------------------------
-- Q9 | FRAUD BY CITY
-- ------------------------------------------------------------
-- Business Question:
--   Which city has the highest number of fraudulent
--   transactions?
--
-- Why it matters:
--   City-level fraud concentration helps the Operations team
--   set location-based monitoring thresholds and alerts.
-- ------------------------------------------------------------

SELECT
    device_location,                                          -- Cities: Delhi, Mumbai, Bangalore, Chennai, Hyderabad
    COUNT(*)                                                  AS total_txns,
    SUM(CASE WHEN fraud_label = 1 THEN 1 ELSE 0 END)         AS fraud_count,

    ROUND(
        SUM(CASE WHEN fraud_label = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 2
    )                                                         AS fraud_rate_pct

FROM digital_payment_fraud
GROUP BY device_location
ORDER BY fraud_count DESC;                                    -- Sort by volume, not just rate

-- Result  : Hyderabad = 115 fraud cases (highest) | Delhi = 83 (lowest)
-- Insight : Start city-level monitoring with Hyderabad and Mumbai


-- ------------------------------------------------------------
-- Q10 | FRAUD BY DEVICE TYPE
-- ------------------------------------------------------------
-- Business Question:
--   Which device type (Web / iOS / Android) is most
--   associated with fraudulent transactions?
--
-- Why it matters:
--   Device-level patterns help the Security team decide
--   whether to apply extra checks on a specific platform —
--   e.g., stricter app-level fraud detection on Android.
-- ------------------------------------------------------------

SELECT
    device_type,                                              -- Values: Web, iOS, Android
    COUNT(*)                                                  AS total_txns,
    SUM(CASE WHEN fraud_label = 1 THEN 1 ELSE 0 END)         AS fraud_count,

    ROUND(
        SUM(CASE WHEN fraud_label = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 2
    )                                                         AS fraud_rate_pct

FROM digital_payment_fraud
GROUP BY device_type
ORDER BY fraud_rate_pct DESC;

-- Result  : Android has a slightly higher fraud rate vs iOS and Web
-- Insight : Consider stricter in-app fraud detection for Android


-- ------------------------------------------------------------
-- Q11 | INTERNATIONAL VS. DOMESTIC FRAUD
-- ------------------------------------------------------------
-- Business Question:
--   Are international transactions more prone to fraud
--   compared to domestic ones?
--
-- Why it matters:
--   A common assumption is that cross-border transactions
--   are riskier. This query either validates or challenges
--   that assumption using actual data.
-- ------------------------------------------------------------

SELECT
    -- Convert binary flag into readable labels
    CASE
        WHEN is_international = 1 THEN 'International'
        ELSE                           'Domestic'
    END                                                       AS transaction_scope,

    COUNT(*)                                                  AS total_txns,
    SUM(CASE WHEN fraud_label = 1 THEN 1 ELSE 0 END)         AS fraud_count,

    ROUND(
        SUM(CASE WHEN fraud_label = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 2
    )                                                         AS fraud_rate_pct

FROM digital_payment_fraud
GROUP BY transaction_scope;

-- Result  : Domestic = 6.64% fraud rate | International = 5.43%
-- Insight : Domestic transactions are SLIGHTLY riskier here —
--           a counter-intuitive finding.
--           Don't deprioritize domestic monitoring.


-- ============================================================
-- CATEGORY E — TIME-BASED PATTERNS
-- ============================================================


-- ------------------------------------------------------------
-- Q12 | FRAUD BY HOUR OF DAY
-- ------------------------------------------------------------
-- Business Question:
--   At what hours of the day do most fraud transactions
--   happen? Is there a 'fraud window'?
--
-- Why it matters:
--   If fraud is concentrated at specific hours, the Operations
--   team can staff up monitoring and lower auto-approval
--   thresholds during those windows — without impacting
--   all users all day.
-- ------------------------------------------------------------

SELECT
    transaction_hour,                                         -- 0-23 in 24-hour format
    COUNT(*)                                                  AS total_txns,
    SUM(CASE WHEN fraud_label = 1 THEN 1 ELSE 0 END)         AS fraud_count,

    ROUND(
        SUM(CASE WHEN fraud_label = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 2
    )                                                         AS fraud_rate_pct

FROM digital_payment_fraud
GROUP BY transaction_hour
ORDER BY fraud_count DESC
LIMIT 5;                                                      -- Show only top 5 fraud-peak hours

-- Result  : Peak hours — 19:00 (7 PM), 14:00 (2 PM), 06:00 (6 AM)
-- Insight : Increase monitoring intensity during these hours.
--           Remove LIMIT to see the full 24-hour breakdown.


-- ============================================================
-- END OF CASE STUDY
-- ============================================================
--
--   SQL CONCEPTS USED IN THIS FILE
--   --------------------------------
--   1. COUNT, SUM, AVG, ROUND, MIN, MAX  — Aggregate functions
--   2. CASE WHEN ... THEN ... ELSE ... END — Conditional logic
--   3. GROUP BY                           — Segment-level analysis
--   4. ORDER BY + LIMIT                   — Top-N ranking
--   5. ::NUMERIC type casting             — Clean decimal output
--
-- ============================================================