--Stored Procedures(Sakl� Yordam)
--Stored Procedure'ler server taraf�nda tutulan, bir kez derlendikten sonra tekrar derlemeyen sorgulard�r. 
--Client'lar prosedur� �a�r�rken kendi bilgisayarlar�nda de�il server taraf�ndan yap�lacak olan i�lemlerin sonucunu bekler.
--Parametre i�erebilir.
--Zamanlanm�� g�rev olarak atanabilirler.
--Sadece ilk �al��t�r�ld�kalr�nda derlenirler. �lk �al��mas�nda sonraki �al��malar�nda derlemedikelrinden �ok h�zl�d�rlar.
--Bir Stored Procedure ile inset sorgusu �al��t�ktan sonra select sorgusunun otomatik olarak devereye girmesini sa�lar�z, eklenen kay�tlar�n�z� da insert sonras�nda g�rm�� olursunuz, pratik ve kullan��l� bir y�ntemdir.
--Netwrok tarfi�ini yormaz. Injection'lara kar�� parametreli oalrak yaz�l�rlar, b�ylece g�venlik sa�larlar. Yaz�l�m bak�m�ndan View gibidirler ancak View'ler parametre almazlar.
--TSQL komutlar� ile haz�rlad���m�z i�lemler b�t�n�n �al��t�r�lma ana�nda derlemesi ile size bir sonu� �reten sql server bile�enleridir. �al��ma an� palnlamasa�lar ve tekrar kullan�labilir.Querylerinizde otomatik parametrelendirme gettirir.
--Uygulamalar aras�nda ortak kullan�labilir.
--Job olarak tan�mlanabilir ve schedule edililir.
--Database objelerine g�venli eri�im sa�lar.
--G�venli data modifikasyonu sa�lar.
use Northwind
--D�zenleme i�in create yerine Alter kelimesini yazarak d�zenleme yapabiliriz
Create PROCEDURE sp_CalisanlariListeler--procedure olu�turmak i�in
AS
	BEGIN
		SELECT FirstName,
			   LastName,
			   Title
		 FROM Employees
	END;

--procedure �al��t�rmak i�in
execute sp_CalisanlariListeler

--procedure silme i�lemi
drop procedure sp_CalisanlariListeler

--T�m kategorilerle, bu kategorilere ait �r�nleri getiren SP
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
--SPlere parametre aktarma
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

--ad ve soyad�na g�re �al��anlar� listeleme
CREATE PROC sp_Calisan @ad NVARCHAR(10), @soyad NVARCHAR(20)
AS
	BEGIN
		SELECT * FROM Employees
			WHERE FirstName= @ad AND LastName= @soyad
	END;

exec sp_Calisan @ad='Nancy' , @soyad='Davolio'
exec sp_Calisan 'Nancy','Davolio'

--Alter Procedure=> Procedure �zrinde de�i�iklik i�in kullan�l�r
ALTER PROC sp_Calisan @ad NVARCHAR(10), @soyad NVARCHAR(20)
AS
	BEGIN
		SELECT FirstName,LastName,HireDate,Title
		FROM Employees
		WHERE FirstName = @ad
		AND LastName = @soyad
	END;

--User Defined Function
--UDF'ler sorgu i�erisinde kullan�labilirler. Sp'ler ise kendi querylerini bar�nd�r�rlar

--KDV Hesalayan UDF
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

--Ki�ilerin ya�lar�n� hesaplayan UDF
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

ALTER FUNCTION YasHesapla--fonksiyon de�i�lik�i
(
	@DogumTarihi DATETIME
)
RETURNS INT
	BEGIN
		DECLARE @yas INT--de�i�ken tan�mlama
		SET @yas=DATEDIFF(YY,@DogumTarihi,GETDATE())--atama i�lemi set ile yap�l�r
		return @yas
	END;

--Tablo D�nd�ren Fonksiyonlar
--D��ar�dan parametre alabilirler
--Begin End Yoktur

CREATE FUNCTION CalisanBilgileriniGetir
(
	@employeeID INT
)
RETURNS TABLE
	RETURN
	SELECT * FROM Employees
	WHERE EmployeeID = @employeeID;

SELECT * FROM CalisanBilgileriniGetir(5);

--�al��anlar�n Ad�n� ba� harfine g�re listeleyen fonksiyon
CREATE FUNCTION BasHarfeGoreGetir
(
	@BasHarf NVARCHAR(1)
)
RETURNS TABLE
	RETURN
	SELECT * FROM Employees
	WHERE LEFT(FirstName, 1) = @BasHarf;

SELECT * FROM BasHarfeGoreGetir('A')

--Trigger (Tetikleyici)
--Bir tablo �zerinde insert, update, delete i�lemlerinden biri yap�ld���nda otomatik olarak devreye girmesini istedi�imiz i�lemleriniz varsa bunu trigger kullanarak ger�ekle�tiriyoruz.
--Bu i�lmelerde bize yard�mc� olacak iki tane sanal tablo vard�r.Bunlar inserted ve deleted tablolar�d�r.
--Bu tablolar trigger �zerinde tan�ml� olan base tablo ile birebir ayn� yap�dad�r.Yani girilen bir kayd� Inserted tablosundan, silinen bir kayd� Deleted tablosundan elde edediliriz. Bir kayd� g�ncellemek istedi�imiz zaman (update i�lemlerinde) Insert ve Deleted tabloalr�ndan faydalan�rz. Yani updated  diye bir tablomuz yoktur.
--Ik� tip trigger vard�r.
--DDL (DATA DEFINITION LANGUAGE) ve DML (DATA MANIPULATIN LANGUAGE) triggerlar� olmka �zere ikiye ayr�l�r.
--DML trigger'lar After ve Instead of olamk �zere ikiye ayr�l�r.
--After Trigger: Yapt���m�z i�lemden sonra (insert,update,delete) devreye girer.
--Instead Of: Tabloda veya V�ew �zerinde ki i�lem ger�ekle�mez sadece Inserted ve Deleted tablolar�nda kay�t at�l�r.

