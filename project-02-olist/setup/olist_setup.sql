/**********************************************************
FIRST OF ALL, LET´S CREATE ALL THE TABLES FOR THIS DATASET.
**********************************************************/

/*************************************************************
WE HAVE 9 TABLES IN TOTAL BUT WE AREN´T GOING TO USE THEM ALL.
**************************************************************/

/******************************************************************************************************************
BEFORE WE BEGIN, KEEP IN MIND THAT THE ORDER WE CREATE THE TABLES HAS SOME RULES RELATED TO THE PRIMARY KEYS LINKED.
´CAUSE IF A TABLE IS TRYING TO CONNECT WITH A COLUMN FROM ANOTHER TABLE, THIS TABLE HAS TO HAVE ALREADY BEEN CREATED
*******************************************************************************************************************/

--customers table

CREATE TABLE IF NOT EXISTS customers (
	customer_id VARCHAR(),
	customer_unique_id VARCHAR(),
	customer_zip_code_prefix VARCHAR(),
	customer_city TEXT(),
	customer_state CHAR(2)
);


--geolocation table

CREATE TABLE IF NOT EXISTS geolocation (
	geolocation_zip_code_prefix CHAR(4),
	geolocation_lat NUMERIC(9,15),
	geolocation_lng NUMERIC(9,15),
	geolocation_city VARCHAR(),
	geolocation_state CHAR(2)
);

--order_items table

CREATE TABLE IF NOT EXISTS order_items (
	order_id VARCHAR(),
	order_item_id INT,
	product_id VARCHAR(),
	seller_id VARCHAR(),
	shipping_limit_date TIMESTAMP,
	price DECIMAL(10,2),
	freight_value DECIMAL(10,2)
);

--order_payments table

CREATE TABLE IF NOT EXISTS order_payments (
	order_id VARCHAR(),
	payment_sequential INT,
	payment_type VARCHAR(),
	payment_installments INT,
	payment_value DECIMAL(10,2)
);

--order_reviews table

CREATE TABLE IF NOT EXISTS order_reviews (
	review_id VARCHAR(),
	order_id VARCHAR(),
	review_score INT(1),
	review_comment_title VARCHAR(),
	review_comment_message VARCHAR(),
	review_creation_date TIMESTAMP,
	review_answer_timestamp TIMESTAMP
);

--orders table

CREATE TABLE IF NOT EXISTS orders (
	order_id VARCHAR(),
	customer_id VARCHAR(),
	order_status VARCHAR(),
	order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
);


--products table

CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(),
    product_category_name VARCHAR(),
    product_name_length INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_product_lenght_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

--sellers table

CREATE TABLE IF NOT EXISTS sellers (
    seller_id VARCHAR(),
    seller_zip_code_prefix INT,
    seller_city VARCHAR,
    seller_state CHAR(2)
);


--product_name_translation table

CREATE TABLE IF NOT EXISTS product_category_name (
    product_category_name VARCHAR(),
    product_category_name_english VARCHAR()
)








