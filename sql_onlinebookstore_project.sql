-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
use OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\abman\OneDrive\Documents\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Users\abman\OneDrive\Documents\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Users\abman\OneDrive\Documents\Orders.csv' 
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre:
select * from books where genre='Fiction';


-- 2) Find books published after the year 1950:
select * from books where published_year>1950;


-- 3) List all customers from the Canada:
select * from customers where country='Canada';


-- 4) Show orders placed in November 2023:
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';


-- 5) Retrieve the total stock of books available:
select sum(stock) as total_stock from books;

-- 6) Find the details of the most expensive book:
SELECT * FROM books WHERE price=(select max(price) from books) ;


-- 7) Show all customers who ordered more than 1 quantity of a book:
select c.name,o.quantity from customers c join orders o on c.customer_id=o.customer_id where quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders where total_amount>20;

-- 9) List all genres available in the Books table:
select distinct genre from books;

-- 10) Find the book with the lowest stock:
select title,stock from books where stock=(select min(stock) from books) ;
select title,stock from books order by stock limit 1;

-- 11) Calculate the total revenue generated from all orders:
select sum(total_amount) as total_revenue from orders; 


-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select genre,count(*) as number_of_books_sold from books group by genre;


-- 2) Find the average price of books in the "Fantasy" genre:
select genre,avg(price) as average_price from books where genre='Fantasy' group by genre;


-- 3) List customers who have placed at least 2 orders:
select c.name,count(*) as number_of_orders from customers c join orders o on c.customer_id=o.customer_id group by c.name having count(*)>1;

-- 4) Find the most frequently ordered book:
select b.title,o.order_date from books b join orders o on b.book_id=o.book_id where o.order_date=(select max(order_date) from orders)

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select title,price from books where genre='Fantasy' order by price desc limit 3;

select * from orders
-- 6) Retrieve the total quantity of books sold by each author:
select b.author,sum(o.quantity) as books_sold from books b join orders o on b.book_id=o.book_id group by author order by books_sold desc;

-- 7) List the cities where customers who spent over $30 are located:
select c.city,c.name,o.total_amount from customers c join orders o on c.customer_id=o.customer_id where o.total_amount>30 order by total_amount desc;  

-- 8) Find the customer who spent the most on orders:
select * from customers c join orders o on c.customer_id=o.customer_id order by total_amount desc;

--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.Title, (b.Stock - o.Quantity) AS remaining_stock FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
ORDER BY remaining_stock desc;


