--Use: It is used to indicate that a database will be used.
--Queries will be active in the Northwind database. This way, you won't need to specify which database you are querying in your written queries.

/*When I do not specify the database using the 'USE' statement or when I do not select it from the Available Databases window, you can execute the query by specifying the database name along with the schema information as 'dbo'
*/
--Example:
SELECT (E.FirstName+' '+E.LastName) as [Full Name] FROM dbo.Employees E

SELECT E.FirstName,E.LastName,E.Title,E.BirthDate FROM Employees E 
--Column Naming
--Method 1

SELECT E.FirstName, E.LastName, E.Title FROM Employees E

select * INTO Calisanlar FROM Employees

UPDATE Calisanlar SET FirstName = 'Abuzer', LastName = 'Burak' WHERE EmployeeID=9

/*In queries, WHERE, AND, OR are used to select and display data based on a condition when written in the query.*/

--List the products with a unit price greater than 18.

SELECT ProductID, ProductName, CategoryID, UnitPrice, UnitsInStock FROM Products 
WHERE UnitPrice >18

SELECT * INTO urunler from Products

--List the products in the Products table with a 5% price increase.

UPDATE urunler SET UnitPrice += (UnitPrice*0.05);

--Deleted: Used to delete a record from a table. If you don't use the WHERE clause in this query, it will delete all data.

--Delete the employee with EmployeeID 8.

DELETE FROM Calisanlar WHERE EmployeeID=8

--Let's delete employees with titles "Mr." and "Dr." from the Calisanlar table.

Delete from Calisanlar where TitleOfCourtesy in('Mr.','Dr.')

--The Year function takes a value in datetime type and returns the year information within it.

--List employees in the Calisanlar table who were born in the year 1960.

select FirstName,LastName,TitleOfCourtesy from Employees
where year(BirthDate) = 1960

/*You can use the Between statement to query data between two values. The condition is specified with the Between And statement after specifying the values.*/

--List the names, last names, and birth dates of employees born between 1950 and 1961.

select FirstName, LastName, BirthDate from Employees
where YEAR(BirthDate) between 1950 and 1961

--List employees with a title of "MR." and an age greater than 60.

select * from Employees
where TitleOfCourtesy = 'MR.' and YEAR(getdate()) - YEAR(BirthDate) > 60

--Sorting Operations
--Order By: Allows you to sort the result set of a query. Asc parameter for ascending sorting, Desc parameter for descending sorting. If no parameter is used, ASC is used by default.
--Asc (Ascending) and Desc (Descending)

select e.FirstName+' '+e.LastName as [Full Name],
	CONVERT(varchar(10), e.BirthDate,104) as [Date of Birth]
	from Employees e
	Order by e.FirstName Asc

--Sort employees with IDs between 2 and 8 in ascending order.

select * from Employees
where EmployeeID between 2 and 8
order by EmployeeID Asc

--Display the name, last name, title of courtesy, and age of employees.
--Sort in descending order by age.
--Do not display if the region is null.
--Note: Represents nothing.

select FirstName, LastName, TitleOfCourtesy, YEAR(GETDATE()) - YEAR(BirthDate) as Age from Employees
where Region is Null
order by Age Desc

--Sort those with category IDs between 1 and 4 using the BETWEEN AND statement.

select * from Products
where CategoryID between 1 and 4

--List employees born between 1930 and 1960 and working in the USA.

select * from Employees
where YEAR(BirthDate) between 1930 and 1960 and Country = 'USA'

--List those born between 1952 and 1960 with their names, last names, and birth years.

select FirstName, LastName, YEAR(BirthDate) as BirthDate from Employees
where YEAR(BirthDate) between 1952 and 1960

--Or
--List those with a title of "Mr." or "Dr."

select * from Employees
where TitleOfCourtesy = 'Mr.' or TitleOfCourtesy = 'Dr.'

--List products with unit prices 18, 19, or 25.

select * from Products
where UnitPrice = 18 or UnitPrice = 19 or UnitPrice = 25

--In: Instead of multiple OR statements, you can use the In statement shortly.

