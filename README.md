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

### Dataset Preview

![Customer Churn Table Preview](customer_churn_table_preview.png)

## Customer Churn Table

| Attribute | Details |
| --- | --- |
| Table Name | `customer_churn` |
| Description | Contains churn-related information for customers who cancelled or ended their subscriptions. |
| Primary Key | `account_id` |
| Foreign Keys | `account_id` → `accounts.account_id` |
| Key Columns | `account_id`, `reason_code`, `preceding_downgrade_flag` |
| Used For | Churn reason analysis, downgrade-before-churn analysis, churn rate calculations |

---

### Dataset Preview

![Product Usage Table Preview](product_usage_table_preview.png)

## Product Usage Table

| Attribute | Details |
| --- | --- |
| Table Name | `product_usage` |
| Description | Stores feature-level product usage data for each subscription, including usage duration, frequency, beta feature usage, and errors. |
| Primary Key | No single unique key identified; analysis is performed at feature and subscription level |
| Foreign Keys | `subscription_id` → `subscriptions.subscription_id` |
| Key Columns | `subscription_id`, `feature_name`, `usage_count`, `usage_duration_seconds`, `is_beta_feature`, `error_count` |
| Used For | Feature usage analysis, churn vs usage comparison, beta feature analysis, usage segmentation |

---

### Dataset Preview

![Subscriptions Table Preview](subscriptions_table_preview.png)

## Subscriptions Table

| Attribute | Details |
| --- | --- |
| Table Name | `subscriptions` |
| Description | Contains subscription plan, revenue, upgrade, downgrade, renewal, and churn information for each customer subscription. |
| Primary Key | `subscription_id` |
| Foreign Keys | `account_id` → `accounts.account_id` |
| Key Columns | `subscription_id`, `account_id`, `plan_tier`, `mrr_amount`, `arr_amount`, `upgrade_flag`, `downgrade_flag`, `auto_renew_flag`, `churn_flag`, `end_date`, `subscription_status` |
| Used For | MRR and ARR analysis, churn by plan tier, upgrade and downgrade analysis, active vs churned customer comparison |

---

### Dataset Preview

![Support Tickets Table Preview](support_tickets_table_preview.png)

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

## Executive Overview Dashboard

![Executive Overview Dashboard](dashboard_executive_overview.png)


## Executive Overview

### Key Performance Indicators (KPIs)

-	Total Customers: 500
-	Total ARR: $136.06M
-	Total MRR: $11.34M
-	Churn Rate: 70.4%
-	Auto Renew Rate: 80.1%
-	Upgrade Rate: 10.6%

  
### Dashboard Features

-	KPI cards for customer count, ARR, MRR, churn rate, auto-renew rate, and upgrade rate
-	MRR contribution by plan tier
-	ARR distribution by country
-	Average ARR by acquisition source
-	Upgrade vs downgrade customer distribution
-	Churn percentage by plan tier
-	Interactive slicers for country, industry, and plan tier

  
### Business Questions

1.	Which subscription plan generates the highest recurring revenue?
2.	Which countries contribute the most ARR?
3.	Which acquisition channels bring the highest-value customers?
4.	Are more customers upgrading or downgrading?
5.	Which plan tiers experience the highest churn?

   
### Key Insights

-	Enterprise customers generate the majority of recurring revenue with $8.47M MRR, accounting for nearly 75% of total MRR. Pro customers contribute $2.11M, while Basic customers contribute only $0.76M.
-	The United States is the dominant revenue market, generating $79.62M ARR, which is more than 58% of total ARR. The UK and India are the next largest markets with $14.65M and $14.33M respectively.
-	Organic and partner acquisition channels bring the highest-value customers, with average ARR per customer of $28.7K and $28.4K. Event-based acquisition performs worst at $25.1K.
-	The customer base is heavily skewed toward downgrades rather than upgrades. 70.82% of customers downgraded their subscription, while only 29.18% upgraded.
-	Churn is distributed almost equally across plan tiers, but Enterprise has the highest churn share at 34.25%, followed closely by Pro at 33.19% and Basic at 32.56%. This is dangerous because the highest-value customers are also leaving at the highest rate.

  
### Business Recommendations

-	Prioritize retention programs for Enterprise customers immediately. Losing even a small number of Enterprise accounts has a much larger revenue impact than losing many Basic accounts.
-	Double down on organic and partner acquisition channels because they attract customers with stronger long-term revenue potential.
-	Investigate why downgrades are significantly higher than upgrades. That usually indicates customers are not seeing enough value to justify premium plans.
-	Create targeted save offers for Enterprise and Pro customers before renewal periods, including account reviews, onboarding support, and feature training.
-	Reduce dependence on low-performing acquisition channels such as events and ads unless their conversion quality improves.

