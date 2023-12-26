--Use: Bir veritabaný kullanýlacaðýný ifade etmek için kulnaýlýr.
use Northwind--Northwind veritabýnda sorgulamalar aktif olacak. Böylece yazdýðýnýz sorgualrda hangi veritanýn için sorgulama yaptýðýnýz belirtmenize grek kalmayacaktýr.

select * from Employees--"*" iþareti tablalrýn tüm sütünlarýný ifade eder.

/*Schema ve DBO
Use ifadesi ile veritabaný belirtemdiðimde veya ilgili ceritabýnýn Avaliable pencerisnden seçmedimðimde vertabýný adý ile birlikte Schema bilgisine dbo yazarak sorguyu çalýþtýrabilirsiniz
*/
--Örneðin:
SELECT (E.FirstName+' '+E.LastName) as [Full Name] FROM Northwind.dbo.Employees E

SELECT E.FirstName,E.LastName,E.Title,E.BirthDate FROM Employees E 
--Sütün Ýsimlendirme
--1.Yöntem
SELECT E.FirstName as Ad,E.LastName as Soyad,E.Title as Görev 
	FROM Employees E

select * INTO Calisanlar FROM Employees

UPDATE Calisanlar SET FirstName = 'Abuzer', LastName = 'Burak' WHERE EmployeeID=9

/*Sorgularda verileri sýralamak için WHERE,AND, OR yazýldýðýnda sorguda bir koþula baðlý kalarak veri seçmek, görüntülemek için kullanýlmaktadýr*/

--Birim fiyatý 18'den büyük olan ürünleri listeleyin
SELECT P.ProductID,
	   P.ProductName,
	   P.CategoryID,
	   P.UnitPrice,
	   P.UnitsInStock 
	   FROM Products P WHERE UnitPrice >18

SELECT * INTO urunler from Products

--Urunler tablosundaki her ürüne %5 zam yapýlmýþ yalini listeleyin

use Northwind

UPDATE urunler SET UnitPrice += (UnitPrice*0.05);

--Deleted: Bir tablodan kayýt silmek için kullanýlan BU sorgula where ifadesi kullanmazsanýz tüm veriler silerisniz.

--EmployeeID'si 8 olan çalýþaný uçurun
DELETE FROM Calisanlar WHERE EmployeeID=8

--Çalýþanlar tablomdan Mr. ve Dr. olanlarý silelim
delete from Calisanlar where TitleOfCourtesy in('Mr.','Dr.')

--Year fonksiyonu b,zden datetime tipinde deðer alýr. Geriye içindeki yýl bilgisini döndürür

--Employyes tablomada doðum tarihi 1960 olanlarý lsiteleyin
select FirstName,LastName,TitleOfCourtesy from Employees where YEAR(BirthDate) = 1960

/*Between ifadesi ile iki deðer arasýndakiþ verileri sorgulayabilirsinz. Ýki deðer arasýndaki verileri se.erken Between And ifadesi ile koþul bildirilir. Between ifadesinden sonra Deger1 and Deger2 yazýlýr*/

--1950 ve 1961 yýllarý arasýnda doðmuþ çalýþanlarýn ismi soyismi doðum tarihi listelensin
select FirstName,LastName,BirthDate 
	from Employees
	where YEAR(BirthDate) >= 1950
	and year(BirthDate) <= 1961

--Ünvaý MR. olan ve yaþý 60 büyük olanlarý listeleyin
select (TitleOfCourtesy+' '+FirstName+' '+LastName) as [Full Name] 
	from Employees
	where TitleOfCourtesy = 'Mr.' and YEAR(GETDATE())-YEAR(BirthDate)>60

--Sýralama Ýþlemleri
--Order By: Sorgu sonucunda oluþan veri gurubunu sýrlamanýzý saðlar. Asc parametresi ile artan sýrlama, Desc parametresi ile azalan sýrlama yapar. Herangi bir parmaetre kullanýlmadýðý takdirde Defalut olarak ASC parametresi kullanulýr
--Asc(Artan=> Ascending) ve Desc(azalan=> descending)

select e.FirstName+' '+e.LastName as [Full Name],
	CONVERT(varchar(10), e.BirthDate,104) as [Date of Birth]
	from Employees e
	Order by e.FirstName Asc

