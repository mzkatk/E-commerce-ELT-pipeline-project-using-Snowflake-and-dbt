-- Insight: Top cities by revenue
SELECT
    c.customer_city,
    SUM(f.total_order_value) AS revenue
FROM olist_db.analytics.fct_orders f
JOIN olist_db.analytics.dim_customers c
    ON f.customer_id = c.customer_id
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10;

--Contribution of top 10 citites by revenue
WITH city_revenue AS (
    SELECT
        c.customer_city,
        SUM(f.total_order_value) AS revenue
    FROM olist_db.analytics.fct_orders f
    JOIN olist_db.analytics.dim_customers c
        ON f.customer_id = c.customer_id
    GROUP BY 1
),

top_10 AS (
    SELECT *
    FROM city_revenue
    ORDER BY revenue DESC
    LIMIT 10
),

totals AS (
    SELECT SUM(revenue) AS total_revenue FROM city_revenue
)

SELECT
    SUM(top_10.revenue) AS top_10_revenue,
    MAX(totals.total_revenue) AS total_revenue,
    (SUM(top_10.revenue) / MAX(totals.total_revenue)) * 100 AS percentage_contribution
FROM top_10, totals;



-- Insight: Delivery performance by order status
SELECT
    order_status,
    AVG(delivery_days) AS avg_delivery_time
FROM olist_db.analytics.fct_orders
WHERE delivery_days IS NOT NULL
GROUP BY 1
ORDER BY avg_delivery_time;


-- Insight: Delivery performance by state
SELECT
    c.customer_state,
    AVG(f.delivery_days) AS avg_delivery_time
FROM olist_db.analytics.fct_orders f
JOIN olist_db.analytics.dim_customers c
    ON f.customer_id = c.customer_id
WHERE f.delivery_days IS NOT NULL
GROUP BY 1
ORDER BY avg_delivery_time DESC;


-- Insight: Order value distribution
SELECT
    CASE 
        WHEN total_order_value < 100 THEN 'Low'
        WHEN total_order_value < 500 THEN 'Medium'
        ELSE 'High'
    END AS order_bucket,
    COUNT(*) AS orders
FROM olist_db.analytics.fct_orders
GROUP BY 1
ORDER BY orders DESC;


-- Insight: Category-level revenue
SELECT
    product_category_name,
    SUM(total_order_value) AS revenue
FROM olist_db.analytics.fct_orders
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10;

--top 3 category contribution to revenue
WITH category_revenue AS (
    SELECT
        product_category_name,
        SUM(total_order_value) AS revenue
    FROM olist_db.analytics.fct_orders
    GROUP BY 1
),

top_3 AS (
    SELECT *
    FROM category_revenue
    ORDER BY revenue DESC
    LIMIT 3
),

totals AS (
    SELECT SUM(revenue) AS total_revenue FROM category_revenue
)

SELECT
    SUM(top_3.revenue) AS top_3_revenue,
    MAX(totals.total_revenue) AS total_revenue,
    (SUM(top_3.revenue) / MAX(totals.total_revenue)) * 100 AS percentage_contribution
FROM top_3, totals;


-- Insight: Payment behavior
SELECT
    payment_type,
    COUNT(*) AS orders,
    AVG(total_order_value) AS avg_order_value
FROM olist_db.analytics.fct_orders
GROUP BY 1
ORDER BY orders DESC;

--percentage of payments done using different payment methods
SELECT
    payment_type,
    SUM(payment_value) AS total_payment,
    SUM(payment_value) / SUM(SUM(payment_value)) OVER () * 100 AS percentage_share
FROM olist_db.raw.order_payments
GROUP BY payment_type
ORDER BY percentage_share DESC;


-- Insight: Delivery vs order value
SELECT
    CASE 
        WHEN total_order_value < 100 THEN 'Low'
        WHEN total_order_value < 500 THEN 'Medium'
        ELSE 'High'
    END AS order_bucket,
    AVG(delivery_days) AS avg_delivery
FROM olist_db.analytics.fct_orders
WHERE delivery_days IS NOT NULL
GROUP BY 1;