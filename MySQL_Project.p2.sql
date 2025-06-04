-- Library Management  System Project 2

CREATE DATABASE library_p2;

-- Creating the branvh Table

-- DROP TABLE IF EXISTS branch
CREATE TABLE branch
	(
		branch_id VARCHAR (10) PRIMARY KEY,
        manager_id VARCHAR (10),
        branch_address VARCHAR (55),
        contact_no VARCHAR(10) 
	);
ALTER TABLE branch
MODIFY  COLUMN contact_no VARCHAR(25);

DROP TABLE IF EXISTS employees ;
CREATE TABLE employees 
	(	emp_id VARCHAR (10) PRIMARY KEY,
		emp_name VARCHAR (25),
		position VARCHAR (15),
        salary INT,
		branch_id VARCHAR (25)
	);
    
CREATE TABLE books 
	(
		isbn VARCHAR (20) PRIMARY KEY,
        book_title VARCHAR (15),
        category VARCHAR (10),
        rental_price FLOAT,
        status VARCHAR (15),
        author VARCHAR (35),
        publisher VARCHAR (55)
    
    );
    

    
ALTER TABLE books
MODIFY  COLUMN category VARCHAR(25);

ALTER TABLE books
MODIFY  COLUMN book_title VARCHAR(75);
    
CREATE TABLE members 
	( 	member_id VARCHAR (20) PRIMARY KEY,
		member_name VARCHAR (25),
        member_address VARCHAR (75),
        reg_date DATE 
    
    );
    
CREATE TABLE issued_status
	( 	issued_id VARCHAR (10) PRIMARY KEY,
		issued_member_id VARCHAR (10),
        issued_book_name VARCHAR (75),
        issued_date DATE,
        issued_book_isbn VARCHAR (25),
        issued_emp_id VARCHAR (10)
    );
    
CREATE TABLE return_status 
	(	return_id VARCHAR (10) PRIMARY KEY,
		issued_id VARCHAR (10),
        return_book_name VARCHAR(75),
        return_date DATE,
        return_book_isbn VARCHAR (20)
    ) ;
-- FOREIGN KEY 
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members (member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books (isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees (emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch (branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status (issued_id);


SELECT * FROM issued_status;
SELECT * FROM books;
SELECT * FROM employees;
SELECT * FROM branch;
SELECT * FROM return_status;

-- Project Task
-- Task 1. Create a New Book Record -- 978-1-60129-456-2', 
-- 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

INSERT INTO books (isbn, book_title,category, rental_price, status,author,publisher)
VALUES ('978-1-60129-456-2', 
'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Task 2 : Update an Existing Member's Address 
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

-- Task 3 : Delete a Record from Issued Status Table 

DELETE FROM issued_status
WHERE issued_id = 'IS121';

-- Task 4 : Retrieve All Books Issued by a Specific Employee 

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';

-- Task 5 : List Members Who Have Issued More Than One Book 

SELECT
	issued_emp_id,
    COUNT(*) as No_of_books_Issued
FROM issued_status
GROUP BY 1 
HAVING COUNT(*) > 1;

-- 3. CTAS (Create Table as Select )
-- Task 6 : Create SUmmary Tables :
-- Used CTAS to generate new tables baseed on query results - each book and total book_issued_cnt

CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;




SELECT * FROM book_issued_cnt;

-- Task 4 : Data Analysis : 
-- Task 7: Select all books in specific category 
SELECT * FROM books
WHERE category = 'Classic';

-- Task 8 : Find the total Income by  Category 

SELECT * FROM books;

SELECT b.category, SUM(b.rental_price) as Total_Income,
COUNT(*) as total_count
FROM issued_status as ist
JOIN 
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1
ORDER BY SUM(rental_price) DESC;
 
 -- Task 9 : List Members Who Registered in the Last 3 Years  
 
 SELECT * 
 FROM members
  WHERE reg_date >= date_sub(curdate(), INTERVAL 1096 DAY); 
  
  -- Task 10 : List Employees with Their Branch Manager's Name and Their branch details 
  
SELECT 
	e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN
branch as b
ON e1.branch_id = b.branch_id
JOIN
employees as e2
ON e2.emp_id = b.manager_id;

-- Task 11 : Create a Table of Expensive Books 

CREATE TABLE Expensive_books  AS 
SELECT * FROM books 
WHERE rental_price > 7.00 ;

SELECT * FROM Expensive_books;

-- Task 12 : Retrieve the List of Books Not Yet Returned 
SELECT * FROM issued_status as ist
LEFT JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id 
WHERE rs.return_id IS NULL;

/*
Task 13 : Identify Members with Overdue Books
The return period is 40-day return period. Display member's_id,
member's name, book title, issue date and days overdue.
*/

-- This has multiple joins 
-- issued_status == members == books == return_status
-- filter books which are returned
-- overdue >40 

SELECT 
	ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    DATEDIFF('2024-05-24',ist.issued_date) as overdue_days
FROM issued_status ist 
JOIN
members as m
ON m.member_id = ist.issued_member_id
JOIN 
books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL
AND (DATEDIFF('2024-05-24',ist.issued_date)) >40

ORDER BY 1

 ;

/*
Task 14 : Branch Performance Report 
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.*
*/
CREATE TABLE branch_reports
	as
SELECT 
	b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_books_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_status as ist
JOIN 
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN 
branch as b
ON e.branch_id= b.branch_id
LEFT JOIN
return_status as rs
ON
rs.issued_id = ist.issued_id
JOIN
books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1,2;

SELECT * FROM branch_reports;

/*
Task 16 : Create a Table of ACtive Members 
Use the CREATE TABLE AS (CTAS) statement 
to create a new table active_members 
containing members who have issued at 
least one book in the last 2 months.
*/

SELECT*, 
	issued_member_id,issued_date
FROM issued_status
WHERE DATEDIFF('2024-08-13',issued_date ) >= 60;


SELECT Max(issued_date)
	FROM issued_status;
    
/*
Task 17 : Find Employees with the Most Book Issues Processed 
Write a query to find the top 3 employees who have
processed the most books issues. Diplay the employee 
name, number of books processed , and their branch.
*/
SELECT 
	e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN
employees as e
ON
e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1,2
ORDER BY COUNT(ist.issued_book_isbn) DESC;
