# Saas Customer Churn Subscription Product Usage Analysis

## Project Overview

This project analyzes a SaaS company's customer, subscription, support, and product usage data to uncover the reasons behind customer churn and identify opportunities to improve retention, engagement, and revenue.

The analysis combines SQL, Excel, and Power BI to answer critical business questions such as:

- Which industries have the highest churn rate?
- Do churned customers use the product less than active customers?
- Which plan tier generates the highest monthly recurring revenue?
- What are the most common churn reasons?
- Does support quality influence churn?
- How is churn changing over time?

### The project includes:

- Data cleaning and preparation in Excel and Power Query
- SQL analysis across multiple related tables
- A relational data model built in Power BI
- Five interactive dashboard pages focused on churn, revenue, customer behavior, support, and deep-dive customer analysis
- Business recommendations based on data-driven findings

The goal of this project is not only to visualize performance, but to demonstrate how an analyst can connect customer behavior, support experience, product usage, and revenue into a complete business story.

---

## Business Context

Customer churn is one of the biggest challenges for SaaS businesses because losing customers directly reduces recurring revenue and increases customer acquisition costs.

The company in this dataset offers different subscription plans to customers across multiple industries. Customers interact with the product in different ways, raise support tickets, upgrade or downgrade plans, and sometimes cancel their subscriptions.

However, the business does not clearly understand:

- Which customers are most likely to churn
- Whether low product usage is linked to churn
- Whether support issues increase the risk of losing customers
- Which subscription plans contribute the most revenue
- Which churn reasons should be prioritized first

Without this information, the company risks losing high-value customers, focusing on the wrong problems, and missing opportunities to improve retention.

This project was created to help the business move from reacting to churn after it happens to proactively identifying risk patterns before customers leave.

---

## Business Objectives

The primary objective of this project is to identify the factors that influence customer churn and provide insights that can improve retention, increase recurring revenue, and strengthen customer engagement.

Specific objectives include:

- Measure overall churn performance and identify which customer groups have the highest churn rate.
- Compare product usage behavior between churned and active customers.
- Analyze whether support ticket volume, escalation rate, satisfaction score, and resolution time are related to churn.
- Determine which subscription plans generate the highest Monthly Recurring Revenue (MRR) and Annual Recurring Revenue (ARR).
- Identify the most common churn reasons and track how churn changes over time.
- Analyze whether customers downgrade their plans before churning.
- Build an interactive dashboard that allows business users to explore customer-level details and specific accounts using slicers and page navigation.
- Provide clear business recommendations to reduce churn and improve customer retention.

---

### Dataset Preview

![Accounts Table Preview](accounts_table_preview.png)

## Dataset Information

## Accounts Table

| Attribute | Details |
| --- | --- |
| Table Name | `accounts` |
| Description | Contains customer account details such as company name, industry, country, and acquisition source. |
| Primary Key | `account_id` |
| Foreign Keys | Referenced by `subscriptions.account_id`, `support_tickets.account_id`, and `customer_churn.account_id` |
| Key Columns | `account_id`, `account_name`, `industry`, `country`, `referral_source` |
| Used For | Churn rate by industry, ARR by country, referral source analysis, customer-level ticket analysis |

---

## Customer Churn Table

| Attribute | Details |
| --- | --- |
| Table Name | `customer_churn` |
| Description | Contains churn-related information for customers who cancelled or ended their subscriptions. |
| Primary Key | `account_id` |
| Foreign Keys | `account_id` → `accounts.account_id` |
| Key Columns | `account_id`, `reason_code`, `preceding_downgrade_flag` |
| Used For | Churn reason analysis, downgrade-before-churn analysis, churn rate calculations |


## Product Usage Table

| Attribute | Details |
| --- | --- |
| Table Name | `product_usage` |
| Description | Stores feature-level product usage data for each subscription, including usage duration, frequency, beta feature usage, and errors. |
| Primary Key | No single unique key identified; analysis is performed at feature and subscription level |
| Foreign Keys | `subscription_id` → `subscriptions.subscription_id` |
| Key Columns | `subscription_id`, `feature_name`, `usage_count`, `usage_duration_seconds`, `is_beta_feature`, `error_count` |
| Used For | Feature usage analysis, churn vs usage comparison, beta feature analysis, usage segmentation |



## Subscriptions Table

| Attribute | Details |
| --- | --- |
| Table Name | `subscriptions` |
| Description | Contains subscription plan, revenue, upgrade, downgrade, renewal, and churn information for each customer subscription. |
| Primary Key | `subscription_id` |
| Foreign Keys | `account_id` → `accounts.account_id` |
| Key Columns | `subscription_id`, `account_id`, `plan_tier`, `mrr_amount`, `arr_amount`, `upgrade_flag`, `downgrade_flag`, `auto_renew_flag`, `churn_flag`, `end_date`, `subscription_status` |
| Used For | MRR and ARR analysis, churn by plan tier, upgrade and downgrade analysis, active vs churned customer comparison |


## Support Tickets Table

| Attribute | Details |
| --- | --- |
| Table Name | `support_tickets` |
| Description | Contains support ticket activity, including ticket priority, escalation, satisfaction, and resolution time. |
| Primary Key | `ticket_id` |
| Foreign Keys | `account_id` → `accounts.account_id` |
| Key Columns | `ticket_id`, `account_id`, `priority`, `satisfaction_score`, `resolution_time_hours`, `escalation_flag` |
| Used For | Support performance analysis, ticket volume, escalation rate, satisfaction analysis, churn vs support relationship |



