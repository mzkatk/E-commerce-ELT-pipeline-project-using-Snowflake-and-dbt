WITH source AS (

    SELECT * 
    FROM {{ source('raw','customers') }}

),

renamed AS (

    SELECT
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix AS customer_zip_code,
        customer_city,
        customer_state

    FROM source

)

SELECT * FROM renamed