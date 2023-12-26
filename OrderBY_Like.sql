--Use: Bir veritaban� kullan�laca��n� ifade etmek i�in kulna�l�r.
use Northwind--Northwind veritab�nda sorgulamalar aktif olacak. B�ylece yazd���n�z sorgualrda hangi veritan�n i�in sorgulama yapt���n�z belirtmenize grek kalmayacakt�r.

select * from Employees--"*" i�areti tablalr�n t�m s�t�nlar�n� ifade eder.

/*Schema ve DBO
Use ifadesi ile veritaban� belirtemdi�imde veya ilgili ceritab�n�n Avaliable pencerisnden se�medim�imde vertab�n� ad� ile birlikte Schema bilgisine dbo yazarak sorguyu �al��t�rabilirsiniz
*/
--�rne�in:
SELECT (E.FirstName+' '+E.LastName) as [Full Name] FROM Northwind.dbo.Employees E

SELECT E.FirstName,E.LastName,E.Title,E.BirthDate FROM Employees E 
--S�t�n �simlendirme
--1.Y�ntem
SELECT E.FirstName as Ad,E.LastName as Soyad,E.Title as G�rev 
	FROM Employees E

select * INTO Calisanlar FROM Employees

UPDATE Calisanlar SET FirstName = 'Abuzer', LastName = 'Burak' WHERE EmployeeID=9

/*Sorgularda verileri s�ralamak i�in WHERE,AND, OR yaz�ld���nda sorguda bir ko�ula ba�l� kalarak veri se�mek, g�r�nt�lemek i�in kullan�lmaktad�r*/

--Birim fiyat� 18'den b�y�k olan �r�nleri listeleyin
SELECT P.ProductID,
	   P.ProductName,
	   P.CategoryID,
	   P.UnitPrice,
	   P.UnitsInStock 
	   FROM Products P WHERE UnitPrice >18

SELECT * INTO urunler from Products

--Urunler tablosundaki her �r�ne %5 zam yap�lm�� yalini listeleyin

use Northwind

UPDATE urunler SET UnitPrice += (UnitPrice*0.05);

--Deleted: Bir tablodan kay�t silmek i�in kullan�lan BU sorgula where ifadesi kullanmazsan�z t�m veriler silerisniz.

--EmployeeID'si 8 olan �al��an� u�urun
DELETE FROM Calisanlar WHERE EmployeeID=8

--�al��anlar tablomdan Mr. ve Dr. olanlar� silelim
delete from Calisanlar where TitleOfCourtesy in('Mr.','Dr.')

--Year fonksiyonu b,zden datetime tipinde de�er al�r. Geriye i�indeki y�l bilgisini d�nd�r�r

--Employyes tablomada do�um tarihi 1960 olanlar� lsiteleyin
select FirstName,LastName,TitleOfCourtesy from Employees where YEAR(BirthDate) = 1960

/*Between ifadesi ile iki de�er aras�ndaki� verileri sorgulayabilirsinz. �ki de�er aras�ndaki verileri se.erken Between And ifadesi ile ko�ul bildirilir. Between ifadesinden sonra Deger1 and Deger2 yaz�l�r*/

--1950 ve 1961 y�llar� aras�nda do�mu� �al��anlar�n ismi soyismi do�um tarihi listelensin
select FirstName,LastName,BirthDate 
	from Employees
	where YEAR(BirthDate) >= 1950
	and year(BirthDate) <= 1961

--�nva� MR. olan ve ya�� 60 b�y�k olanlar� listeleyin
select (TitleOfCourtesy+' '+FirstName+' '+LastName) as [Full Name] 
	from Employees
	where TitleOfCourtesy = 'Mr.' and YEAR(GETDATE())-YEAR(BirthDate)>60

--S�ralama ��lemleri
--Order By: Sorgu sonucunda olu�an veri gurubunu s�rlaman�z� sa�lar. Asc parametresi ile artan s�rlama, Desc parametresi ile azalan s�rlama yapar. Herangi bir parmaetre kullan�lmad��� takdirde Defalut olarak ASC parametresi kullanul�r
--Asc(Artan=> Ascending) ve Desc(azalan=> descending)

select e.FirstName+' '+e.LastName as [Full Name],
	CONVERT(varchar(10), e.BirthDate,104) as [Date of Birth]
	from Employees e
	Order by e.FirstName Asc

