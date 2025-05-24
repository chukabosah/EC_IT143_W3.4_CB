/*
    Title: AdventureWorks – W3.4 Create Answers
    Author: Chukwuka Bosah
    Date: 2025-05-24
    Runtime Estimate: ~5 hours

    Description:
    This SQL script answers 8 business and metadata questions using the AdventureWorks sample database.

    Resources Used:
    1. How to Ask a Good Question on Stack Overflow
       https://www.youtube.com/watch?v=YmGi6NdUet8
    2. How to Write a Good Answer on Stack Overflow
       https://www.youtube.com/watch?v=RNOM8ei08pc
    3. 24 Rules to the SQL Formatting Standard
       https://learnsql.com/blog/sql-formatting-best-practices

    Notes:
    - Each query is labeled, formatted, and documented.
    - Credit is given to the original question authors.
*/

/* 
-----------------------------------------------------------------------------------
Q1. What are the top 5 products with the highest list price?
Original Author: Piero Valencia
-----------------------------------------------------------------------------------
*/
SELECT TOP 5 
    Name, 
    ListPrice
FROM 
    Production.Product
ORDER BY 
    ListPrice DESC;


/* 
-----------------------------------------------------------------------------------
Q2. What are the names of all departments in the company?
Original Author: Jake Wheeler
-----------------------------------------------------------------------------------
*/
SELECT 
    Name
FROM 
    HumanResources.Department;


/* 
-----------------------------------------------------------------------------------
Q3. Which three employees have the highest salaries? Show their names and salary.
Original Author: Macgregor Dee Whiting
-----------------------------------------------------------------------------------
*/
SELECT TOP 3 
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    eph.Rate AS Salary
FROM 
    HumanResources.EmployeePayHistory eph
JOIN 
    HumanResources.Employee e ON eph.BusinessEntityID = e.BusinessEntityID
JOIN 
    Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
ORDER BY 
    eph.Rate DESC;


/* 
-----------------------------------------------------------------------------------
Q4. How many orders were made in 2021, and what is the total revenue?
Original Author: Jake Wheeler
-----------------------------------------------------------------------------------
*/
SELECT 
    COUNT(*) AS TotalOrders,
    SUM(TotalDue) AS TotalRevenue
FROM 
    Sales.SalesOrderHeader
WHERE 
    OrderDate BETWEEN '2021-01-01' AND '2021-12-31';


/* 
-----------------------------------------------------------------------------------
Q5. Who are the top 10 customers by total purchase amount in 2022?
Original Author: Akan Nyong
-----------------------------------------------------------------------------------
*/
SELECT TOP 10 
    p.FirstName + ' ' + p.LastName AS CustomerName,
    COUNT(soh.SalesOrderID) AS NumberOfOrders,
    SUM(soh.TotalDue) AS TotalSpent
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN 
    Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE 
    soh.OrderDate BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY 
    p.FirstName, p.LastName
ORDER BY 
    TotalSpent DESC;


/* 
-----------------------------------------------------------------------------------
Q6. Which territories had sales below $100,000 in 2024, 
    broken down by quarter and product category?
Original Author: Akan Nyong
-----------------------------------------------------------------------------------
*/
SELECT 
    st.Name AS Territory,
    DATEPART(QUARTER, soh.OrderDate) AS Quarter,
    pc.Name AS ProductCategory,
    SUM(soh.TotalDue) AS TotalSales
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
JOIN 
    Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
JOIN 
    Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN 
    Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE 
    soh.OrderDate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 
    st.Name, DATEPART(QUARTER, soh.OrderDate), pc.Name
HAVING 
    SUM(soh.TotalDue) < 100000;


/* 
-----------------------------------------------------------------------------------
Q7. Which tables contain a column named 'ProductID'?
Original Author: Piero Valencia
-----------------------------------------------------------------------------------
*/
SELECT 
    TABLE_SCHEMA, 
    TABLE_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    COLUMN_NAME = 'ProductID';


/* 
-----------------------------------------------------------------------------------
Q8. Which views contain the word 'Sales' in their name?
Original Author: Akan Nyong
-----------------------------------------------------------------------------------
*/
SELECT 
    TABLE_SCHEMA, 
    TABLE_NAME
FROM 
    INFORMATION_SCHEMA.VIEWS
WHERE 
    TABLE_NAME LIKE '%Sales%';
