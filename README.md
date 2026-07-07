# 💳 Digital Payment Fraud Detection using SQL

> **A SQL Business Case Study built using PostgreSQL to analyze digital payment transactions, identify fraud patterns, and generate actionable business recommendations.**

---

## 📖 Project Story

Every day, millions of digital payment transactions take place through **UPI, Cards, Wallets, and Net Banking**. While digital payments have made transactions faster and more convenient, they have also increased the risk of fraudulent activities.

Imagine being a Data Analyst in a financial services company.

The Risk and Operations teams approach you with a simple question:

> **"Can we use our transaction data to better understand fraud and make smarter business decisions?"**

This project is my attempt to solve that business problem using **SQL**.

Instead of only writing SQL queries, I approached this project from a business perspective by asking stakeholder-driven questions, analyzing the data, and translating the findings into practical recommendations.

---

# 🎯 Business Objective

The objective of this case study is to:

- 🔍 Explore digital payment transaction data
- 📊 Measure the overall fraud landscape
- 💳 Identify risky payment channels
- 👤 Analyze customer behaviour patterns
- 🌍 Detect geographic and device-level fraud trends
- ⏰ Discover time-based fraud patterns
- 💼 Provide business recommendations backed by SQL analysis

---

# 📂 Repository Structure

```text
digital-payment-fraud-detection-sql
│
├── Dataset
│   └── digital_payment_fraud_dataset.xlsx
│
├── sql-scripts
│   ├── 01_create_database_and_table.sql
│   ├── 02_data_import_and_validation.sql
│   ├── 03_exploratory_data_analysis.sql
│   └── 04_business_analysis.sql
│
├── Documentation
│   └── Digital_Payment_Fraud_Detection_SQL_Case_Study.pdf
│
└── README.md
```

---

# 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| PostgreSQL | Database Management |
| SQL | Data Analysis |
| pgAdmin 4 | Query Execution |
| Microsoft Excel | Dataset |
| GitHub | Project Documentation |

---

# 📊 Dataset Overview

| Metric | Value |
|--------|------:|
| Total Transactions | 7,500 |
| Features | 15 |
| Fraudulent Transactions | 489 |
| Fraud Rate | 6.52% |
| International Transactions | 755 |

The dataset contains customer transaction details such as:

- Transaction Amount
- Payment Mode
- Transaction Type
- Device Type
- Device Location
- Account Age
- Login Attempts
- IP Risk Score
- International Transaction Flag
- Fraud Label (Target Variable)

---

# 🔄 Project Workflow

```text
Business Problem
        │
        ▼
Understanding the Dataset
        │
        ▼
Data Validation & Quality Checks
        │
        ▼
Exploratory Data Analysis
        │
        ▼
Stakeholder Business Questions
        │
        ▼
SQL Analysis
        │
        ▼
Business Insights
        │
        ▼
Business Recommendations
```

---

# 📌 Data Validation

Before starting the analysis, I validated the dataset by checking:

- ✅ Total records
- ✅ Missing values
- ✅ Duplicate transactions
- ✅ Fraud label consistency
- ✅ Categorical values
- ✅ Numeric ranges

This ensured that the analysis was performed on clean and reliable data.

---

# 📈 Exploratory Data Analysis

The exploratory analysis focused on understanding the overall transaction landscape before diving into fraud analysis.

Some of the key areas explored include:

- Overall fraud distribution
- Transaction amount analysis
- Payment mode distribution
- Transaction type distribution
- Device usage
- Transaction activity by hour

---

# 💼 Business Questions Solved

Instead of writing random SQL queries, this project answers real business questions that a stakeholder might ask.

### Executive Overview

- What percentage of transactions are fraudulent?
- What is the total financial value at risk?

### Payment & Transaction Risk

- Which payment mode has the highest fraud rate?
- Which transaction type experiences the most fraud?

### Customer Behaviour

- Do previous failed attempts indicate higher fraud?
- Are newer accounts more vulnerable?
- Does login activity correlate with fraud?

### Risk Signals

- Does IP Risk Score influence fraud?
- Are international transactions riskier?

### Geographic Analysis

- Which city records the highest fraud volume?
- Which device type is associated with more fraud?

### Time Analysis

- At what time of the day does fraud peak?

---

# 📊 Key Business Insights

After analyzing **7,500 digital payment transactions**, several actionable fraud patterns emerged.

### 💰 Overall Fraud Exposure

