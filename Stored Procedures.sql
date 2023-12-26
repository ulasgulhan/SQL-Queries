--Stored Procedures(Saklý Yordam)
--Stored Procedure'ler server tarafýnda tutulan, bir kez derlendikten sonra tekrar derlemeyen sorgulardýr. 
--Client'lar prosedurü çaðrýrken kendi bilgisayarlarýnda deðil server tarafýndan yapýlacak olan iþlemlerin sonucunu bekler.
--Parametre içerebilir.
--Zamanlanmýþ görev olarak atanabilirler.
--Sadece ilk çalýþtýrýldýkalrýnda derlenirler. Ýlk çalýþmasýnda sonraki çalýþmalarýnda derlemedikelrinden çok hýzlýdýrlar.
--Bir Stored Procedure ile inset sorgusu çalýþtýktan sonra select sorgusunun otomatik olarak devereye girmesini saðlarýz, eklenen kayýtlarýnýzý da insert sonrasýnda görmüþ olursunuz, pratik ve kullanýþlý bir yöntemdir.
--Netwrok tarfiðini yormaz. Injection'lara karþý parametreli oalrak yazýlýrlar, böylece güvenlik saðlarlar. Yazýlým bakýmýndan View gibidirler ancak View'ler parametre almazlar.
--TSQL komutlarý ile hazýrladýðýmýz iþlemler bütünün çalýþtýrýlma anaýnda derlemesi ile size bir sonuç üreten sql server bileþenleridir. Çalýþma aný palnlamasaðlar ve tekrar kullanýlabilir.Querylerinizde otomatik parametrelendirme gettirir.
--Uygulamalar arasýnda ortak kullanýlabilir.
--Job olarak tanýmlanabilir ve schedule edililir.
--Database objelerine güvenli eriþim saðlar.
--Güvenli data modifikasyonu saðlar.
use Northwind
--Düzenleme için create yerine Alter kelimesini yazarak düzenleme yapabiliriz
Create PROCEDURE sp_CalisanlariListeler--procedure oluþturmak için
AS
	BEGIN
		SELECT FirstName,
			   LastName,
			   Title
		 FROM Employees
	END;

--procedure çalýþtýrmak için
execute sp_CalisanlariListeler

--procedure silme iþlemi
drop procedure sp_CalisanlariListeler

--Tüm kategorilerle, bu kategorilere ait ürünleri getiren SP
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

--ad ve soyadýna göre çalýþanlarý listeleme
CREATE PROC sp_Calisan @ad NVARCHAR(10), @soyad NVARCHAR(20)
AS
	BEGIN
		SELECT * FROM Employees
			WHERE FirstName= @ad AND LastName= @soyad
	END;

exec sp_Calisan @ad='Nancy' , @soyad='Davolio'
exec sp_Calisan 'Nancy','Davolio'

--Alter Procedure=> Procedure üzrinde deðiþiklik için kullanýlýr
ALTER PROC sp_Calisan @ad NVARCHAR(10), @soyad NVARCHAR(20)
AS
	BEGIN
		SELECT FirstName,LastName,HireDate,Title
		FROM Employees
		WHERE FirstName = @ad
		AND LastName = @soyad
	END;

--User Defined Function
--UDF'ler sorgu içerisinde kullanýlabilirler. Sp'ler ise kendi querylerini barýndýrýrlar

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

--Kiþilerin yaþlarýný hesaplayan UDF
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

ALTER FUNCTION YasHesapla--fonksiyon deðiþlikði
(
	@DogumTarihi DATETIME
)
RETURNS INT
	BEGIN
		DECLARE @yas INT--deðiþken tanýmlama
		SET @yas=DATEDIFF(YY,@DogumTarihi,GETDATE())--atama iþlemi set ile yapýlýr
		return @yas
	END;

--Tablo Döndüren Fonksiyonlar
--Dýþarýdan parametre alabilirler
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

--Çalýþanlarýn Adýný baþ harfine göre listeleyen fonksiyon
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
--Bir tablo üzerinde insert, update, delete iþlemlerinden biri yapýldýðýnda otomatik olarak devreye girmesini istediðimiz iþlemleriniz varsa bunu trigger kullanarak gerçekleþtiriyoruz.
--Bu iþlmelerde bize yardýmcý olacak iki tane sanal tablo vardýr.Bunlar inserted ve deleted tablolarýdýr.
--Bu tablolar trigger üzerinde tanýmlý olan base tablo ile birebir ayný yapýdadýr.Yani girilen bir kaydý Inserted tablosundan, silinen bir kaydý Deleted tablosundan elde edediliriz. Bir kaydý güncellemek istediðimiz zaman (update iþlemlerinde) Insert ve Deleted tabloalrýndan faydalanýrz. Yani updated  diye bir tablomuz yoktur.
--Iký tip trigger vardýr.
--DDL (DATA DEFINITION LANGUAGE) ve DML (DATA MANIPULATIN LANGUAGE) triggerlarý olmka üzere ikiye ayrýlýr.
--DML trigger'lar After ve Instead of olamk üzere ikiye ayrýlýr.
--After Trigger: Yaptýðýmýz iþlemden sonra (insert,update,delete) devreye girer.
--Instead Of: Tabloda veya VÝew üzerinde ki iþlem gerçekleþmez sadece Inserted ve Deleted tablolarýnda kayýt atýlýr.