--List products with unit prices of 18, 19, 25, 97, 40, or 30.

select * from Products
where UnitPrice in (18, 19, 25, 97, 40, 30)

--List those born in 1950, 1955, and 1960.

select * from Employees
where YEAR(BirthDate) in (1950, 1955, 1960)

--The top # (like top 3) command specifies how many records will be displayed on the screen first.

select top 3 * from Employees

--Top: It is a command that can be used to display a portion of the data to be listed. Instead of using a number to specify the quantity, it can be expressed as a percentage. If expressed as a percentage (like 70 percent), it can be achieved with the top 70 percent code. If it is decimal, such as 3.12, then it will be taken as 4.

select TOP 4 ProductName,UnitPrice from Products
order by UnitPrice desc

select Top 34 Percent FirstName, LastName, Title from Employees
order by FirstName desc

--With Ties Parameter: Used in conjunction with the Top function. If there are records that match the value of the last item listed, these records are also included in the listing.

select Top 12 With Ties ProductName, UnitPrice 
from Products
Order BY UnitPrice Asc

--Like: This operator is used to find "similarity." However, it should be used with special characters.

--List those named Michael.

select FirstName,LastName,Title 
from Employees
where FirstName like 'Michael'

--List those whose name starts with the letter "A."

select FirstName, LastName, Title from Employees
where FirstName like 'A%'

--Those whose name ends with the letter "N."

select FirstName, LastName, Title from Employees
where FirstName like '%N'

--Those whose name contains the letter "E."

select FirstName, LastName, Title from Employees
where FirstName like '%E%'

--List the "box" products we have.

select * from Products
where QuantityPerUnit like '%box%'

--Those whose first letter is A or L.

select FirstName, LastName, Title from Employees
where FirstName like '[AL]%'

--Those whose name contains the letters R or T.

select FirstName, LastName, Title from Employees
where FirstName like '%[RT]%'

--Those whose name starts with a letter between J and R.

select FirstName, LastName, Title from Employees
where FirstName like '[J-R]%'

--Note: "_" means one character.

--Those whose name contains A and T, and there are 2 characters between these two letters.

select FirstName, LastName, Title from Employees
where FirstName like '%A__T%'

--Those whose first letter is not M.

select FirstName, LastName, Title from Employees
where FirstName not like 'M%'

--Those whose name does not end with the letter T.

select FirstName, LastName, Title from Employees
where FirstName not like '%T'

--Those whose first letter is not between A and I.

select FirstName, LastName, Title from Employees
where FirstName like '[^A-I]%'

--Those whose second letter is not A or T.

select FirstName, LastName, Title from Employees
where FirstName like '_[^AT]%'

--We want to list customers who operate restaurants. However, customers in the city of Mexico should not be listed.

select CompanyName, Address, Country, City  from Customers
where CompanyName like '%Rest%' and Country != 'Mexico'

--Space: Represents a space character. The specified number of space characters is created as a parameter.

select FirstName+Space(1)+LastName as [Full Name]from Employees

--Null: Means nothing. It means that there is no value in a column in the table. A blank character in the table does not mean Null.

Select CompanyName, Region from Customers
where Region is null

--List records in the Customers table where the Region information is not entered.

select CompanyName,ISNULL(Region, 'Bölge Yok') as Region from Customers
where Region is null


--Type Conversions
--In some cases, you may need to convert within SQL Server. For example, you can concatenate a string data with numerical or date type data.

select * into kategori from Categories
select CONVERT(varchar(1), CategoryID)+Space(1)+CategoryName as [Full Category Name] from kategori

--Try_Convert: Performs type conversion. If successful, it returns the result; if type conversion cannot be done, it returns null.

--Cast: A function used for type conversion. It does not change the style of the value.

--Cast the Date data in the Employee table.

select FirstName+' '+LastName+' '+Cast(Year(BirthDate) as Nvarchar(4))+' doðumludur.' as [Caliþanlarýn Doðum Tarihi] from Employees 
order by BirthDate

--Try_Parse: Converts string-type data to the desired type. If successful, it returns the result; if type conversion cannot be done, it returns Null.






