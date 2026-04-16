WITH source AS (

    SELECT * 
    FROM {{ source('raw','order_items') }}

),

renamed AS (

    SELECT
        order_id,
        order_item_id,
        product_id,
        seller_id,
        CAST(shipping_limit_date AS TIMESTAMP) AS shipping_limit_ts,
        price,
        freight_value

    FROM source

)

SELECT * FROM renamed