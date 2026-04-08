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

- Imported raw Excel datasets into Excel and reviewed the structure of all tables.
  
- Cleaned and standardized the data before loading it into Power BI.
  
- In the subscriptions table, created a new column named subscription_status immediately beside end_date using:
  =IF(end_date cell="","Active","Ended")
This was used to clearly distinguish active and ended subscriptions before further analysis.

- Loaded the cleaned datasets into SQL and created queries to analyze churn, revenue, support, and product usage.
  
- Imported the cleaned tables into Power BI and built relationships between customers, subscriptions, support tickets, product usage, and churn data.
  
- Created DAX measures for KPIs such as churn rate, MRR, ARR, escalation percentage, resolution time, usage duration, and customer-level metrics.
  
- Designed five dashboard pages to analyze different parts of the business.
  
- Added slicers, page navigation buttons, and a customer deep-dive page for interactive analysis.
  
- Converted the final findings into business insights and recommendations.
