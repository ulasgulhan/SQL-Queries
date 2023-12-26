-----------------------
--String Functions--
-----------------------


--When using SELECT, it is mandatory to specify a table name, but it is not required.

select 5+9 As Toplam,
	   5-9 As Fark,
	   5*9 As ÇArpým,
	   5/3 As Bölüm,
	   5%2 As [MOD];

select 'Burak Yýlmaz ile - SQL Server Dersleri. Dadýna doyulmuyor....:D' as Mesaj
select ASCII('A') as [ASCII Kodu]
select char(65) as Karakter
select left('Burak Yýlmaz',4) as [Soldan karakter sayýsý]
select right('Burak Yýlmaz',4) as [Saðdan karakter sayýsý]
select len('SM') as [Karakter Sayýsý]
select Lower('BURAK YILMAZ') as [Hepsinin küçük harf yapar]
select Upper('burak yýlmaz') as [Hepsinin büyük harf yapar]
select LTRIM('              Burak Yýlmaz') as [Soldaki boþlukalrý siler]
select Rtrim('Burak Yýlmaz              ') as [Saðdaki boþluklarý siler]

--Remove spaces from both sides.

select REPLACE('birbirbirilerine','bir','üç') as [Metinlerin yerine yenilerini atar]

--Substring: Provides information in pieces from the specified text in its parameters. The first parameter is the value from which the piece will be taken, the second parameter is the starting position of the piece, and the third parameter asks how many values will be taken.

select SUBSTRING('Merhabalar ben Burak Yýlmaz. Ameleyim.',4,6) as 'Alt stringleri oluþtutur'

select 'Burak Yýlmaz'+Space(30)+'Ameleyim' as [Belirtilen miktarda boþluk býrakýr]
select Replicate('Burak',5) as 'Belirtilen metni, belirtilen adet kadar çoðaltýr'