--Çalýþanlar tablomda ID'si 2 ile 8 arasýnda olanlarý artan sýrada sýrlayýnýz
select * from Employees
	where EmployeeID > 2
	and EmployeeID <=8
	order by FirstName asc

--Çalýþanlarýn adý,soyadý,title of courtesy ve yaþ ekrana getirilsin
--yaþa göre azalan þekilde sýrlansýn
--region null ise ekrana basýlmasýn
--Dikkat: Hiç birþey anlamýna gelir.
select (TitleOfCourtesy+' '+FirstName+' '+LastName) as Isým,
	   (year(getdate())-year(Birthdate)) as Yas
	    from Employees
		where Region is not null
		order by yas desc

--category ID'si 1 ile 4 arasýnda olanlarý between and kullanarak sýralayalým
select ProductID,ProductName,CategoryID,UnitPrice,UnitsInStock 
	from Products
	where CategoryID between 1 and 4

--Doðum tarihi 1930 ile 1960 arasýnda olup da USA'da çalýþanalrý listeleyen
select e.FirstName+' '+e.LastName as [Full Name],
	Year(e.BirthDate) as [Birth Date],
	e.Country from Employees e
	where year(e.BirthDate) between 1930 and 1960
	and e.Country = 'USA'

--1952 ve 1960 aralýpnda doðnlarýn adýý,soyadý, doðum yýlý bilgileri ile birlikte listeleyeni
select FirstName,LastName, YEAR(BirthDate) as [Birth Date]
	from Employees
	where year(BirthDate) between 1952 and 1960

--Or
--Ünvaný Mr veya Dr olanlarý listeleyiniz
select TitleOfCourtesy,FirstName,LastName 
	from Employees
	where TitleOfCourtesy = 'Mr.' or TitleOfCourtesy = 'Dr.'

--Ürünlerin birm fiytalarý 18,19 veya 25 oalnlarý listeleyeyin
select ProductName,UnitPrice 
	from Products
	where UnitPrice = 18 or UnitPrice=19 or UnitPrice= 25
	order by UnitPrice asc

--In: Birden fazla or ifadesi yerine kýsaca In ifadesin faydalanabilrisiniz

--Ürünlerin birim fiyatlarýný 18,19,25,97,40 veya 30 olanlarýný listeleyin
select ProductName,UnitPrice 
	from Products
	where UnitPrice in (18,19,25,97,40,30)
	order by UnitPrice asc

--1950,1955,1960 yýllarýnda doðanlarý listeleyin
select FirstName,LastName, YEAR(BirthDate) as Age
	from Employees
	where year(BirthDate) in (1950,1955,1960)

--top # (top 3 gibi) þeklindeki komut ilk kaç adet kaydýn ekrana yansýtýlacaðýný belirtir.

select top 3 * from Employees

--Top: Listelenecek verilerin bir kýsmý görüntülenmek için kullanýlabileceðiniz bir komutttur . Adet belirtmek için rakam kullanýlabileceði gibi yüzde olarak da ifade edilebilir. Yüzde ile gösterek isek (yüzde 70 gibi) o zaman top 70 percent kodu ile bunu saðlayabilriirz. Ondalýklý ise 3.12 gibi o zaman 4 larak alýnacaktýr

select TOP 4 ProductName,UnitPrice 
	from Products
	order by UnitPrice desc

select Top 34 Percent FirstName, LastName, Title 
	from Employees
	order by FirstName desc
--With Ties Parametresi: Top fonksiyonu ile birlikte kullanýlýr. Eðer listelinen son elemannýn deðeri ile eþleþen kayýtlar varsa bu kayýtlar da listelemeye dahil edilir.
select Top 12 With Ties ProductName, UnitPrice 
	from Products
	Order BY UnitPrice Asc

--Like: Bu oparatör "benzerlik" bulmak amacý ile kullanýlýr. Ancak özel kararakterler yardýmý ile kullanýlmasý gerekmektedir.

--Adý Michael olanlarý listeleyiniz
select FirstName,LastName,Title 
	from Employees
	where FirstName like 'Michael'

--Adýnýn baþ harfi "A" ile baþlayanlarý listeleyiniz
select FirstName,LastName,Title 
	from Employees
	where FirstName like 'A%'-- baþ harfe bakmak için sona yüzde koyuyoruz

