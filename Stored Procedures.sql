--Stored Procedures
--Stored Procedures are queries held on the server side that are compiled once and do not need recompilation.
--When clients call the procedure, they expect the result of the operations to be performed on the server, not on their own computers.
--Stored Procedures can contain parameters.
--They can be assigned as scheduled tasks.
--They are compiled only the first time they are executed. Subsequent executions are faster because they are not recompiled.
--After executing an INSERT query with a Stored Procedure, it automatically allows a SELECT query to reflect the changes, providing a convenient and efficient method.
--They do not burden network traffic. They are written as parameterized to protect against injections, providing security. They are similar to Views in terms of software but do not take parameters like Views.
--They are SQL Server components that produce a result at runtime with the compilation at execution time for the operations prepared with T-SQL commands, providing automatic parameterization for your queries.
--They can be shared among applications.
--They can be defined as jobs and scheduled.
--They provide secure access to database objects.
--They ensure secure data modification.
use master
--For editing, instead of "CREATE," we can use the "ALTER" keyword to make modifications.
Create PROCEDURE sp_CalisanlariListeler--to create procedure
AS
	BEGIN
		SELECT FirstName,
			   LastName,
			   Title
		 FROM Employees
	END;

-- To execute a stored procedure

execute sp_CalisanlariListeler

-- To delete a stored procedure

drop procedure sp_CalisanlariListeler

-- A stored procedure that retrieves all products for each category

CREATE PROC sp_UrunlerVeKategoriler
AS
	BEGIN
		SELECT ProductName,
			   CategoryName 
		FROM Categories
		JOIN Products ON Categories.CategoryID= Products.CategoryID
	END;

exec sp_UrunlerVeKategoriler
drop proc sp_UrunlerVeKategoriler

-- Passing parameters to stored procedures

CREATE PROC sp_UrunKategori @id INT
AS
	BEGIN
		SELECT ProductName,
			   CategoryName 
		FROM  Categories
			JOIN Products ON Products.CategoryID=Categories.CategoryID
		WHERE Categories.CategoryID = @id
	END;

exec sp_UrunKategori 5;
exec sp_UrunKategori @id=8
drop proc sp_UrunKategori

-- To list employees by first and last name

CREATE PROC sp_Calisan @ad NVARCHAR(10), @soyad NVARCHAR(20)
AS
	BEGIN
		SELECT * FROM Employees
			WHERE FirstName= @ad AND LastName= @soyad
	END;

exec sp_Calisan @ad='Nancy' , @soyad='Davolio'
exec sp_Calisan 'Nancy','Davolio'

-- To alter a procedure (Used for making changes on a stored procedure)

ALTER PROC sp_Calisan @ad NVARCHAR(10), @soyad NVARCHAR(20)
AS
	BEGIN
		SELECT FirstName,LastName,HireDate,Title
		FROM Employees
		WHERE FirstName = @ad
		AND LastName = @soyad
	END;

--User Defined Function
-- User Defined Functions (UDFs) can be used within queries, while Stored Procedures (SPs) encapsulate their own queries.

-- UDF calculating VAT (Value Added Tax)

CREATE FUNCTION KDVHesapla
(
	@fiyat MONEY
)
RETURNS MONEY
	BEGIN
		RETURN @fiyat *1.08;
	END;

SELECT ProductName,
	   CategoryName,
	   UnitPrice,
	   dbo.KDVHesapla(UnitPrice) as [KDV Dahil Fiyat] 
FROM Products
	JOIN Categories ON Products.CategoryID = Categories.CategoryID

-- UDF calculating ages of individuals

CREATE FUNCTION YasHesapla
(
	@DogumTarihi DATETIME
)
RETURNS INT
	BEGIN
		RETURN CAST(YEAR(GETDATE())-YEAR(@DogumTarihi) as INT);
	END;

SELECT FirstName,
	   dbo.YasHesapla(BirthDate) As Age
FROM Employees

ALTER FUNCTION YasHesapla
(
	@DogumTarihi DATETIME
)
RETURNS INT
	BEGIN
		DECLARE @yas INT
		SET @yas=DATEDIFF(YY,@DogumTarihi,GETDATE())
		return @yas
	END;


-- Table-Valued Functions
-- They can receive parameters from outside.
-- They do not have BEGIN-END.

CREATE FUNCTION CalisanBilgileriniGetir
(
	@employeeID INT
)
RETURNS TABLE
	RETURN
	SELECT * FROM Employees
	WHERE EmployeeID = @employeeID;

SELECT * FROM CalisanBilgileriniGetir(5);

-- Trigger
-- If you have operations that you want to automatically execute when an insert, update, or delete operation is performed on a table, you achieve this using triggers.
-- Two virtual tables assist us in these operations: "inserted" and "deleted."
-- These tables have the same structure as the base table defined in the trigger. So, we can obtain an inserted record from the "inserted" table and a deleted record from the "deleted" table. When updating a record (in update operations), we utilize both the "inserted" and "deleted" tables. There is no "updated" table.
-- There are two types of triggers:
-- DDL (DATA DEFINITION LANGUAGE) and DML (DATA MANIPULATION LANGUAGE) triggers.
-- DML triggers are further divided into After and Instead Of triggers.
-- After Trigger: It activates after the insert, update, or delete operation.
-- Instead Of: The operation on the table or view itself does not occur; only records are added to the "inserted" and "deleted" tables.

-- Trigger to reduce stock quantity when an order is placed for a product

