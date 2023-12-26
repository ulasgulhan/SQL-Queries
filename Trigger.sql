--Trigger

--If you want certain actions to be automatically triggered when an insert, update, or delete operation is performed on a table, you achieve this using a trigger.

--There are two virtual tables that assist us in these operations: "inserted" and "deleted."

--These tables have the same structure as the base table on which the trigger is defined. Thus, we can obtain an inserted record from the INSERTED table and a deleted record from the DELETED table. When updating a record (in update operations), INSERTED and DELETED tables are used. There is no "updated" table.

--There are two types of triggers:

--They are divided into DDL (DATA DEFINITION LANGUAGE) and DML (DATA MANIPULATION LANGUAGE) triggers.

--DML Triggers are further divided into After and Instead of.

--AFTER Trigger: Activated after the operation (insert, update, delete) is performed.
--Instead of: The operation on the table or view does not actually occur; records are only added to the Inserted and Deleted tables.

--Example triggers:

--A trigger that reduces the stock quantity when an order is placed for a product
--In the SELECT section, capturing the ID and quantity of the most recently added product (from the inserted table)

CREATE TRIGGER trg_SiparisEklendi ON [Order Details]
AFTER INSERT
AS
     DECLARE @kacAdet INT, @hangiUrunID INT;
     SELECT @hangiUrunID = ProductID,
            @kacAdet = Quantity
     FROM inserted;
     UPDATE Products
       SET
           UnitsInStock-=@kacAdet
     WHERE ProductID = @hangiUrunID;

	
INSERT INTO [Order Details]
(ProductID,
 Quantity,
 OrderID,
 UnitPrice
)
VALUES
(3,
 5,
 10248,
 10
);

--A trigger that adds back the quantity to stock when an order is deleted

CREATE TRIGGER trg_SiparisSilindi ON [order details]
AFTER DELETE
AS
     DECLARE @kacAdet INT, @hangiUrunID INT;
     SELECT @hangiUrunID = ProductID,
            @kacAdet = Quantity
     FROM deleted;
     UPDATE Products
       SET
           UnitsInStock+=@kacAdet
     WHERE ProductID = @hangiUrunID;



DELETE FROM [Order Details]
WHERE OrderID = 10248
      AND ProductID = 3;

--A trigger that updates the stock quantity when the quantity of a product in an order changes

create trigger trg_SiparisGuncellendi on [Order Details]
after Update
as
declare @eskiAdet int, @yeniAdet int , @urunID  int;

select @eskiAdet=Quantity
from deleted;

select @yeniAdet=Quantity,@urunID=ProductID
from inserted;

update Products
set
UnitsInStock +=@eskiAdet-@yeniAdet
where ProductID = @urunID;


select * from [Order Details]
select * from Products

update [Order Details] set Quantity=22 where OrderID=10248 and ProductID=11;

alter table Employees
add isDeleted int;


select * from Employees

--Instead of trigger:
--When deleting an employee from the Employees table, instead of actually deleting the employee (because their ID information is present in other tables), we create a column named "isDeleted" in the Employees table. Now, when we want to delete an employee, we update the "isDeleted" column to 1 instead of physically deleting the employee.


CREATE TRIGGER trg_CailsanKovuldu ON Employees
INSTEAD OF DELETE
AS
     DECLARE @kovulanID INT;
     SELECT @kovulanID = EmployeeID
     FROM deleted;
     UPDATE Employees
       SET
           isDeleted = 1
     WHERE EmployeeID = @kovulanID;

delete from Employees where EmployeeID=9;

--Trigger for formatting the phone number (02122345678 to 0(212)234-56-78) when inserting into the Shippers table.

CREATE TRIGGER trg_KargoEkle ON shippers
INSTEAD OF INSERT
AS
     DECLARE @kargoAdi NVARCHAR(50), @telefon NVARCHAR(50);
     SELECT @kargoAdi = CompanyName,
            @telefon = Phone
     FROM inserted;
     DECLARE @yeniTelefon NVARCHAR(50);
     SET @yeniTelefon = LEFT(@telefon, 1)+'('+SUBSTRING(@telefon, 2, 3)+')'+SUBSTRING(@telefon, 5, 3)+'-'+SUBSTRING(@telefon, 8, 2)+'-'+RIGHT(@telefon, 2);
     INSERT INTO Shippers
     (CompanyName,
      Phone
     )
     VALUES
     (@kargoAdi,
      @yeniTelefon
     );

	select * from Shippers
	insert into Shippers values ('Aras Kargo','02122345678')