--�al��anlar tablomda ID'si 2 ile 8 aras�nda olanlar� artan s�rada s�rlay�n�z
select * from Employees
	where EmployeeID > 2
	and EmployeeID <=8
	order by FirstName asc

--�al��anlar�n ad�,soyad�,title of courtesy ve ya� ekrana getirilsin
--ya�a g�re azalan �ekilde s�rlans�n
--region null ise ekrana bas�lmas�n
--Dikkat: Hi� bir�ey anlam�na gelir.
select (TitleOfCourtesy+' '+FirstName+' '+LastName) as Is�m,
	   (year(getdate())-year(Birthdate)) as Yas
	    from Employees
		where Region is not null
		order by yas desc

--category ID'si 1 ile 4 aras�nda olanlar� between and kullanarak s�ralayal�m
select ProductID,ProductName,CategoryID,UnitPrice,UnitsInStock 
	from Products
	where CategoryID between 1 and 4

--Do�um tarihi 1930 ile 1960 aras�nda olup da USA'da �al��analr� listeleyen
select e.FirstName+' '+e.LastName as [Full Name],
	Year(e.BirthDate) as [Birth Date],
	e.Country from Employees e
	where year(e.BirthDate) between 1930 and 1960
	and e.Country = 'USA'

--1952 ve 1960 aral�pnda do�nlar�n ad��,soyad�, do�um y�l� bilgileri ile birlikte listeleyeni
select FirstName,LastName, YEAR(BirthDate) as [Birth Date]
	from Employees
	where year(BirthDate) between 1952 and 1960

--Or
--�nvan� Mr veya Dr olanlar� listeleyiniz
select TitleOfCourtesy,FirstName,LastName 
	from Employees
	where TitleOfCourtesy = 'Mr.' or TitleOfCourtesy = 'Dr.'

--�r�nlerin birm fiytalar� 18,19 veya 25 oalnlar� listeleyeyin
select ProductName,UnitPrice 
	from Products
	where UnitPrice = 18 or UnitPrice=19 or UnitPrice= 25
	order by UnitPrice asc

--In: Birden fazla or ifadesi yerine k�saca In ifadesin faydalanabilrisiniz

--�r�nlerin birim fiyatlar�n� 18,19,25,97,40 veya 30 olanlar�n� listeleyin
select ProductName,UnitPrice 
	from Products
	where UnitPrice in (18,19,25,97,40,30)
	order by UnitPrice asc

--1950,1955,1960 y�llar�nda do�anlar� listeleyin
select FirstName,LastName, YEAR(BirthDate) as Age
	from Employees
	where year(BirthDate) in (1950,1955,1960)

--top # (top 3 gibi) �eklindeki komut ilk ka� adet kayd�n ekrana yans�t�laca��n� belirtir.

select top 3 * from Employees

--Top: Listelenecek verilerin bir k�sm� g�r�nt�lenmek i�in kullan�labilece�iniz bir komutttur . Adet belirtmek i�in rakam kullan�labilece�i gibi y�zde olarak da ifade edilebilir. Y�zde ile g�sterek isek (y�zde 70 gibi) o zaman top 70 percent kodu ile bunu sa�layabilriirz. Ondal�kl� ise 3.12 gibi o zaman 4 larak al�nacakt�r

select TOP 4 ProductName,UnitPrice 
	from Products
	order by UnitPrice desc

select Top 34 Percent FirstName, LastName, Title 
	from Employees
	order by FirstName desc
--With Ties Parametresi: Top fonksiyonu ile birlikte kullan�l�r. E�er listelinen son elemann�n de�eri ile e�le�en kay�tlar varsa bu kay�tlar da listelemeye dahil edilir.
select Top 12 With Ties ProductName, UnitPrice 
	from Products
	Order BY UnitPrice Asc

--Like: Bu oparat�r "benzerlik" bulmak amac� ile kullan�l�r. Ancak �zel kararakterler yard�m� ile kullan�lmas� gerekmektedir.

--Ad� Michael olanlar� listeleyiniz
select FirstName,LastName,Title 
	from Employees
	where FirstName like 'Michael'

--Ad�n�n ba� harfi "A" ile ba�layanlar� listeleyiniz
select FirstName,LastName,Title 
	from Employees
	where FirstName like 'A%'-- ba� harfe bakmak i�in sona y�zde koyuyoruz

