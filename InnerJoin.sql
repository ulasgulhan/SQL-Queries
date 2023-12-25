--Join Operations
--1. Inner Join: Lists each record in one table with its corresponding records in the other table. While creating the inner join expression, even if we don't explicitly write the word "inner" (just using "join" is sufficient), the inner join operation will still be performed.

select ProductName,CategoryName from Products 
inner join Categories on Products.CategoryID = Categories.CategoryID

--From the Product table, select ProductID, ProductName, CategoryID
--From the Categories table, select CategoryName, Description

select ProductID, ProductName, a.CategoryID, a.CategoryName, Description from Products
inner join Categories as a on Products.CategoryID = a.CategoryID


--Which order was made by which employee to which customer

select OrderID as [Order Id], 
	OrderDate as [Order Date],
	a.CompanyName as [Company Name],
	a.ContactName as [Contact Name],
	(FirstName+' '+LastName) as [Employee],
	Title from Orders
	inner join Customers as a on Orders.CustomerID = a.CustomerID
	inner join Employees as b on Orders.EmployeeID = b.EmployeeID



--From the Supplier table, select CompanyName, ContactName,
--From the Products table, select ProductName, UnitPrice
--From the Categories Table, select CategoryName
--Display in ascending order based on the Company Name column.

select s.CompanyName, s.ContactName, p.ProductName, p.UnitPrice, c.CategoryName from Suppliers as s
inner join Products as p on s.SupplierID = p.SupplierID
inner join Categories as c on c.CategoryID = p.CategoryID
Order by 1;