--Bir üründen sipariþ alýnýnca bunu stok miktarýndan düþüren trigger
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

--Sipariþ silinirse, silinen adet kadarýný stoða geri ekleyen trigger
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

--Bir sipariþ içeriisndeki ürün adedi deðiþtiðinde stok miktarýnýnda ona göre güncelleyen trigger
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
Temporal Table: Temel oalrak DML(Update,delete) iþlemlerinde iþlemlerdeki deðiþiklikleri izlemek için SQL Server 2016 sürümüile duyrulan bir özelliktir. Temporal tablolar system versioned table olarakda adlandýrýlýr. Temporal table verinin geçmiþini kendisiyle birlikte oluþturulan history tablolar da saklalar veriyi deðiþiklik tarihine göre versiyonlar.

Bir Temporal table iki adet tablodan oluþur. Ýlk tablomuz system-versioned tablosudur. Ýkinci tablomuz history table'dýr. 
System Versioned Tabele: Gerçek verinin izlenmesi ve çaðrýlamsý üzerine tasarlanýr. Geçerli veri bu tabloda saklanýr
History Table: Veri Üzerindeki yapýlan deðiþikliði içerir. Yani system versioned table'daki yapýlan deðiþiklik history table'da depolanýyor.
*/
--TemporalDb isminde bir veritabýný oluþturuyoruz.
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

/*Live Query Statistic
SQL Server 2016 ile gelen performans özelliklerinden birisidir. Sorgumuzdan çalýþma planýný Actual Plan'dan farklý oalrak bize canlý sunmasýdýr. Bu özellik sorgumuzu izleyebilir okunan satýr sayýsýný görebilir, sorgunun ne kadarlýk kýsmýnýnýn tamamlandýðýný izleyebilrisiniz.
*/

--Sorguyu çalýþtýrmadan önce sað týk ile live query statistics iþaretini seçerek bu ekrana ulaþabilrisiniz

select* From Products

--Live Query Statistics

--Sql Server 2016 ile gelen performans özelliklerinden birisidir. Sorgumuzun çalýþma planýný Actual Execution Plan'dan farklý olarak bize canlý sunmasýdýr.Bu özellik sayesinde sorgumuzu izleyebilir okunan satýr sayýsýný görebilir, sorgunun ne kadarlýk kýsmýnnýn tamamlandýðýný izleyebiliriz.

--Sorguyu çalýþtýrmadan önce sað týk ile live query statistics iþaretini seçerek bu ekrana ulaþabilirsiniz.

select * from Products

select * from Orders o inner join Customers c on o.CustomerID=c.CustomerID

select * from Orders cross join Customers

--Resultset'deki live query statistics penceresini incelediðimizde þerit halinde çizgiler bize o sorgunun hala çalýþtýðýný gösterirken ayný zamanda anlýk olarak da okunan satur sayýsýný ve maliyetini görebiliyoruz.


--Dynamic Data Masking

--Sql Server 2016 ile gelen güvenlik önlemlerinden birisidir.Maskeleme yöntemi veriyi bozmaksýzýn (þifreleme yapmadan) select kullanýcýlarýna veriyi amskeleyerek gösterir.Maskeleme yaparken 3 fonksiyon vardýr.

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
('Ekrem','Keleþ','ekeles','123',27,'ekeles@hotmail.com'),
('Ekrem2','Keleþ2','ekeles2','12345',28,'ekeles2@gmail.com'),
('Osman','Türker','oturker','12',78,'oturker@yahoo.com'),
('Test','Testoðlu','testo','1234',56,'testo@testo.com')


--Tabloya select yaptýðýmýzda verileri maskesiz görüyoruz..
select * from Kullanicilar

--Önemli : Sorgu sonuçlarýný görebilmek için bir kullanýcý oluþturuyoruz ve sadece select yetkisi veriyoruz.Maskeleme yöntemi select kullanýcýlarýnýn veriyi maskeli görmesini saðlayacaktýr.

--Kullanýcý oluþturma iþlemi
create user Ekrem without login

--Select yetkisi verme iþlemi
grant select on Kullanicilar to Ekrem

--Default fonksiyonu ile maskeleme
--Default maskeleme yöntemi ile kolon maskelemede string alanlarda xxxx þeklinde , sayýsal alanlarda ise 0 þeklinde görüntüleme gerçekleþir.

alter table Kullanicilar
alter column KullaniciAdi add masked with (function='default()')

--Ekrem kullanýcýsý ile çalýþmak için
execute as user ='Ekrem'

--ekrem kullanýcýsýndan çýkmak için

revert