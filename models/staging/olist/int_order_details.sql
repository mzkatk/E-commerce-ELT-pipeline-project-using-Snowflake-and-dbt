WITH order_items AS (

    SELECT *
    FROM {{ ref('dim_order_items') }}

),

orders AS (

    SELECT *
    FROM {{ ref('dim_orders') }}

),

customers AS (

    SELECT *
    FROM {{ ref('dim_customers') }}

),

products AS (

    SELECT *
    FROM {{ ref('dim_products') }}

),

payments AS (

    SELECT
        order_id,
        SUM(payment_value) AS total_payment_value,
        MAX(payment_type) AS payment_type
    FROM {{ ref('dim_order_payments') }}
    GROUP BY order_id

),

joined AS (

    SELECT
        md5(oi.order_id || '-' || oi.order_item_id) AS order_item_key,

        -- keys
        oi.order_id,
        oi.order_item_id,

        -- order-level
        o.customer_id,
        o.order_status,
        o.order_purchase_ts,
        o.order_approved_ts,
        o.order_delivered_carrier_ts,
        o.order_delivered_customer_ts,
        o.order_estimated_delivery_ts,

        -- item-level
        oi.product_id,
        oi.seller_id,
        oi.shipping_limit_ts,
        oi.price,
        oi.freight_value,

        -- product-level
        p.product_category_name,

        -- payment-level
        pay.payment_type,
        pay.total_payment_value,

        -- customer-level
        c.customer_city,
        c.customer_state

    FROM order_items oi

    LEFT JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN customers c
        ON o.customer_id = c.customer_id

    LEFT JOIN products p
        ON oi.product_id = p.product_id

    LEFT JOIN payments pay
        ON oi.order_id = pay.order_id

)

SELECT * FROM joined