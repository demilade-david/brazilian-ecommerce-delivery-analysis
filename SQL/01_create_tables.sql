-- ============================================================
-- Author: Okunowo Oluwademilade David
-- Date: 2026-07-27
-- Description: Table schema for the Olist e-commerce SQL analysis.
--              Recreates the core relational structure (orders,
--              reviews, items, products) to independently validate
--              the Python-based delivery delay analysis.
-- ============================================================

CREATE TABLE orders(
order_id VARCHAR PRIMARY KEY,
customer_id VARCHAR,
order_status VARCHAR,
order_purchase_timestamp TIMESTAMP,
order_approved_at TIMESTAMP,
order_delivered_carrier_date TIMESTAMP,
order_delivered_customer_date TIMESTAMP,
order_estimated_delivery_date TIMESTAMP
);
CREATE TABLE customers(
customer_id VARCHAR PRIMARY KEY,
customer_unique_id VARCHAR,
customer_zip_code_prefix INT,
customer_city VARCHAR,
customer_state VARCHAR
);
CREATE TABLE order_payments(
order_id VARCHAR ,
payment_sequential INT,
payment_type VARCHAR,
payment_installments INT,
payment_value NUMERIC
);
CREATE TABLE order_reviews (
    review_id VARCHAR,
    order_id VARCHAR,
    review_score INT,
    review_comment_title VARCHAR,
    review_comment_message VARCHAR,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);
CREATE TABLE order_items(
order_id VARCHAR,
order_item_id VARCHAR,
product_id VARCHAR,
seller_id VARCHAR,
shipping_limit_date TIMESTAMP,
price NUMERIC,
freight_value NUMERIC
);
CREATE TABLE products(
product_id VARCHAR PRIMARY KEY,
product_category_name VARCHAR,
product_name_lenght INT,
product_description_lenght INT,
product_photos_qty INT,
product_weight_g INT,
product_length_cm INT,
product_height_cm INT,
product_width_cm INT
);