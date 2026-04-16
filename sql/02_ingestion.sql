-- Orders
CREATE OR REPLACE TABLE olist_db.raw.orders (
    order_id STRING,
    customer_id STRING,
    order_status STRING,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

COPY INTO olist_db.raw.orders
FROM @olist_db.raw.olist_stage/orders_dataset.csv
FILE_FORMAT = (FORMAT_NAME = 'olist_db.raw.csv_format');


-- Customers
CREATE OR REPLACE TABLE olist_db.raw.customers (
    customer_id STRING,
    customer_unique_id STRING,
    customer_zip_code_prefix INTEGER,
    customer_city STRING,
    customer_state STRING
);

COPY INTO olist_db.raw.customers
FROM @olist_db.raw.olist_stage/customers_dataset.csv
FILE_FORMAT = (FORMAT_NAME = 'olist_db.raw.csv_format');


-- Order Items
CREATE OR REPLACE TABLE olist_db.raw.order_items (
    order_id STRING,
    order_item_id INTEGER,
    product_id STRING,
    seller_id STRING,
    shipping_limit_date TIMESTAMP,
    price NUMBER(10,2),
    freight_value NUMBER(10,2)
);

COPY INTO olist_db.raw.order_items
FROM @olist_db.raw.olist_stage/order_items_dataset.csv
FILE_FORMAT = (FORMAT_NAME = 'olist_db.raw.csv_format');


-- Order Payments
CREATE OR REPLACE TABLE olist_db.raw.order_payments (
    order_id STRING,
    payment_sequential INTEGER,
    payment_type STRING,
    payment_installments INTEGER,
    payment_value FLOAT
);

COPY INTO olist_db.raw.order_payments
FROM @olist_db.raw.olist_stage/order_payments_dataset.csv
FILE_FORMAT = (FORMAT_NAME = 'olist_db.raw.csv_format');


-- Products
CREATE OR REPLACE TABLE olist_db.raw.products (
    product_id STRING,
    product_category_name STRING,
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

COPY INTO olist_db.raw.products
FROM @olist_db.raw.olist_stage/products_dataset.csv
FILE_FORMAT = (FORMAT_NAME = 'olist_db.raw.csv_format');