--�smi N ile bitenler
select FirstName,LastName,Title 
	from Employees
	where FirstName like '%N'--son harfe bakmak i�in ba�a y�zde koyulur

--�smi i�erisinde E harfi ge�en
select FirstName,LastName,Title 
	from Employees
	where FirstName like '%E%'

--Kutu "box" �r�nlerimizin listesini al�n
select ProductName,QuantityPerUnit 
	from Products
	where QuantityPerUnit like '%box%'

--�Lk harfi A veya L olan
select FirstName,LastName,Title 
	from Employees
	where FirstName like '[AL]%'

--Ad�n�n i�inde R veya T ge�enler
select FirstName,LastName,Title 
	from Employees
	where FirstName like '%[RT]%'

--Ad�n� ilk harfi J ve R aral���nda olan
select FirstName,LastName,Title 
	from Employees
	where FirstName like '[J-R]%'

--Not: "_" Bir karakter anlam�na gelmektedir
select FirstName,LastName,Title 
	from Employees
	where FirstName like 'J_N%'

--ismi i�erisnde A ve T olanlar ve bu iki harf aras�nda 2 karakter olanlar
select FirstName,LastName,Title 
	from Employees
	where FirstName Like '%A__T%'

--Ad�n�n ilk harfi M olmayan
select FirstName,LastName,Title 
	from Employees
	where FirstName not like 'M%'

select FirstName,LastName,Title 
	from Employees
	where FirstName like '[^M]%'

--Ad� T ile bitmeyenler
select FirstName,LastName,Title 
	from Employees
	where FirstName like '%[^T]'

--Ad�n�n ilk harfi A ile I aral���nda bulunmayan
SELECT FirstName,
       LastName,
       Title
FROM Employees
WHERE FirstName LIKE '[^A-I]%'

--Ad�n�n ikinci harfi A veya T olmayan
select FirstName,LastName,Title 
	from Employees
	where FirstName like '_[^AT]%'

--Restoran i�leten m��terilerimizi listelemek istiyoruz. Ancak Mexcixo �ehrindeki m��teriler listelenmesin
select CompanyName,Address,Country,City 
	from Customers
	where CompanyName like '%Rest%'
	and Country != 'Mexico'

--Space: Bo�luk karakterii ifade eder. Parametresine yaz�lan adet kadar bo�luk karakteri olu�turulur
select FirstName+Space(1)+LastName as [Full Name]from Employees

--NUll: Hi�bir �ey anlam�na gelir. Tabloda bir s�t�nda  hi�bir de�er olamams� demektedir. Tablodaki bir bo�luk karakteri Null demek de�ildir.

--M��teirler tablsounda B�lge bilgisi girilememi� olan kay�tlar� listelemek
Select CompanyName,Region 
	from Customers
		where Region is null

--IsNull ilk parametresi hangi alan�n null olmas� durumunun kontrol edilece�ini sorar. �kinci parametre ise aln�n null olmas� duurmunda akrat�lacak de�eri ifade eder.

--B�lge verisi bo� ise b�lge yok yazmak
select CompanyName,ISNULL(Region, 'B�lge Yok') as Bolge 
	from Customers
	where Region is null

select * from Customers

--Tip �evirmeleri
--Baz� durumlarda SQL Server i�inde �evrimi yapamn�z gerekebilir. Mesela String bir veri ile say�sal veya tarih tipinde bir veriyi birle�tirebilirsiniz.

select * into kategori from Categories
select CONVERT(varchar(1), CategoryID)+Space(1)+CategoryName as [Full Category Name]
	from kategori

--Try_Convert: Tip �evrimi yapar. Ba�ar�l� ise sonu� d�ner, tip �evrimi yapa�lam�yorsa null d�ner.

--Cast: Tip �evrimi i�in kullan�lan bir fonksyondur. De�erin stilini de�i�tirmez.

--Employee tablosundaki Tarih verisini cast edin
select FirstName+' '+LastName+' '+Cast(Year(BirthDate) as Nvarchar(4))+' do�umludur.' as [Cali�anlar�n Do�um Tarihi] from Employees order by BirthDate

--Try_Parse: String tipindeki verilerin,  istenilen tipe �evrimini yapar. Ba�ar�l� ise sonu� d�ner, tip �evrimi yap�lam�yorsa Null d�ner.