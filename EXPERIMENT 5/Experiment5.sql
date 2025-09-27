-- Performance Benchmarking (Medium Level)

CREATE TABLE transaction_data (
    id INT,
    value INT
);

-- Insert 1 million rows for id=1
INSERT INTO transaction_data (id, value)
SELECT 1, (random() * 1000)
FROM generate_series(1, 1000000);

-- Insert 1 million rows for id=2
INSERT INTO transaction_data (id, value)
SELECT 2, (random() * 1000)
FROM generate_series(1, 1000000);

SELECT COUNT(*) FROM transaction_data;

-- Normal View
CREATE OR REPLACE VIEW sales_summary_view AS
SELECT
    id,
    COUNT(*) AS total_orders,
    SUM(value) AS total_sales,
    AVG(value) AS avg_transaction
FROM transaction_data
GROUP BY id;

SELECT * FROM sales_summary_view;

-- Check Performance (Normal View)
EXPLAIN ANALYZE SELECT * FROM sales_summary_view;


-- Materialized View
CREATE MATERIALIZED VIEW sales_summary_mv AS
SELECT
    id,
    COUNT(*) AS total_orders,
    SUM(value) AS total_sales,
    AVG(value) AS avg_transaction
FROM transaction_data
GROUP BY id;

SELECT * FROM sales_summary_mv;

-- Check Performance (Materialized View)
EXPLAIN ANALYZE SELECT * FROM sales_summary_mv;




-- Securing Data Access with Views and Role-Based Permissions (Hard Level)

CREATE TABLE customer_master (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100)
);

CREATE TABLE product_catalog (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    unit_price NUMERIC(10,2)
);

CREATE TABLE sales_orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customer_master(customer_id),
    product_id INT REFERENCES product_catalog(product_id),
    order_date DATE,
    quantity INT,
    discount_percent NUMERIC(5,2)
);

INSERT INTO customer_master (full_name) VALUES
('Shivanshu Ranjan'),
('Tanya Verma'),
('Alok Kumar'),
('Neha Sharma');

INSERT INTO product_catalog (product_name, unit_price) VALUES
('Laptop', 60000),
('Keyboard', 1200),
('Monitor', 15000),
('Mouse', 800);

INSERT INTO sales_orders (customer_id, product_id, order_date, quantity, discount_percent) VALUES
(1, 1, '2025-09-01', 1, 10),
(2, 2, '2025-09-02', 2, 5),
(3, 3, '2025-09-03', 1, 20),
(4, 4, '2025-09-05', 3, 15);


-- Create View

CREATE OR REPLACE VIEW vW_ORDER_SUMMARY AS
SELECT 
    O.order_id,
    O.order_date,
    P.product_name,
    C.full_name,
    (P.unit_price * O.quantity) 
      - ((P.unit_price * O.quantity) * O.discount_percent / 100) AS final_cost
FROM customer_master AS C
JOIN sales_orders AS O 
    ON O.customer_id = C.customer_id
JOIN product_catalog AS P
    ON P.product_id = O.product_id;

-- Create Restricted role/user (shivanshu)
CREATE ROLE shivanshu LOGIN PASSWORD '1234';


-- shivanshu logs in and runs (In new query window)
SELECT * FROM vW_ORDER_SUMMARY; -- permission denied for view vW_ORDER_SUMMARY

-- Grant access to shivanshu
GRANT SELECT ON vW_ORDER_SUMMARY TO shivanshu;
SELECT * FROM vW_ORDER_SUMMARY; -- now shivanshu can view vW_ORDER_SUMMARY

SELECT * FROM customer_master; -- shivanshu can't view base tables(direct access)

-- Revoke access from shivanshu
REVOKE SELECT ON vW_ORDER_SUMMARY FROM alok;
SELECT * FROM vW_ORDER_SUMMARY; -- now shivanshu can't view vW_ORDER_SUMMARY
