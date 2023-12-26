-----------------------
--String Fonksiyonlar--
-----------------------

--Select ile mutlaka bir tablo ad� kullan zorunlu de�iliz......!
select 5+9 As Toplam,
	   5-9 As Fark,
	   5*9 As �Arp�m,
	   5/3 As B�l�m,
	   5%2 As [MOD];

select 'Burak Y�lmaz ile - SQL Server Dersleri. Dad�na doyulmuyor....:D' as Mesaj
select ASCII('A') as [ASCII Kodu]
select char(65) as Karakter
select left('Burak Y�lmaz',4) as [Soldan karakter say�s�]
select right('Burak Y�lmaz',4) as [Sa�dan karakter say�s�]
select len('SM') as [Karakter Say�s�]
select Lower('BURAK YILMAZ') as [Hepsinin k���k harf yapar]
select Upper('burak y�lmaz') as [Hepsinin b�y�k harf yapar]
select LTRIM('              Burak Y�lmaz') as [Soldaki bo�lukalr� siler]
select Rtrim('Burak Y�lmaz              ') as [Sa�daki bo�luklar� siler]

--�ki taraftan bo�luk silin

select REPLACE('birbirbirilerine','bir','��') as [Metinlerin yerine yenilerini atar]

--Substring: Parametresinde belirtilen metinden par�alar halinde bilgi verir. �lk parametre par�a al�nacak de�eri ikinci parametre par�a al�nmaya ka��nc� de�erden ba�lan�laca��n� ���nc� parametre ka� adet de�er al�naca��n� sorar.
select SUBSTRING('Merhabalar ben Burak Y�lmaz. Ameleyim.',4,6) as 'Alt stringleri olu�tutur'

select 'Burak Y�lmaz'+Space(30)+'Ameleyim' as [Belirtilen miktarda bo�luk b�rak�r]
select Replicate('Burak',5) as 'Belirtilen metni, belirtilen adet kadar �o�alt�r'