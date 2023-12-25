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
