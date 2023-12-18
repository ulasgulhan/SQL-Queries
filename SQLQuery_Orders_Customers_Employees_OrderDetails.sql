select * from Orders
go

select * from Customers
go

select * from Employees
go

select * from [Order Details]
go

select dbo.Customers.CompanyName [Company Name], dbo.Customers.ContactName [Company Contact Name], CONCAT(dbo.Employees.TitleOfCourtesy, ' ',dbo.Employees.FirstName, ' ',dbo.Employees.LastName) as [Full Name],
dbo.Employees.Title, dbo.[Order Details].UnitPrice
from dbo.Orders
left join dbo.Customers on dbo.Orders.CustomerID = dbo.Customers.CustomerID
left join dbo.Employees on dbo.Orders.EmployeeID = dbo.Employees.EmployeeID
left join dbo.[Order Details] on dbo.Orders.OrderID = dbo.[Order Details].OrderID
where UnitPrice > 15