CREATE TRIGGER trg_SiparisEklendi on [Order Details]
AFTER INSERT
AS
	DECLARE @kacAdet INT, @hangiUrunID INT;
	SELECT @hangiUrunID = ProductID,
		   @kacAdet = Quantity
	FROM inserted;
	UPDATE Products
	SET
		UnitsInStock-=@kacAdet
	WHERE ProductID=@hangiUrunID

INSERT INTO [Order Details]
(
	ProductID,
	Quantity,
	OrderID,
	UnitPrice
)
VALUES
(
	3,
	5,
	10248,
	10
);

-- Trigger to add back stock quantity when an order is deleted

CREATE TRIGGER trg_SiparisSilindi ON [Order Details]
AFTER DELETE
AS
	DECLARE @kacAdet INT, @hangiUrunID INT;
	SELECT @hangiUrunID= ProductID,
		   @kacAdet= Quantity 
	FROM deleted;
	UPDATE Products
		SET 
			UnitsInStock+=@kacAdet
		WHERE ProductID = @hangiUrunID;

DELETE FROM [Order Details]
WHERE OrderID = 10248 
	AND ProductID = 3;

-- Trigger to update stock quantity based on changes in the quantity of products in an order

CREATE TRIGGER trg_SiparisGuncellendi on [Order Details]
AFTER UPDATE
AS
	DECLARE @eskiAdet INT, @yeniAdet INT, @urunID INT;
	SELECT @eskiAdet = Quantity
	from deleted;

	SELECT @yeniAdet = Quantity, @urunID=ProductID 
	from INSERTED;

	UPDATE Products 
	SET
	UnitsInStock += @eskiAdet-@yeniAdet
	WHERE ProductID=@urunID;

UPDATE [Order Details] set Quantity = 22 WHERE OrderID=10248 and ProductID=11;

select * from [Order Details]
select * from Products

/*
Temporal Table is a feature introduced with SQL Server 2016 primarily to track changes in DML (Update, Delete) operations. 
Temporal tables are also known as system-versioned tables. Temporal tables store the history of data along with the data itself, 
preserving versions based on the modification date.

A Temporal table consists of two tables. The first table is the system-versioned table, which is designed for tracking and querying the actual data. 
The current data is stored in this table. The second table is the history table, which contains the changes made to the data. In other words, 
the modifications made in the system-versioned table are stored in the history table.
*/
--We are creating a database named TemporalDb.

create database TemporalDb
use TemporalDB

drop database TemporalDb

CREATE TABLE URUN1
(
	ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Adi NVARCHAR(50),
	Fiyati Money,
	StokMiktari SMALLINT,
	RowStart DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	RowEnd DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME(RowStart, RowEnd)
)WITH(SYSTEM_VERSIONING = ON(HISTORY_TABLE = dbo.URUN1History))

insert into URUN1(Adi,Fiyati,StokMiktari) 
VALUES 
('A Ürünü',750,10),
('B Ürünü',750,20),
('C Ürünü',750,30)

select * from URUN1

select * from dbo.Urun URUN1History


/*Live Query Statistics is one of the performance features introduced with SQL Server 2016. It allows us to monitor our query's execution plan in real-time, presenting live updates that differ from the Actual Plan. This feature enables us to track the progress of our query, observe the number of rows read, and monitor the completion status of different portions of the query.
*/

--Before executing the query, you can access this screen by right-clicking and selecting "Live Query Statistics."

select* From Products

--Live Query Statistics


--This is one of the performance features introduced with SQL Server 2016. It presents our query's execution plan to us in real-time, unlike the Actual Execution Plan. With this feature, we can monitor our query, see the number of rows read, and observe how much of the query has been completed.

--Before running the query, you can access this screen by right-clicking and selecting "Live Query Statistics."

select * from Products

select * from Orders o inner join Customers c on o.CustomerID=c.CustomerID

select * from Orders cross join Customers

--When examining the live query statistics window in the Resultset, the ribbon-like lines show us that the query is still running, and simultaneously, we can see the real-time count of rows read and its cost.



--Dynamic Data Masking

--One of the security measures introduced with SQL Server 2016 is data masking. It allows showing data to SELECT users by masking it without breaking it (without encryption). There are three functions used for data masking.
--Default
--Email
--Partial

create database DynamicDataMasking
go

use DynamicDataMasking

create table Kullanicilar(
ID int primary key identity(1,1),
Adi nvarchar(50),
Soyadi nvarchar(50),
KullaniciAdi nvarchar(50),
Sifre nvarchar(50),
KayitTarihi datetime default(getdate()),
Yasi int
)

alter table Kullanicilar
add Email nvarchar(50)

insert Kullanicilar(Adi,Soyadi,KullaniciAdi,Sifre,Yasi,Email)
values
('Ekrem','Keleþ','ekeles','123',27,'ekeles@hotmail.com'),
('Ekrem2','Keleþ2','ekeles2','12345',28,'ekeles2@gmail.com'),
('Osman','Türker','oturker','12',78,'oturker@yahoo.com'),
('Test','Testoðlu','testo','1234',56,'testo@testo.com')



--When we perform a SELECT on the table, we see the data without any masking.

select * from Kullanicilar

--Important: To view query results, we create a user and grant only SELECT permission. The masking method will enable SELECT users to see the data in a masked form.

--User creation process

create user Ekrem without login

--Granting select privilege

grant select on Kullanicilar to Ekrem

--Masking with default function
--With the default masking method, string fields are displayed as 'xxxx', and numerical fields are displayed as '0'.

alter table Kullanicilar
alter column KullaniciAdi add masked with (function='default()')

--Working with the user 'Ekrem'

execute as user ='Ekrem'

--Exiting from the user 'Ekrem'

revert

