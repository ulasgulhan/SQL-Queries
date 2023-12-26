-----------------------
--String Fonksiyonlar--
-----------------------

--Select ile mutlaka bir tablo adý kullan zorunlu deðiliz......!
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

--Ýki taraftan boþluk silin

select REPLACE('birbirbirilerine','bir','üç') as [Metinlerin yerine yenilerini atar]

--Substring: Parametresinde belirtilen metinden parçalar halinde bilgi verir. Ýlk parametre parça alýnacak deðeri ikinci parametre parça alýnmaya kaçýncý deðerden baþlanýlacaðýný üçüncü parametre kaç adet deðer alýnacaðýný sorar.
select SUBSTRING('Merhabalar ben Burak Yýlmaz. Ameleyim.',4,6) as 'Alt stringleri oluþtutur'

select 'Burak Yýlmaz'+Space(30)+'Ameleyim' as [Belirtilen miktarda boþluk býrakýr]
select Replicate('Burak',5) as 'Belirtilen metni, belirtilen adet kadar çoðaltýr'