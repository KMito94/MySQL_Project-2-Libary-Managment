# MySQL_Project-2-Libary-Managment
This is a library management system using MySQL


This project portrays how a normal library would function. It highlights insights a library management system and tries to identify areas of improvement. When setting a library management system for commercial use, one must ensure that there is easy traceability on the books and how profitable the library is. It also highlights which books perform better so that they can be added in the library.
We create the database,e then add four tables to the database: Issued_status, books, employees, branch and return_status 
Exploratory Analysis of the Data 
1.	Members Issued More than 2 books 
First, we look at members who have been issued with more than 2 books. In the database, 9 members have been issued with more than two books, with two members being issued with 6 books each.
2.	 Create Table as Select (CTS)
We use a select statement to query each book and how many times it has been issued.  This results in a new table, book_issued_cnt. The majority with the books have only been issued once, with just one book having been issued twice.
3.	Getting books in the Classic books 
There are 9 books in the classic book category, and they are rental between $4 and $ 8. Most of the books are available for rental.
4.	Getting The Total Income by Category 
To solve this problem, we use an inner join of the books table and the issued book table to get the total income by category. The classic category has the highest sales with a total of 10 books issued. Literary Fiction is in the worst-performing category with just 1 book issued and a total income of $6.5.
5.	Looking at the History of Registration 
Looking at the history of registration, for the past three years, the library has had only two new members; Sam and John are the newest members.
6.	Matching Employees with their Branch Manager. 
To match each employee with their manager, we do a self-join on the branch table and an inner join with the employee’s table. We determine that there are only two managers in the Employee table: Daniel Anderson and Laura Martinez.


7.	The books that are yet to be returned 
We have 20 books that are yet to be returned. From the information, we can determine who to call and how to ensure that the books are returned at the right time. The library management can also ensure that there is a limit tot the number of days.
8.	Members with Overdue books 
The library has 40 days return period, and therefore any book not returned after 40 days is considered overdue. We do a multiple join to retrieve the names of members and the book titles that are overdue. In this library management, we have a total of 20 members with overdue books.
9.	Branch Performance 
We can perform a multiple join to determine how each branch performs in terms of book rentals. We determine that branch B001 has the highest revenue of $ 111.5 and the worst performing branch is B002 with a total revenue of $ 12.
10.	Employee with the Most Books Issued 
We carry multiple joins between the employee table, issued_status and the branch table to retrieve how many books were issued to each employee. Michelle Ramirez and Laura Martinez have 6 books, which are the highest issued books, while Michael Thompson 3 three books, which are the lowest issued books for the employees.

Conclusion 
The project illustrates the application of SQL in creating and managing a library management system. It includes database setup, data manipulation, and advanced queries, providing a solid foundation for data management and analysis.





