-- Create the database
CREATE DATABASE ECommerceDB;

-- Switch to the newly created database
USE ECommerceDB;

-- Create Customer table to store customer details
CREATE TABLE Customers (
	customer_id		INT PRIMARY KEY,	-- Unique identifier for each customer
	first_name		VARCHAR(50),		-- Customer's first name
	last_name		VARCHAR(50),		-- Customer's last name
	email			VARCHAR(100),		-- Customer's email address
	registration_date	DATE			-- Date the customer registered
);

-- Create Products table to store product details
CREATE TABLE Products (
	product_id		INT PRIMARY KEY,	-- Unique identifier for each product
	product_name	VARCHAR(100),		-- Name of the product
	category		VARCHAR(50),		-- Category of the product (e.g., Electronics, Clothing)
	price			DECIMAL(10, 2),		-- Price of the product (with two decimal points)
	
);

-- Create Orders table to store order details
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,     -- Unique identifier for each order
    customer_id INT,              -- Foreign key linking the order to a specific customer
    order_date DATE,              -- Date the order was placed
    total_amount DECIMAL(10, 2),  -- Total amount of the order
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)  -- Foreign key constraint to ensure customer exists
);

-- Create Order_Items table to store details of products in each order
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,  -- Unique identifier for each order item
    order_id INT,                   -- Foreign key linking to the Orders table
    product_id INT,                 -- Foreign key linking to the Products table
    quantity INT,                   -- Number of units of the product ordered
    total_price DECIMAL(10, 2),     -- Total price for the product (price * quantity)
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),  -- Foreign key constraint linking to Orders table
    FOREIGN KEY (product_id) REFERENCES Products(product_id)  -- Foreign key constraint linking to Products table
);

-- Insert data into the Customers table
INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2023-01-15'),  -- Customer 1
(2, 'Jane', 'Smith', 'jane.smith@email.com', '2023-02-10'),  -- Customer 2
(3, 'Alice', 'Johnson', 'alice.johnson@email.com', '2023-03-05');  -- Customer 3

-- Insert data into the Products table
INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 999.99),   -- Product 1
(2, 'Headphones', 'Accessories', 199.99),  -- Product 2
(3, 'Smartphone', 'Electronics', 699.99),  -- Product 3
(4, 'T-shirt', 'Clothing', 19.99);     -- Product 4

-- Insert data into the Orders table
INSERT INTO Orders VALUES
(1, 1, '2023-01-20', 1199.99),  -- Order 1: Customer 1 purchased a Laptop and Headphones
(2, 2, '2023-02-12', 899.99),   -- Order 2: Customer 2 purchased a Smartphone
(3, 3, '2023-03-10', 719.98);   -- Order 3: Customer 3 purchased a T-shirt (2 units)

-- Insert data into the Order_Items table
INSERT INTO Order_Items VALUES
(1, 1, 1, 1, 999.99),   -- Order 1, Item 1: 1 Laptop purchased
(2, 1, 2, 1, 199.99),   -- Order 1, Item 2: 1 Headphone purchased
(3, 2, 3, 1, 699.99),   -- Order 2, Item 1: 1 Smartphone purchased
(4, 3, 4, 2, 39.98);    -- Order 3, Item 1: 2 T-shirts purchased


-- Query: total sales by category
-- This query calculates the total sales for for each product category(e.g Electronics, Accessories, etc)
SELECT p.category, SUM(oi.total_price) AS total_sales	-- Group by category and calculate the total sales
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id		-- Join Order_Items and Products table on product_id
GROUP BY p.category			-- Group by product category
ORDER BY total_sales DESC;	-- Order by total sales in descending order

-- Query: Most purchased product
-- This query identifies which product was purchased the most in terms of quantity sold
SELECT TOP 1 p.product_name, SUM(oi.quantity) AS total_quantity		-- Calculate total quantity purchased per product
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id		-- Join Order_Items and Products tables on product_id
GROUP BY p.product_name								-- Group by product name
ORDER BY total_quantity DESC;						-- Order by the total quantity in descending order

-- Query: top customers by total spending
-- This query finds the top 5 customers based on the total amaount spent
SELECT TOP 5 c.first_name, c.last_name, SUM(o.total_amount) AS total_spent	-- Calculate total spending for each customer
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id								-- Join Customers and Orders tables on customer_id
GROUP BY c.first_name, c.last_name											-- Group by customer name
ORDER BY total_spent DESC;													-- Order by total spending in descending order

-- Query: Monthly sales trend
-- This query shows how sales have been trending over time, grouped by month and year
SELECT MONTH(o.order_date) AS month, YEAR(o.order_date) AS year, SUM(o.total_amount) AS monthly_sales -- Calculate monthly sales
FROM Orders o
GROUP BY YEAR(o.order_date), MONTH(o.order_date)		-- Group by year and month of the order date
ORDER BY year DESC, month DESC;							-- Order by year and month in descending  order to see the most recent trends first