--Ýsmi N ile bitenler
select FirstName,LastName,Title 
	from Employees
	where FirstName like '%N'--son harfe bakmak için baþa yüzde koyulur

--Ýsmi içerisinde E harfi geçen
select FirstName,LastName,Title 
	from Employees
	where FirstName like '%E%'

--Kutu "box" ürünlerimizin listesini alýn
select ProductName,QuantityPerUnit 
	from Products
	where QuantityPerUnit like '%box%'

--ÝLk harfi A veya L olan
select FirstName,LastName,Title 
	from Employees
	where FirstName like '[AL]%'

--Adýnýn içinde R veya T geçenler
select FirstName,LastName,Title 
	from Employees
	where FirstName like '%[RT]%'

--Adýný ilk harfi J ve R aralýðýnda olan
select FirstName,LastName,Title 
	from Employees
	where FirstName like '[J-R]%'

--Not: "_" Bir karakter anlamýna gelmektedir
select FirstName,LastName,Title 
	from Employees
	where FirstName like 'J_N%'

--ismi içerisnde A ve T olanlar ve bu iki harf arasýnda 2 karakter olanlar
select FirstName,LastName,Title 
	from Employees
	where FirstName Like '%A__T%'

--Adýnýn ilk harfi M olmayan
select FirstName,LastName,Title 
	from Employees
	where FirstName not like 'M%'

select FirstName,LastName,Title 
	from Employees
	where FirstName like '[^M]%'

--Adý T ile bitmeyenler
select FirstName,LastName,Title 
	from Employees
	where FirstName like '%[^T]'

--Adýnýn ilk harfi A ile I aralýðýnda bulunmayan
SELECT FirstName,
       LastName,
       Title
FROM Employees
WHERE FirstName LIKE '[^A-I]%'

--Adýnýn ikinci harfi A veya T olmayan
select FirstName,LastName,Title 
	from Employees
	where FirstName like '_[^AT]%'

--Restoran iþleten müþterilerimizi listelemek istiyoruz. Ancak Mexcixo þehrindeki müþteriler listelenmesin
select CompanyName,Address,Country,City 
	from Customers
	where CompanyName like '%Rest%'
	and Country != 'Mexico'

--Space: Boþluk karakterii ifade eder. Parametresine yazýlan adet kadar boþluk karakteri oluþturulur
select FirstName+Space(1)+LastName as [Full Name]from Employees

--NUll: Hiçbir þey anlamýna gelir. Tabloda bir sütünda  hiçbir deðer olamamsý demektedir. Tablodaki bir boþluk karakteri Null demek deðildir.

--Müþteirler tablsounda Bölge bilgisi girilememiþ olan kayýtlarý listelemek
Select CompanyName,Region 
	from Customers
		where Region is null

--IsNull ilk parametresi hangi alanýn null olmasý durumunun kontrol edileceðini sorar. Ýkinci parametre ise alnýn null olmasý duurmunda akratýlacak deðeri ifade eder.

--Bölge verisi boþ ise bölge yok yazmak
select CompanyName,ISNULL(Region, 'Bölge Yok') as Bolge 
	from Customers
	where Region is null

select * from Customers

--Tip Çevirmeleri
--Bazý durumlarda SQL Server içinde çevrimi yapamnýz gerekebilir. Mesela String bir veri ile sayýsal veya tarih tipinde bir veriyi birleþtirebilirsiniz.

select * into kategori from Categories
select CONVERT(varchar(1), CategoryID)+Space(1)+CategoryName as [Full Category Name]
	from kategori

--Try_Convert: Tip çevrimi yapar. Baþarýlý ise sonuç döner, tip çevrimi yapaýlamýyorsa null döner.

--Cast: Tip çevrimi için kullanýlan bir fonksyondur. Deðerin stilini deðiþtirmez.

--Employee tablosundaki Tarih verisini cast edin
select FirstName+' '+LastName+' '+Cast(Year(BirthDate) as Nvarchar(4))+' doðumludur.' as [Caliþanlarýn Doðum Tarihi] from Employees order by BirthDate

--Try_Parse: String tipindeki verilerin,  istenilen tipe çevrimini yapar. Baþarýlý ise sonuç döner, tip çevrimi yapýlamýyorsa Null döner.