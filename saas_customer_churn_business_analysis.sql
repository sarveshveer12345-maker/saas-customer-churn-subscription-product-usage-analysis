
# 1. Which plan tier generates the highest total MRR?
SELECT plan_tier, SUM(mrr_amount) AS total_mrr
FROM subscriptions
GROUP BY plan_tier
ORDER BY total_mrr DESC;


# 2. Which industries have the highest churn rate?
SELECT a.industry,
COUNT(DISTINCT c.account_id) AS churned_customers,
COUNT(DISTINCT a.account_id) AS total_customers,
ROUND(COUNT(DISTINCT c.account_id) * 100.0 / COUNT(DISTINCT a.account_id),2) AS churn_rate_pct
FROM accounts a
LEFT JOIN customer_churn c
ON a.account_id = c.account_id
GROUP BY a.industry
ORDER BY churn_rate_pct DESC;


# 3. Which countries bring the most ARR?
SELECT a.country, SUM(s.arr_amount) AS total_arr
FROM accounts a
JOIN subscriptions s
ON a.account_id = s.account_id
GROUP BY a.country
ORDER BY total_arr DESC;


# 4. Which referral sources generate the highest-value customers?
SELECT a.referral_source, ROUND(AVG(s.arr_amount),2) AS avg_arr_per_customer
FROM accounts a
JOIN subscriptions s
ON a.account_id = s.account_id
GROUP BY a.referral_source
ORDER BY avg_arr_per_customer DESC;


# 5. Which plan tier has the highest average monthly recurring revenue (MRR) per customer?
SELECT plan_tier, ROUND(AVG(mrr_amount), 2) AS avg_mrr_per_customer
FROM subscriptions
GROUP BY plan_tier
ORDER BY avg_mrr_per_customer DESC;


# 6. How many customers upgraded vs downgraded?
SELECT SUM(CASE WHEN upgrade_flag = 'TRUE' THEN 1 ELSE 0 END) AS upgraded_customers,
SUM(CASE WHEN downgrade_flag = 'TRUE' THEN 1 ELSE 0 END) AS downgraded_customers
FROM subscriptions;


