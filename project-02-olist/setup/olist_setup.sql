/**********************************************************
 FIRST OF ALL, LET´S CREATE ALL THE TABLES FOR THIS DATASET.
 **********************************************************/
/*************************************************************
 WE HAVE 9 TABLES IN TOTAL BUT WE AREN´T GOING TO USE THEM ALL.
 **************************************************************/
/*************************************************************************************************************************************
 BEFORE WE BEGIN, KEEP IN MIND THAT THE ORDER WE CREATE THE TABLES HAS SOME RULES RELATED TO THE PRIMARY KEYS LINKED WITH FOREIGN KEYS.
 ´CAUSE IF A TABLE IS TRYING TO CONNECT WITH A COLUMN FROM ANOTHER TABLE´s COLUMN, THIS TABLE HAS TO HAVE ALREADY BEEN CREATED
 *************************************************************************************************************************************/
--customers table
CREATE TABLE IF NOT EXISTS customers (
	customer_id VARCHAR(32),
	customer_unique_id VARCHAR(32) NOT NULL,
	customer_zip_code_prefix VARCHAR(5),
	customer_city TEXT,
	customer_state CHAR(2),
	PRIMARY KEY (customer_id)
);
--sellers table
CREATE TABLE IF NOT EXISTS sellers (
	seller_id VARCHAR(32),
	seller_zip_code_prefix VARCHAR(5),
	seller_city TEXT,
	seller_state CHAR(2),
	PRIMARY KEY (seller_id)
);
--products table
CREATE TABLE IF NOT EXISTS products (
	product_id VARCHAR(32),
	product_category_name TEXT,
	product_name_length INT,
	product_description_length INT,
	product_photos_qty INT,
	product_weight_g INT,
	product_length_cm INT,
	product_height_cm INT,
	product_width_cm INT,
	PRIMARY KEY (product_id)
);
--geolocation table
CREATE TABLE IF NOT EXISTS geolocation (
	geolocation_zip_code_prefix VARCHAR(5),
	geolocation_lat NUMERIC(10, 8),
	geolocation_lng NUMERIC(10, 8),
	geolocation_city TEXT,
	geolocation_state CHAR(2)
);
--product_category_name_translation
CREATE TABLE IF NOT EXISTS product_category_name_translation (
	product_category_name TEXT PRIMARY KEY,
	product_category_name_english TEXT
);
--orders table
CREATE TABLE IF NOT EXISTS orders (
	order_id VARCHAR(32),
	customer_id VARCHAR(32) NOT NULL,
	order_status VARCHAR(20),
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date TIMESTAMP,
	PRIMARY KEY (order_id),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
--order_items table
CREATE TABLE IF NOT EXISTS order_items (
	order_id VARCHAR(32),
	order_item_id INT,
	product_id VARCHAR(32) NOT NULL,
	seller_id VARCHAR(32) NOT NULL,
	shipping_limit_date TIMESTAMP,
	price DECIMAL(10, 2) NOT NULL,
	freight_value DECIMAL(10, 2) NOT NULL,
	PRIMARY KEY (order_id, order_item_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id),
	FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);
--order_payments table
CREATE TABLE IF NOT EXISTS order_payments (
	order_id VARCHAR(32),
	payment_sequential INT,
	payment_type VARCHAR(20),
	payment_installments INT,
	payment_value DECIMAL(10, 2),
	PRIMARY KEY (order_id, payment_sequential),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
--order_reviews table
CREATE TABLE IF NOT EXISTS order_reviews (
	id SERIAL PRIMARY KEY,
	review_id VARCHAR(32),
	order_id VARCHAR(32),
	review_score INT CHECK (
		review_score BETWEEN 1 AND 5
	),
	review_comment_title TEXT,
	review_comment_message TEXT,
	review_creation_date TIMESTAMP,
	review_answer_timestamp TIMESTAMP,
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_order_items_seller_id ON order_items(seller_id);
CREATE INDEX IF NOT EXISTS idx_geolocation_zip ON geolocation(geolocation_zip_code_prefix);