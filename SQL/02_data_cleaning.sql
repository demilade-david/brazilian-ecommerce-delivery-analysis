-- ============================================================
-- Author: Okunowo Oluwademilade David
-- Date: 2026-07-27
-- Description: Cleans order_reviews by removing duplicate
--              reviews per order, keeping only the most recent
--              review. Mirrors the pandas cleaning logic used
--              in 01_cleaning.ipynb.
-- ============================================================

CREATE TABLE order_reviews_clean AS
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY review_creation_date DESC
        ) AS rn
    FROM order_reviews
) ranked
WHERE rn = 1;

-- Verification:
SELECT COUNT(*) FROM order_reviews_clean;