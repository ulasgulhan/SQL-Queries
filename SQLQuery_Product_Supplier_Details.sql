select ProductName, dbo.Categories.CategoryName, dbo.Suppliers.CompanyName, dbo.Suppliers.ContactName, dbo.Suppliers.ContactTitle, 
dbo.Suppliers.Phone, dbo.Suppliers.City 
from Products
left join dbo.Categories on dbo.Products.CategoryID = dbo.Categories.CategoryID
left join dbo.Suppliers on dbo.Products.SupplierID = dbo.Suppliers.SupplierID
where dbo.Suppliers.City = 'London'