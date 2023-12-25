/*Join: When querying data from multiple tables, Join statements are used. The data from tables that are related to each other can be combined using Join to bring all the data together. You can Join tables using the Primary Key in one table and the corresponding Foreign Key ID field in another table.
Example: Relationship between the Products table and the Categories table.
Primary Key: The primary key in the Categories table is categoryID. Each category can only be listed once.
Foreign Key: The foreign key in the Products table is CategoryId. Each product in this table has a category. A category can be used multiple times.*/

select ProductName,CategoryName from Products
join Categories on Products.CategoryID = Categories.CategoryID

-----------------------------------------------------

--Which supplier provides which product?

select S.CompanyName,P.ProductName from Suppliers S
join Products P on S.SupplierID=P.SupplierID
------------------------------------------------------

--Left Outer Join - Retrieves all records from the table on the left in the query. Only the related records from the table on the right are retrieved.

select (E1.FirstName+' '+E1.LastName) as Employee,
(E2.FirstName+' '+e2.LastName) as Employer from Employees E1
left outer join Employees E2 on E1.ReportsTo = E2.EmployeeID

--Right Outer Join - Retrieves all records from the table on the right in the query. Only the related records from the table on the left are retrieved.

select ProductName,CategoryName from Categories
right join Products on Categories.CategoryID = Products.CategoryID

--Full Join: Retrieves all records from both tables.

select ProductName,CategoryName from Categories
full join Products on Categories.CategoryID=Products.CategoryID

--Customers who haven't placed orders?
select CompanyName, Address, OrderId from Customers
left join Orders on Orders.CustomerID = Customers.CustomerID
where OrderID is Null
--How are my sales by product?

select P.ProductName, sum(OD.Quantity) as Quantity, sum(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) as Income from Products as P
join [Order Details] as OD on OD.ProductID = P.ProductID
group by P.ProductName
order by 3 Desc

--Sales by product categories?

select C.CategoryName, Sum(OD.Quantity*Od.UnitPrice) as Income from Categories as C
join Products as P on C.CategoryID=P.CategoryID
join [Order Details] as OD on Od.ProductID=P.ProductID
group by C.CategoryName
order by 2 Desc

--How much payment has been made to each shipping company?

select S.CompanyName,
Sum(O.Freight) as [Payed Price] from Shippers as S
join Orders as O On S.ShipperID=O.ShipVia
group by S.CompanyName

--Who is my most valuable customer?

select Top 1 C.CompanyName, Sum(Quantity) As Quantity, Sum(OD.Quantity*Od.UnitPrice) as Income from Customers as C
join Orders as O on C.CustomerID=O.CustomerID
join [Order Details] as OD on O.OrderID=OD.OrderID
group by C.CompanyName
order by 3 desc

--How much have I sold from the products I purchased from each supplier?

select S.CompanyName, P.ProductName, Sum(Od.Quantity) as Quantity, Sum(Od.Quantity*Od.UnitPrice) as Income from Suppliers as S
join Products as P on S.SupplierID =P.SupplierID
join [Order Details] as OD on P.ProductID =OD.ProductID
group by S.CompanyName, P.ProductName
order by 3 desc

--Details of each order:
--Which customer placed it?
--Which employee took it?
--On which date?
--Which shipping company sent it?
--At what price was it bought?
--Which category does the product belong to?
--Which supplier provided this product?

select o.OrderID, c.CompanyName, (e.FirstName+' '+e.LastName) as Employee, o.OrderDate, s.CompanyName, p.ProductName, o.ShippedDate,
od.Quantity, od.Quantity*od.UnitPrice*(1-od.Discount) as Discounted, ca.CategoryName, su.CompanyName
from Employees as e
join orders as o on o.EmployeeID = e.EmployeeID
join Customers as c on c.CustomerID=o.CustomerID
join Shippers as s on s.ShipperID=o.ShipVia
join [Order Details] as od on o.OrderID=od.OrderID
join Products as p on p.ProductID=od.ProductID
join Categories as ca on ca.CategoryID=p.CategoryID
join Suppliers as su on su.SupplierID=p.SupplierID
