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

--Function listing the names of employees based on their initials.

CREATE FUNCTION basHarfeGoreGetir
(@basHarf NVARCHAR(1)
)
RETURNS TABLE
     RETURN
     SELECT *
     FROM Employees
     WHERE LEFT(FirstName, 1) = @basHarf;


select *
from basHarfeGoreGetir('A')

