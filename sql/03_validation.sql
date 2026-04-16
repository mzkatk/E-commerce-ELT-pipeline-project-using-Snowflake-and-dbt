-- Raw table validation
SELECT COUNT(*) FROM olist_db.raw.orders;
SELECT COUNT(*) FROM olist_db.raw.customers;
SELECT COUNT(*) FROM olist_db.raw.order_items;
SELECT COUNT(*) FROM olist_db.raw.order_payments;
SELECT COUNT(*) FROM olist_db.raw.products;

-- dbt model validation
SELECT COUNT(*) FROM olist_db.analytics.stg_order_items;
SELECT COUNT(*) FROM olist_db.analytics.int_order_details;
SELECT COUNT(*) FROM olist_db.analytics.fct_orders;

-- Grain validation
SELECT COUNT(*) FROM olist_db.analytics.int_order_details;
SELECT COUNT(DISTINCT order_id) 
FROM olist_db.analytics.int_order_details;

-- Payment vs revenue sanity check
SELECT 
    SUM(total_payment_value),
    SUM(total_order_value)
FROM olist_db.analytics.fct_orders;

-- Delivery NULL check
-- delivery_days is NULL for orders not yet delivered
SELECT order_status, COUNT(*)
FROM olist_db.analytics.fct_orders
WHERE delivery_days IS NULL
GROUP BY 1;