--- 

## Product Usage & Engagement Dashboard

![Product Usage & Engagement Dashboard](dashboard_product_usage_engagement.png)


## Product Usage & Engagement

### Key Performance Indicators (KPIs)

-	Total Feature Usage: 251K
-	Average Usage Duration: 3.04K seconds
-	Average Usage Count per Customer: 50.44
-	Beta Feature Error Count: 1,416


### Dashboard Features

-	Feature usage KPI cards
-	Top 10 most-used product features
-	Most-used features by Enterprise customers
-	Beta vs non-beta feature usage split
-	Monthly product usage trend
-	Beta features with the highest error counts
-	Year slicer for 2023 and 2024 comparison

  
### Business Questions

1.	Which product features drive the highest engagement?
2.	What features are most important to Enterprise customers?
3.	How much of total usage comes from beta features?
4.	Are beta features creating product quality issues?
5.	How does overall product usage change month by month?


### Key Insights

-	Total product engagement is high, with 251K feature interactions and an average of 50.44 uses per customer.
-	Non-beta features account for 89.79% of all usage, while beta features contribute only 10.21%. Customers clearly rely on stable, proven functionality rather than experimental features.
-	The most-used features overall are feature_32, feature_15, feature_6, and feature_20, each with more than 6.5K interactions.
-	Enterprise customers show a different behavior pattern. Their most-used features are feature_10, feature_2, feature_39, and feature_6, meaning Enterprise customers depend heavily on a narrower set of advanced capabilities.
-	Product usage is relatively stable across the year, ranging from 19.5K to 22.4K interactions per month. March is the strongest month at 22.42K, while April is the weakest at 19.51K.
-	Beta features are generating substantial friction. Feature_38, feature_18, and feature_28 have the highest error counts, with up to 56 errors each.


### Business Recommendations

-	Focus future product development on the most-used features because they drive the majority of customer value and engagement.
-	Protect Enterprise customer retention by improving the advanced features they use most frequently.
-	Stop treating beta features as harmless experiments. The error-heavy beta features should either be fixed quickly or removed before they damage customer trust.
-	Use March’s higher engagement levels as a benchmark to identify what campaigns, releases, or customer activity drove stronger usage.
-	Build customer education and onboarding around the most valuable features to increase adoption and reduce downgrade risk.

---

## Support & Customer Experience Dashboard

![Support & Customer Experience Dashboard](dashboard_support_customer_experience.png)


## Support & Customer Experience

### Key Performance Indicators (KPIs)

-	Total Support Tickets: 2,000
-	Average Resolution Time: 35.86 hours
-	Average Satisfaction Score: 3.98 / 5
-	Escalated Ticket Percentage: 4.75%

  
### Dashboard Features

-	KPI cards for support ticket volume, resolution time, satisfaction score, and escalated ticket percentage
-	Top customers by support ticket volume
-	Escalated ticket rate by churn status
-	Satisfaction score by ticket priority
-	Support ticket volume by industry
-	Interactive slicers for priority, industry, escalation flag, and country

  
### Business Questions

1.	Which customers generate the highest support demand?
2.	Are churned customers more likely to escalate support issues?
3.	Does ticket priority affect customer satisfaction?
4.	Which industries create the most support workload?
5.	Is support quality contributing to churn?

   
### Key Insights

-	The business handled 2,000 support tickets with an average resolution time of 35.86 hours. That is not catastrophic, but it is slow enough to create frustration, especially for high-value accounts.
-	Churned customers have a higher escalated ticket rate of 5.09%, compared with only 3.97% for active customers. This strongly suggests that unresolved support issues are directly connected to churn.
-	Satisfaction scores are fairly consistent across ticket priorities, ranging from 3.93 to 4.02. However, even the highest score is not impressive. Customers are satisfied enough not to complain loudly, but not satisfied enough to become loyal.
-	FinTech and DevTools customers create the highest support burden, with 457 and 425 tickets respectively.
-	A small number of accounts generate a disproportionate number of tickets. Company_340, Company_256, and Company_169 each submitted 9 to 11 tickets. Those accounts should be treated as at-risk customers rather than normal support cases.

  
### Business Recommendations

