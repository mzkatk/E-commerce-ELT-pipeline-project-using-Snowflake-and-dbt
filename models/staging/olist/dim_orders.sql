WITH source AS (

    SELECT * 
    FROM {{ source('raw','orders') }}

),

renamed AS (

    SELECT
        order_id,
        customer_id,
        order_status,

        order_purchase_timestamp      AS order_purchase_ts,
        order_approved_at             AS order_approved_ts,
        order_delivered_carrier_date  AS order_delivered_carrier_ts,
        order_delivered_customer_date AS order_delivered_customer_ts,
        order_estimated_delivery_date AS order_estimated_delivery_ts

    FROM source

)

SELECT * FROM renamed