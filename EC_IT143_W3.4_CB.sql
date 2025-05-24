/*
    Title: AdventureWorks – W3.4 Create Answers
    Author: Chukwuka Bosah
    Date: 2025-05-24
    Runtime Estimate: ~5 hours

    Description:
    This SQL script answers 8 business and metadata questions using the AdventureWorks database.

    Resources Used:
    - https://stackoverflow.com/help/how-to-ask
    - https://stackoverflow.com/help/how-to-answer
    - https://www.ccl.org/articles/leading-effectively-articles/coaching-others-use-active-listening-skills/
    - https://www.sqlservertutorial.net/
    - https://learn.microsoft.com/en-us/sql/
    - https://learnsql.com/blog/

    Notes:
    - Each question is clearly labeled and includes well-formatted SQL.
*/


-- Q1. What are the top 5 products with the highest list price?
-- Original Author: Chukwuka Bosah

SELECT TOP 5 Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;



-- Q2. What are the names of all departments in the company?
-- Original Author: Chukwuka Bosah

SELECT Name
FROM HumanResources.Department;



-- Q3. Which three employees have the highest salaries? Show name and salary.
-- Original Author: Chukwuka Bosah

SELECT TOP 3 p.FirstName, p.LastName, e.Rate AS Salary
FROM HumanResources.EmployeePayHistory e
JOIN HumanResources.Employee emp ON emp.BusinessEntityID = e.BusinessEntityID
JOIN Person.Person p ON emp.BusinessEntityID = p.BusinessEntityID
ORDER BY e.Rate DESC;



-- Q4. How many orders were made in 2021, and what is the total revenue?
-- Original Author: Chukwuka Bosah

SELECT 
    COUNT(*) AS TotalOrders,
    SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2021-01-01' AND '2021-12-31';



-- Q5. Top 10 customers by amount spent in 2022
-- Original Author: Chukwuka Bosah

SELECT TOP 10 
    p.FirstName + ' ' + p.LastName AS CustomerName,
    COUNT(soh.SalesOrderID) AS NumOrders,
    SUM(soh.TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE soh.OrderDate BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY p.FirstName, p.LastName
ORDER BY TotalSpent DESC;



-- Q6. Find all territories with sales below $100,000 last year, broken down by quarter and product category.
-- Original Author: Chukwuka Bosah

SELECT 
    st.Name AS Territory,
    DATEPART(QUARTER, soh.OrderDate) AS Quarter,
    pc.Name AS ProductCategory,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE soh.OrderDate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY st.Name, DATEPART(QUARTER, soh.OrderDate), pc.Name
HAVING SUM(soh.TotalDue) < 100000;



-- Q7. Which tables contain a column named 'ProductID'?
-- Original Author: Chukwuka Bosah

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'ProductID';



-- Q8. List all views in the AdventureWorks database that include the word 'Sales'.
-- Original Author: Chukwuka Bosah

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME LIKE '%Sales%';
