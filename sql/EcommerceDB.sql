CREATE DATABASE EcommerceDB;
SHOW DATABASES;
USE EcommerceDB;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    city VARCHAR(100)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY(customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Products(
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE Order_Items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY(order_id) REFERENCES Orders(order_id),
    FOREIGN KEY(product_id) REFERENCES Products(product_id)
);


INSERT INTO Customers(name, email, city) VALUES
("Shyam", "shyam.gupta@gmail.com", "Noida"),
("Rahim", "rahim.gupta@gmail.com", "Delhi"),
("Ram", "ram.gupta@gmail.com", "Chandigarh");

INSERT INTO Products (product_name, category, price) VALUES
('Laptop', 'Electronics', 800.00),
('Smartphone', 'Electronics', 700.00),
('Mouse', 'Accessories', 25.00),
('Keyboard', 'Accessories', 40.00);

INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-10', 825.00),
(2, '2024-02-15', 1400.00),
(3, '2024-03-05', 740.00);

INSERT INTO Order_Items (order_id, product_id, quantity, price) VALUES
(3, 1, 1, 800.00),
(3, 3, 1, 25.00),
(4, 2, 2, 700.00),
(5, 4, 1, 40.00),
(4, 2, 1, 700.00);

SET SQL_SAFE_UPDATES = 0;
ALTER TABLE Customers AUTO_INCREMENT = 0;


-- Inner Join
SELECT Customers.customer_id, Customers.name, Orders.order_id, Orders.order_date
FROM Customers
INNER JOIN Orders ON Customers.customer_id = Orders.customer_id;

-- Left Join
SELECT Customers.customer_id, Customers.name, Orders.order_id, Orders.order_date
FROM Customers
LEFT JOIN Orders ON Customers.customer_id = Orders.customer_id;

-- Right Join
SELECT Customers.customer_id, Customers.name, Orders.order_id, Orders.order_date
FROM Customers
RIGHT JOIN Orders ON Customers.customer_id = Orders.customer_id;

-- Full Outer Join (Using UNION)
SELECT Customers.customer_id, Customers.name, Orders.order_id, Orders.order_date
FROM Customers
LEFT JOIN Orders ON Customers.customer_id = Orders.customer_id
UNION
SELECT Customers.customer_id, Customers.name, Orders.order_id, Orders.order_date
FROM Customers
RIGHT JOIN Orders ON Customers.customer_id = Orders.customer_id;

-- Cross Join
SELECT Customers.name, Customers.customer_id, Orders.order_id, Orders.total_amount
FROM Customers
CROSS JOIN Orders;

DESCRIBE Customers;