-	Reduce average resolution time, especially for Enterprise and high-value customers. Waiting more than 35 hours for issue resolution is too slow in a SaaS business.
-	Create an early-warning system for customers with repeated tickets or multiple escalations. These are usually the customers most likely to churn next.
-	Prioritize support resources toward FinTech and DevTools because those industries generate the largest ticket volumes.
-	Review the accounts with unusually high ticket counts and assign dedicated customer success outreach before they leave.
-	Improve escalation handling processes. If escalated tickets continue to correlate with churn, the business is not just failing in support—it is actively creating churn.

---

## Customer Churn Analysis Dashboard

![Customer Churn Analysis Dashboard](dashboard_customer_churn_analysis.png)


## Customer Churn Analysis

### Key Performance Indicators (KPIs)

-	Total Churned Customers: 352
-	Churn Rate: 70.4%
-	Average Resolution Time for Churned Customers: 35.74 hours
-	Escalated Ticket Percentage for Churned Customers: 5.09%


### Dashboard Features

- KPI cards for churn metrics
-	Churned customers by industry
-	Top churn reasons
-	Customers who downgraded before churning
-	Monthly churn trend
-	Interactive slicers for reason code, country, year, and industry


### Business Questions

1.	Which industries have the highest number of churned customers?
2.	What are the biggest reasons customers leave?
3.	Do customers usually downgrade before churning?
4.	Which months have the highest churn?
5.	Is support performance contributing to churn?


### Key Insights

-	352 out of 500 customers churned, resulting in an extremely high churn rate of 70.4%. That is not a minor performance issue. It indicates a fundamental product, pricing, or customer success problem.
-	DevTools customers have the highest churn volume with 83 churned customers, followed by FinTech with 76 and Cybersecurity with 72.
-	The leading churn reasons are feature limitations (114 customers), budget concerns (104), poor support (104), unknown reasons (95), competitor pressure (92), and pricing issues (91).
-	Feature-related and support-related churn together account for more than 200 lost customers. That means the company is not losing customers mainly because of price—it is losing them because customers do not believe the product delivers enough value.
-	91.2% of churned customers downgraded before leaving. This is one of the strongest warning signs in the entire dashboard. Downgrading is not an isolated event; it is the final stage before churn.
-	Churn spikes sharply in February with 133 churned customers, followed by October with 79 and July with 76. February should be treated as a critical churn-risk period.


### Business Recommendations

-	Treat customer downgrades as an immediate churn warning signal. Any customer who downgrades should automatically trigger proactive outreach from customer success.
-	Improve the product areas tied to feature-related churn. Customers are telling the company directly that the product is missing critical functionality.
-	Fix the support experience because poor support is one of the top reasons customers leave.
-	Run detailed retention campaigns before February and October because those months have the highest churn risk.
-	Stop accepting ‘unknown’ churn reasons. Require structured exit feedback from every churned customer so the business can identify the real drivers of churn.

---

## Customer Deep Dive Dashboard

![Customer Deep Dive Dashboard](dashboard_customer_deep_dive.png)


## Customer Deep Dive

### Key Performance Indicators (KPIs)

-	Active Subscriptions: 4,514
-	Total Feature Usage: 251K
-	Total Support Tickets: 2,000
-	Selected Customer ARR and MRR metrics available through account slicer


### Dashboard Features

-	Dynamic customer-level ARR and MRR cards
-	Customer profile table including industry, country, plan tier, ARR, and MRR
-	Ticket history table with year, priority, resolution time, satisfaction score, and escalation flag
-	Customer product usage trend over time
-	Interactive slicers for country, industry, and account name
-	Drill-through functionality to investigate individual customers in detail


### Business Questions

1.	Which individual customers contribute the highest ARR and MRR?
2.	What patterns exist in support history for high-risk customers?
3.	How does customer product usage change over time?
4.	Which accounts have repeated escalations or poor support experiences?
5.	Which customers should be targeted first for retention efforts?


### Key Insights

-	The Customer Deep Dive page transforms the dashboard from high-level reporting into a practical retention tool. Instead of only showing that churn exists, it identifies exactly which customers are most at risk.
-	High-value accounts such as Company_108, Company_11, and Company_107 contribute some of the highest ARR and MRR values. Losing only a few of these accounts would significantly reduce revenue.
-	The ticket history table shows several cases with extremely high resolution times and low satisfaction, particularly among escalated tickets. Those customers should be considered immediate churn risks.
-	Repeated support tickets, multiple escalations, and declining product usage are clear leading indicators of future churn.
-	The ability to filter by country, industry, and account name makes it possible to identify whether churn risk is concentrated in a specific segment or a specific customer.


