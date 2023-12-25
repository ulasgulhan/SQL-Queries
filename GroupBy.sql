------------
--Group BY--
------------
/*We use GROUP BY to consolidate queries. When an aggregate function is used and there are multiple columns in the SELECT statement, the query needs to be grouped. If you want to display another column besides the one used in the aggregation function, you must use the GROUP BY clause. For example, if you want to get the totals of products and only need the total value, you can use an aggregate function to find the sum. However, if you also want to see the names of the products, SQL Server will prompt you to decide if you want to group the products separately based on their names, and you should use the GROUP BY clause accordingly. Aggregate functions have the ability to operate on multiple rows. When used alone, they return a single-row, single-column result.*/

--How much do our customer's orders weigh

select OrderID, 
	ROUND(SUM((1-Discount)*Quantity*UnitPrice),2) Ýndirimli 
		from [Order Details]
		group by OrderID
		order by Ýndirimli Desc

--The number of orders fulfilled by employees

select EmployeeID, Count(*) as [Order Count] from Orders
group by EmployeeID

--Grouping products by their categories where the price is less than $35.

select CategoryID, COUNT(*) as [Total] from Products
where UnitPrice < 35
group by CategoryID

--List products whose names start with a letter between A and K, and their stock quantity is between 5 and 50, in descending order by their categories.

select CategoryID, count(*) as [Total] from Products
where (ProductName like '[A-K]%')
and (UnitsInStock between 5 and 50)
group by CategoryID
order by Total Desc

--List each order in descending order by its total amount.

select OrderId, SUM(UnitPrice*Quantity*(1-Discount)) as [Total Order Price] from [Order Details]
group by OrderID
order by SUM(UnitPrice*Quantity*(1-Discount)) Desc


--Number of products in each order.

select OrderID, sum(Quantity) as [Sold Products] from [Order Details]
group by OrderID
order by [Sold Products] Desc

--Usage of HAVING: Instead of using the WHERE clause, the HAVING keyword is employed to filter the result set based on aggregate functions applied to the query result.

--Sorting orders with a total amount between 2500 and 3500.

select OrderID as [Order Code],
Sum(Quantity*UnitPrice*(1-Discount)) as [Total Price] from [Order Details]
Group by OrderID
Having SUM(Quantity*UnitPrice*(1-Discount)) between 2500 and 3500

--Orders with a total product quantity exceeding 200.

select OrderId, sum(Quantity) as [Total] from [Order Details]
group by OrderID
Having sum(Quantity) > 200
Order by Total Desc



--Usage of Subquery (Nested Queries)

--List of sold products in the Products table.

select * from Products P where P.ProductID In 
(
	Select OD.ProductID from [Order Details] OD
);

--Note: In subqueries, only a single column can be called at a time.

select P.ProductName,P.UnitPrice,P.UnitsInStock,(
	select C.CategoryName from Categories C
	where C.CategoryID = P.CategoryID
) as Kategoriler from Products P


--Number of orders carried by shipping companies.

select 
(
	select S.CompanyName from Shippers S
	where S.ShipperID = O.ShipVia
) as [Shipment], ShipVia,
Count(*) as [Order Count] from Orders O
group by ShipVia