# 7. Which plan has the highest upgrade rate?
SELECT plan_tier,
ROUND(SUM(CASE WHEN upgrade_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2 ) AS upgrade_rate_pct
FROM subscriptions
GROUP BY plan_tier
ORDER BY upgrade_rate_pct DESC;


# 8. What percentage of customers are on auto-renew?
SELECT ROUND(SUM(CASE WHEN auto_renew_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS auto_renew_pct
FROM subscriptions;


# 9. Which plan tier has the highest percentage of churned customers?
SELECT plan_tier,
ROUND(SUM(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0/ COUNT(*),2) AS churn_percentage
FROM subscriptions
GROUP BY plan_tier
ORDER BY churn_percentage DESC;


# 10. Which customers have multiple subscriptions?
SELECT a.account_name, COUNT(s.subscription_id) AS total_subscriptions
FROM accounts a
JOIN subscriptions s
ON a.account_id = s.account_id
GROUP BY a.account_name
HAVING COUNT(s.subscription_id) > 1
ORDER BY total_subscriptions DESC;


# 11. Which features are used the most?
SELECT feature_name, SUM(usage_count) AS total_usage
FROM product_usage
GROUP BY feature_name
ORDER BY total_usage DESC
LIMIT 10;


# 12. Which features are most used by Enterprise customers?
SELECT p.feature_name, SUM(p.usage_count) AS total_usage
FROM product_usage p
JOIN subscriptions s
ON p.subscription_id = s.subscription_id
WHERE s.plan_tier = 'Enterprise'
GROUP BY p.feature_name
ORDER BY total_usage DESC
LIMIT 10;


# 13. Do churned customers use the product less than active customers?
SELECT s.churn_flag,
ROUND(AVG(p.usage_duration_seconds),2) AS avg_usage_duration_seconds,
ROUND(AVG(p.usage_count),2) AS avg_usage_count
FROM subscriptions s
JOIN product_usage p
ON s.subscription_id = p.subscription_id
GROUP BY s.churn_flag;


# 14. Which beta features have the highest error count?
SELECT feature_name, SUM(error_count) AS total_errors
FROM product_usage
WHERE is_beta_feature = 'TRUE'
GROUP BY feature_name
ORDER BY total_errors DESC
LIMIT 10;


# 15. Does lower usage duration lead to churn?
SELECT
CASE
	WHEN usage_duration_seconds < 1000 THEN 'Low Usage'
	WHEN usage_duration_seconds < 5000 THEN 'Medium Usage'
	ELSE 'High Usage'
END AS usage_segment,
ROUND(AVG(CASE WHEN s.churn_flag = 'True' THEN 1 ELSE 0 END) * 100,2) AS churn_rate_pct
FROM product_usage p
JOIN subscriptions s
ON p.subscription_id = s.subscription_id
GROUP BY usage_segment
ORDER BY churn_rate_pct DESC;


# 16. Which customers raise the most tickets?
SELECT a.account_name, COUNT(t.ticket_id) AS total_tickets
FROM accounts a
JOIN support_tickets t
ON a.account_id = t.account_id
GROUP BY a.account_name
ORDER BY total_tickets DESC
LIMIT 10;


# 17. Does long ticket resolution time increase churn?
SELECT
CASE
	WHEN t.resolution_time_hours <= 24 THEN '0-24 Hours'
	WHEN t.resolution_time_hours <= 72 THEN '25-72 Hours'
	ELSE '72+ Hours'
END AS resolution_bucket,
ROUND(AVG(CASE WHEN c.account_id IS NOT NULL THEN 1 ELSE 0 END) * 100,2) AS churn_rate_pct
FROM support_tickets t
LEFT JOIN customer_churn c
ON t.account_id = c.account_id
GROUP BY resolution_bucket
ORDER BY churn_rate_pct DESC;


# 18. Which ticket priority has the lowest satisfaction score?
SELECT priority,
ROUND(AVG(CAST(satisfaction_score AS UNSIGNED)), 2) AS avg_satisfaction_score
FROM support_tickets
WHERE satisfaction_score IS NOT NULL
AND satisfaction_score <> ''
GROUP BY priority
ORDER BY avg_satisfaction_score;


# 19. Which industries create the most support load?
SELECT a.industry, COUNT(t.ticket_id) AS total_tickets
FROM accounts a
JOIN support_tickets t
ON a.account_id = t.account_id
GROUP BY a.industry
ORDER BY total_tickets DESC;


# 20. Are escalated tickets more common among churned customers?
SELECT
CASE 
    WHEN c.account_id IS NOT NULL THEN 'Churned' ELSE 'Active' END AS customer_status,
    ROUND(AVG(CASE WHEN t.escalation_flag = 'True' THEN 1 ELSE 0 END) * 100,2) AS escalated_ticket_pct
FROM support_tickets t
LEFT JOIN customer_churn c
ON t.account_id = c.account_id
GROUP BY customer_status;


# 21. What are the top churn reasons?
SELECT reason_code, COUNT(*) AS total_churns
FROM customer_churn
GROUP BY reason_code
ORDER BY total_churns DESC;


# 22. Which plan tier has the highest average number of support tickets among churned customers?
SELECT s.plan_tier,
ROUND(COUNT(st.ticket_id) * 1.0 / COUNT(DISTINCT s.account_id), 2) AS avg_tickets_per_churned_customer
FROM subscriptions s
JOIN support_tickets st
ON s.account_id = st.account_id
WHERE s.churn_flag = 'TRUE'
GROUP BY s.plan_tier
ORDER BY avg_tickets_per_churned_customer DESC;


# 23. Did customers usually downgrade before churn?
SELECT preceding_downgrade_flag, COUNT(*) AS total_churns
FROM customer_churn
GROUP BY preceding_downgrade_flag;


# 24. Which accounts churned after receiving poor support?
SELECT a.account_name, AVG(t.satisfaction_score) AS avg_satisfaction, AVG(t.resolution_time_hours) AS avg_resolution_time
FROM accounts a
JOIN support_tickets t
ON a.account_id = t.account_id
JOIN customer_churn c
ON a.account_id = c.account_id
GROUP BY a.account_name
HAVING AVG(t.satisfaction_score) < 3
ORDER BY avg_resolution_time Desc;


# 25. Which churn reasons are most common for each plan tier?
SELECT s.plan_tier, c.reason_code, COUNT(*) AS churn_count
FROM customer_churn c
JOIN subscriptions s
ON c.account_id = s.account_id
WHERE s.churn_flag = 'TRUE'
GROUP BY s.plan_tier, c.reason_code
ORDER BY s.plan_tier, churn_count DESC;


