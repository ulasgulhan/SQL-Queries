set identity_insert "Products" on
go

INSERT "Products"("ProductID","ProductName","SupplierID","CategoryID","QuantityPerUnit","UnitPrice","UnitsInStock","UnitsOnOrder","ReorderLevel","Discontinued") 
VALUES(78,'Wine',18,1,'5 boxes x 10 bags',20,55,1,7,0)

set identity_insert "Products" off
go
