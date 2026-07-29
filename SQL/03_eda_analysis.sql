-- ============================================================
-- Author: Okunowo Oluwademilade David
-- Date: 2026-07-27
-- Description: SQL analysis validating the Python EDA finding —
--              does delivery delay affect review scores?
--              Assumes order_reviews_clean already exists
--              (see 02_data_cleaning.sql).
-- ============================================================

-- ------------------------------------------------------------
-- 1. Calculate delivery delay in days per order
-- ------------------------------------------------------------
SELECT COUNT(*) FROM order_reviews_clean;
CREATE TABLE order_delay AS
SELECT
    order_id,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    EXTRACT(DAY FROM (order_delivered_customer_date - order_estimated_delivery_date)) AS delay_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
SELECT *FROM order_delay;

-- ------------------------------------------------------------
-- 2. Compare average review score by delivery bucket
-- ------------------------------------------------------------
WITH delay_bucketed AS (
    SELECT
        order_id,
        delay_days,
        CASE
            WHEN delay_days < 0 THEN 'early'
            WHEN delay_days = 0 THEN 'on_time'
            ELSE 'late'
        END AS delivery_bucket
    FROM order_delay
)
SELECT
    d.delivery_bucket,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS order_count
FROM delay_bucketed d
JOIN order_reviews_clean r ON d.order_id = r.order_id
GROUP BY d.delivery_bucket
ORDER BY avg_review_score DESC;

-- ------------------------------------------------------------
-- 3. Compare average review score by delivery bucket AND category
-- ------------------------------------------------------------
WITH order_delay AS (
    SELECT
        order_id,
        EXTRACT(DAY FROM (order_delivered_customer_date - order_estimated_delivery_date)) AS delay_days
    FROM orders
    WHERE order_delivered_customer_date IS NOT NULL
),
delay_bucketed AS (
    SELECT
        order_id,
        CASE
            WHEN delay_days < 0 THEN 'early'
            WHEN delay_days = 0 THEN 'on_time'
            ELSE 'late'
        END AS delivery_bucket
    FROM order_delay
),
order_category AS (
    SELECT DISTINCT ON (oi.order_id)
        oi.order_id,
        COALESCE(t.product_category_name_english, 'unknown') AS category
    FROM order_items oi
    LEFT JOIN products p ON oi.product_id = p.product_id
    LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
    ORDER BY oi.order_id, oi.order_item_id
)
SELECT
    oc.category,
    d.delivery_bucket,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS order_count
FROM delay_bucketed d
JOIN order_reviews_clean r ON d.order_id = r.order_id
JOIN order_category oc ON d.order_id = oc.order_id
GROUP BY oc.category, d.delivery_bucket
HAVING COUNT(*) >= 30
ORDER BY oc.category, d.delivery_bucket;