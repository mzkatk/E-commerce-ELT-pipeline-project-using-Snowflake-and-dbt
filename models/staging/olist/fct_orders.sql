WITH base AS (

    SELECT *
    FROM {{ ref('int_order_details') }}

),

aggregated AS (

    SELECT
        -- keys
        order_id,
        customer_id,

        -- order info
        order_status,
        order_purchase_ts,
        order_delivered_customer_ts,

        -- metrics
        COUNT(order_item_id) AS total_items,
        SUM(price) AS total_order_value,
        SUM(freight_value) AS total_freight_value,

        SUM(price) / NULLIF(COUNT(order_item_id), 0) AS avg_item_value,
        SUM(price + freight_value) AS total_order_value_including_freight,

        -- delivery metric
        DATEDIFF(day, MIN(order_purchase_ts), MAX(order_delivered_customer_ts)) AS delivery_days,

        -- revenue enrichment
        MAX(product_category_name) AS product_category_name,
        MAX(payment_type) AS payment_type,
        MAX(total_payment_value) AS total_payment_value

    FROM base 

    GROUP BY 
        order_id,
        customer_id,
        order_status,
        order_purchase_ts,
        order_delivered_customer_ts

)

SELECT * FROM aggregated