- 🚨 Identified **489 fraudulent transactions** out of **7,500**, resulting in an overall **fraud rate of 6.52%**.
- 💸 The estimated **financial value at risk was approximately ₹1.18 Crore**, highlighting the importance of proactive fraud monitoring.

---

### 💳 Payment Channel Risk

- Card payments recorded the **highest fraud volume with 135 fraudulent transactions**, making them the riskiest payment channel in the dataset.
- This suggests that strengthening authentication mechanisms such as **OTP validation or 3D Secure** could significantly reduce fraud exposure.

---

### 💸 Transaction Type Analysis

- **Withdrawal transactions accounted for the highest fraud volume (170 cases)**, closely followed by **Transfers (160 cases)**.
- These transaction types should be prioritized for additional verification and risk scoring.

---

### 🔐 Customer Behaviour Signals

- Fraud rates consistently increased as the number of **previous failed transaction attempts** increased.
- Accounts with multiple failed attempts represent a strong behavioural risk signal and should trigger additional verification.

---

### 👤 Login Activity

- Customers with **higher login attempts within the previous 24 hours** showed a higher likelihood of fraudulent activity.
- Introducing adaptive authentication after repeated login attempts could help reduce fraud.

---

### 🌍 Geographic Insights

- **Hyderabad recorded the highest fraud volume (115 cases)** among all available locations.
- **Delhi reported the lowest fraud volume (83 cases)**.
- Region-specific monitoring rules can help improve fraud detection efficiency.

---

### 📱 Device Analysis

- Android devices showed a **slightly higher fraud rate** compared with Web and iOS devices.
- Device type alone is not sufficient to identify fraud but becomes valuable when combined with other behavioural indicators.

---

### 🌐 Domestic vs International Transactions

- Contrary to a common assumption, **Domestic transactions recorded a slightly higher fraud rate (6.64%) than International transactions (5.43%)**.
- This finding demonstrates that international transactions should not automatically receive higher risk priority.

---

### ⏰ Time-Based Fraud Patterns

- Fraud activity peaked during:
  - 🕖 **7:00 PM**
  - 🕑 **2:00 PM**
  - 🕕 **6:00 AM**
- Increasing fraud monitoring during these high-risk windows could improve detection rates while optimizing operational resources.

---

### 💵 Transaction Amount Analysis

- The **average fraudulent transaction value (₹24,256)** was very close to the **average legitimate transaction value (₹24,852)**.
- This indicates that **transaction amount alone is not an effective fraud indicator**, reinforcing the need to combine multiple behavioural and contextual signals.

---

# 📋 Business Recommendations

Based on the analysis, the following recommendations were made:

- 🔐 Strengthen authentication for Card payments.
- 💳 Add additional verification for high-risk Withdrawal and Transfer transactions.
- 👤 Trigger re-verification after multiple failed login attempts.
- ⏰ Increase fraud monitoring during peak fraud hours.
- 🌍 Introduce city-level fraud monitoring.
- 📱 Combine multiple behavioural signals instead of relying on a single indicator.

---

# 🧠 SQL Concepts Demonstrated

Throughout this project, I used:

- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()
- ROUND()
- GROUP BY
- ORDER BY
- LIMIT
- CASE WHEN
- Type Casting (::NUMERIC)

These SQL concepts were applied to answer business questions in a structured and interview-friendly manner.

---

# 📁 Project Documentation

A detailed business case study explaining:

- Business Context
- Dataset Overview
- Stakeholder Questions
- SQL Queries
- Business Insights
- Recommendations

is available in the **Documentation** folder.

---

# 🎯 What I Learned

Working on this project helped me strengthen my understanding of:

- Writing clean and readable SQL
- Business-oriented data analysis
- Fraud analytics fundamentals
- Stakeholder thinking
- Translating SQL outputs into business insights
- Presenting technical analysis in a simple and structured way

---

# 🚀 About Me

Hi, I'm **Deepanshu Gupta** 👋

I'm an aspiring **Data Analyst** with a strong interest in solving real-world business problems using **SQL, Excel, Power BI, and Python**.

I'm currently building end-to-end analytics projects to strengthen my business understanding and analytical thinking while preparing for Data Analyst opportunities.

If you have any feedback, suggestions, or would like to connect, feel free to reach out!

---

## ⭐ If you found this project useful

If you liked this project or found it helpful, consider giving it a ⭐ on GitHub.

It motivates me to continue building more real-world business analytics projects.
