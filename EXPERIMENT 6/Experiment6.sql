-- HR-Analytics: Employee count based on dynamic gender passing (Medium Level)

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    gender VARCHAR(10)
);

INSERT INTO employees (emp_name, gender) VALUES
('Shivanshu Ranjan', 'Male'),
('Tanya Verma', 'Female'),
('Alok Kumar', 'Male'),
('Neha Singh', 'Female'),
('Devanshu Ranjan', 'Male');

-- Stored procedure
CREATE OR REPLACE PROCEDURE get_employee_count_by_gender(IN input_gender VARCHAR,OUT gender_count INT)
LANGUAGE plpgsql
AS 
$$
BEGIN
    SELECT COUNT(*)
    INTO gender_count
    FROM employees
    WHERE LOWER(gender) = LOWER(input_gender);

    RAISE NOTICE 'Total employees with gender % are: %', input_gender, gender_count;
END;
$$;

CALL get_employee_count_by_gender('Male', NULL); -- Call for Male

CALL get_employee_count_by_gender('Female', NULL); -- Call for Female




-- SmartStore Automated Purchase System (Hard Level)

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    unit_price NUMERIC(10,2),
    quantity_remaining INT,
    quantity_sold INT DEFAULT 0
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT,
    total_price NUMERIC(10,2),
    sale_date TIMESTAMP DEFAULT NOW()
);

INSERT INTO products (product_name, unit_price, quantity_remaining)
VALUES
('Smartphone', 25000, 10),
('Tablet', 18000, 5),
('Laptop', 55000, 3);


CREATE OR REPLACE PROCEDURE process_order(IN p_product_id INT,IN p_quantity INT)
LANGUAGE plpgsql
AS $$
DECLARE
    available_qty INT;
    product_price NUMERIC(10,2);
    total NUMERIC(10,2);
BEGIN
    -- Get available stock and price
    SELECT quantity_remaining, unit_price
    INTO available_qty, product_price
    FROM products
    WHERE product_id = p_product_id;

    -- If no product found
    IF available_qty IS NULL THEN
        RAISE NOTICE 'Product not found!';
        RETURN;
    END IF;

    -- Check stock availability
    IF available_qty >= p_quantity THEN
        -- Calculate total price
        total := product_price * p_quantity;

        -- Log the order in sales
        INSERT INTO sales(product_id, quantity, total_price)
        VALUES (p_product_id, p_quantity, total);

        -- Update inventory
        UPDATE products
        SET quantity_remaining = quantity_remaining - p_quantity,
            quantity_sold = quantity_sold + p_quantity
        WHERE product_id = p_product_id;

        -- Confirmation message
        RAISE NOTICE 'Product sold successfully!';
    ELSE
        -- Reject order
        RAISE NOTICE 'Insufficient Quantity Available!';
    END IF;
END;
$$;

select * from products;

CALL process_order(1, 2);
select * from products;

CALL process_order(3, 10);
-- select * from products;