--Bir �r�nden sipari� al�n�nca bunu stok miktar�ndan d���ren trigger
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

--Sipari� silinirse, silinen adet kadar�n� sto�a geri ekleyen trigger
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

--Bir sipari� i�eriisndeki �r�n adedi de�i�ti�inde stok miktar�n�nda ona g�re g�ncelleyen trigger
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
Temporal Table: Temel oalrak DML(Update,delete) i�lemlerinde i�lemlerdeki de�i�iklikleri izlemek i�in SQL Server 2016 s�r�m�ile duyrulan bir �zelliktir. Temporal tablolar system versioned table olarakda adland�r�l�r. Temporal table verinin ge�mi�ini kendisiyle birlikte olu�turulan history tablolar da saklalar veriyi de�i�iklik tarihine g�re versiyonlar.

Bir Temporal table iki adet tablodan olu�ur. �lk tablomuz system-versioned tablosudur. �kinci tablomuz history table'd�r. 
System Versioned Tabele: Ger�ek verinin izlenmesi ve �a�r�lams� �zerine tasarlan�r. Ge�erli veri bu tabloda saklan�r
History Table: Veri �zerindeki yap�lan de�i�ikli�i i�erir. Yani system versioned table'daki yap�lan de�i�iklik history table'da depolan�yor.
*/
--TemporalDb isminde bir veritab�n� olu�turuyoruz.
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
('A �r�n�',750,10),
('B �r�n�',750,20),
('C �r�n�',750,30)

select * from URUN1

select * from dbo.Urun URUN1History

/*Live Query Statistic
SQL Server 2016 ile gelen performans �zelliklerinden birisidir. Sorgumuzdan �al��ma plan�n� Actual Plan'dan farkl� oalrak bize canl� sunmas�d�r. Bu �zellik sorgumuzu izleyebilir okunan sat�r say�s�n� g�rebilir, sorgunun ne kadarl�k k�sm�n�n�n tamamland���n� izleyebilrisiniz.
*/

--Sorguyu �al��t�rmadan �nce sa� t�k ile live query statistics i�aretini se�erek bu ekrana ula�abilrisiniz

select* From Products

--Live Query Statistics

--Sql Server 2016 ile gelen performans �zelliklerinden birisidir. Sorgumuzun �al��ma plan�n� Actual Execution Plan'dan farkl� olarak bize canl� sunmas�d�r.Bu �zellik sayesinde sorgumuzu izleyebilir okunan sat�r say�s�n� g�rebilir, sorgunun ne kadarl�k k�sm�nn�n tamamland���n� izleyebiliriz.

--Sorguyu �al��t�rmadan �nce sa� t�k ile live query statistics i�aretini se�erek bu ekrana ula�abilirsiniz.

select * from Products

select * from Orders o inner join Customers c on o.CustomerID=c.CustomerID

select * from Orders cross join Customers

--Resultset'deki live query statistics penceresini inceledi�imizde �erit halinde �izgiler bize o sorgunun hala �al��t���n� g�sterirken ayn� zamanda anl�k olarak da okunan satur say�s�n� ve maliyetini g�rebiliyoruz.


--Dynamic Data Masking

--Sql Server 2016 ile gelen g�venlik �nlemlerinden birisidir.Maskeleme y�ntemi veriyi bozmaks�z�n (�ifreleme yapmadan) select kullan�c�lar�na veriyi amskeleyerek g�sterir.Maskeleme yaparken 3 fonksiyon vard�r.

--Default
--Email
--Partial

create database DynamicDataMasking

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
('Ekrem','Kele�','ekeles','123',27,'ekeles@hotmail.com'),
('Ekrem2','Kele�2','ekeles2','12345',28,'ekeles2@gmail.com'),
('Osman','T�rker','oturker','12',78,'oturker@yahoo.com'),
('Test','Testo�lu','testo','1234',56,'testo@testo.com')


--Tabloya select yapt���m�zda verileri maskesiz g�r�yoruz..
select * from Kullanicilar

--�nemli : Sorgu sonu�lar�n� g�rebilmek i�in bir kullan�c� olu�turuyoruz ve sadece select yetkisi veriyoruz.Maskeleme y�ntemi select kullan�c�lar�n�n veriyi maskeli g�rmesini sa�layacakt�r.

--Kullan�c� olu�turma i�lemi
create user Ekrem without login

--Select yetkisi verme i�lemi
grant select on Kullanicilar to Ekrem

--Default fonksiyonu ile maskeleme
--Default maskeleme y�ntemi ile kolon maskelemede string alanlarda xxxx �eklinde , say�sal alanlarda ise 0 �eklinde g�r�nt�leme ger�ekle�ir.

alter table Kullanicilar
alter column KullaniciAdi add masked with (function='default()')

--Ekrem kullan�c�s� ile �al��mak i�in
execute as user ='Ekrem'

--ekrem kullan�c�s�ndan ��kmak i�in

revert