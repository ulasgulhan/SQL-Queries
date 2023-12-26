-----------------------
--String Functions--
-----------------------


--When using SELECT, it is mandatory to specify a table name, but it is not required.

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

--Remove spaces from both sides.

select REPLACE('birbirbirilerine','bir','��') as [Metinlerin yerine yenilerini atar]

--Substring: Provides information in pieces from the specified text in its parameters. The first parameter is the value from which the piece will be taken, the second parameter is the starting position of the piece, and the third parameter asks how many values will be taken.

select SUBSTRING('Merhabalar ben Burak Y�lmaz. Ameleyim.',4,6) as 'Alt stringleri olu�tutur'

select 'Burak Y�lmaz'+Space(30)+'Ameleyim' as [Belirtilen miktarda bo�luk b�rak�r]
select Replicate('Burak',5) as 'Belirtilen metni, belirtilen adet kadar �o�alt�r'