---

## DAX Calculations

- Total Customers = DISTINCTCOUNT(customer_accounts[account_id])

- Total ARR = SUM(customer_subscriptions[arr_amount])

- Total MRR = SUM(customer_subscriptions[mrr_amount])

- Churn Rate = DIVIDE(DISTINCTCOUNT(customer_churn_details[account_id]),DISTINCTCOUNT(customer_accounts[account_id]))

- Auto Renew % = DIVIDE([Auto Renew Customers], COUNTROWS(customer_subscriptions), 0)

- Upgrade Rate % = DIVIDE([Upgraded Customers], COUNTROWS(customer_subscriptions), 0)

- Plan Tier Churn % = DIVIDE(CALCULATE(COUNTROWS(customer_subscriptions),customer_subscriptions[churn_flag] = TRUE()),COUNTROWS(customer_subscriptions),0)

- Upgraded Customers = CALCULATE(COUNTROWS(customer_subscriptions),customer_subscriptions[upgrade_flag] = TRUE())

- Downgraded Customers = CALCULATE(COUNTROWS(customer_subscriptions),customer_subscriptions[downgrade_flag] = TRUE())

- Total Feature Usage = SUM(product_usage_metrics[usage_count])

- Average Usage Duration = AVERAGE(product_usage_metrics[usage_duration_seconds])

- Avg Usage Count per Subscription = DIVIDE(SUM(product_usage_metrics[usage_count]),DISTINCTCOUNT(product_usage_metrics[subscription_id]),0)

- Beta Feature Error Count = CALCULATE(SUM(product_usage_metrics[error_count]),product_usage_metrics[is_beta_feature] = TRUE())

- Average Satisfaction = AVERAGE(customer_support_tickets[satisfaction_score])

- Average Resolution Time = AVERAGE(customer_support_tickets[resolution_time_hours])

- Escalated Ticket % = DIVIDE(CALCULATE(COUNTROWS(customer_support_tickets),customer_support_tickets[escalation_flag] = TRUE()),COUNTROWS(customer_support_tickets),0)

- Churned Customers = DISTINCTCOUNT(customer_churn_details[account_id])

- Avg Resolution Time (Churned) = ROUND(CALCULATE(AVERAGE(customer_support_tickets[resolution_time_hours]),customer_support_tickets[Customer Status] = "Churned"),2)

- Escalated Ticket % (Churned) = CALCULATE(AVERAGEX(customer_support_tickets, IF(customer_support_tickets[escalation_flag] =    TRUE(),1,0)),customer_support_tickets[Customer Status] = "Churned")

- Churn Count = CALCULATE(COUNT(customer_churn_details[account_id]),customer_subscriptions[churn_flag] = TRUE())

- Selected Customer ARR Display = IF(HASONEVALUE(customer_accounts[account_name]),FORMAT([Selected Customer ARR], "$#,##0"),"Select a Customer")

- Selected Customer MRR Display = IF(HASONEVALUE(customer_accounts[account_name]),FORMAT([Selected Customer MRR], "$#,##0"),"Select a Customer")

- Total Feature Usage = SUM(product_usage_metrics[usage_count])


---

## Tools Used

### Excel
- Data cleaning and preparation
- Creation of derived columns before importing data
  
### Power Query
- Data transformation and standardization inside Power BI
  
### SQL
-Data joining, filtering, aggregation, and business analysis

### Power BI
- Data modeling
- DAX measures and KPIs
- Interactive dashboards with page navigation and customer-level analysis

---

## Skills Demonstrated

- Data Cleaning
- Data Transformation
- Relational Data Modeling
- Business Analysis
- Churn Analysis
- Subscription and Revenue Analysis
- Customer Segmentation
- KPI Development
- Dashboard Design
- Interactive Navigation and Slicer Design
- Storytelling with Data
- Translating Business Problems into Data Questions
- Converting Analysis into Business Recommendations

---

## SQL Skills Demonstrated

- INNER JOIN and multi-table joins
- GROUP BY and aggregation
- CASE WHEN statements
- Common Table Expressions (CTEs)
- Churn and revenue calculations
- Conditional filtering with WHERE and HAVING
- Ranking and sorting using ORDER BY
- Building reusable business queries
- Creating customer-level and plan-level insights from multiple tables

---

## Data Workflow

1. Imported raw Excel datasets into Excel and reviewed the structure of all tables.
  
2. Cleaned and standardized the data before loading it into Power BI.
  
3. In the subscriptions table, created a new column named subscription_status immediately beside end_date using:
   =IF(end_date cell="","Active","Ended")
   This was used to clearly distinguish active and ended subscriptions before further analysis.

4. Loaded the cleaned datasets into SQL and created queries to analyze churn, revenue, support, and product usage.
  
5. Imported the cleaned tables into Power BI and built relationships between customers, subscriptions, support tickets, product usage, and churn data.
  
6. Created DAX measures for KPIs such as churn rate, MRR, ARR, escalation percentage, resolution time, usage duration, and customer-level metrics.
  
7. Designed five dashboard pages to analyze different parts of the business.
  
8. Added slicers, page navigation buttons, and a customer deep-dive page for interactive analysis.
  
9. Converted the final findings into business insights and recommendations.