### Business Recommendations

-	Use this page as the main operational dashboard for customer success teams.
-	Create a churn-risk score based on support escalations, declining usage, downgrades, and low satisfaction.
-	Prioritize outreach to the highest-value customers with repeated support issues or declining engagement.
-	Build automated alerts in Power BI for customers whose usage drops sharply or whose ticket volume suddenly increases.
-	Assign dedicated account managers to high-MRR customers so that potential churn risks are addressed before renewal periods.

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

---

## Project Structure

saas-customer-churn-subscription-product-usage-analysis/
│
├── README.md
│
├── data/
│   ├── accounts.xlsx
│   ├── subscriptions.xlsx
│   ├── product_usage.xlsx
│   ├── support_tickets.xlsx
│   └── customer_churn.xlsx
│
├── sql/
│   └── saas_customer_churn_business_analysis.sql
│
├── powerbi/
│   ├── saas-customer-churn-subscription-product-usage-analysis.pbix
│
├── dashboard_images/
│   ├── dashboard_executive_overview.png
│   ├── dashboard_product_usage_engagement.png
│   ├── dashboard_support_customer_experience.png
│   ├── dashboard_customer_churn_analysis.png
│   └── dashboard_customer_deep_dive.png

---

## Repository Structure

- **data**
  
  Contains the raw and cleaned SaaS subscription, usage, support, and churn datasets.

- **sql**
  
  Includes SQL scripts for schema creation, data cleaning, KPI calculations, churn analysis, product usage analysis, support          analysis, and customer-level investigation.

- **powerbi**
  
  Contains the Power BI dashboard file used to build the complete SaaS churn analysis dashboard.

- **dashboard_images**
  
  Stores screenshots of all five dashboard pages:
  - Executive Overview
  - Product Usage & Engagement
  - Support & Customer Experience
  - Customer Churn Analysis
  - Customer Deep Dive

-  **dataset_preview**

   Contains preview screenshots of each source dataset table used in the project.

- **docs**
  
  Includes supporting project documentation such as business questions, KPI summaries, key insights, recommendations, and dashboard   explanations.
  
- **README.md**
  
  Main project documentation containing project overview, objectives, dataset details, SQL analysis, dashboard previews, business     insights, and recommendations.

---

## How to Use

1. Download the five source datasets from the `data/` folder:
   - `accounts.xlsx`
   - `subscriptions.xlsx`
   - `feature_usage.xlsx`
   - `support_tickets.xlsx`
   - `churn_events.xlsx`

2. Import the datasets into your SQL environment and create relationships using `account_id`.

3. Run the SQL queries from `sql/saas_customer_churn_analysis.sql` to calculate KPIs, analyze churn, investigate support issues, evaluate product usage, and identify customer retention risks.

4. Open `powerbi/saas_customer_churn_analysis_dashboard.pbix` in Power BI Desktop.

5. Explore the five dashboard pages:
   - Executive Overview
   - Product Usage & Engagement
   - Support & Customer Experience
   - Customer Churn Analysis
   - Customer Deep Dive

6. Use the slicers for country, industry, plan tier, year, and account name to analyze different customer segments and churn scenarios.

7. Use the Customer Deep Dive page to investigate specific accounts, review support history, monitor product usage trends, and identify high-risk customers before they churn.

---

## Conclusion

The analysis reveals that the business is facing a severe customer retention problem, with a churn rate of 70.4% and 352 out of 500 customers leaving.

The biggest drivers of churn are not pricing alone. Customers are primarily leaving because of feature limitations, poor support experience, repeated downgrades, and unresolved product issues. More than 91% of churned customers downgraded before leaving, making downgrades one of the strongest early warning signs of churn.

The dashboard also shows that Enterprise customers generate the majority of revenue, contributing $8.47M of the total $11.34M MRR. However, these high-value customers are also churning at the highest rate, creating significant revenue risk.

Support performance is another major issue. Churned customers experience higher escalation rates and long resolution times, indicating that weak customer support is directly contributing to lost customers.

This project demonstrates how combining SQL, Power BI, customer usage data, support data, and churn behavior can help identify the real reasons customers leave and support more effective retention strategies.

--

## Author

**Sarvesh Vernekar**

Aspiring Business/Data Analyst with experience in SQL, Power BI, Excel, and business storytelling. Focused on transforming raw business data into actionable insights through KPI analysis, customer behavior analysis, churn prediction, and data-driven decision-making.
