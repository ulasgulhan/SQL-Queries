--Date Function: General name given to date functions in SQL Server.

--DATEDIFF: Provides the difference between the specified start and end values in terms of dates.
--Usage: Abbreviation representing the date, start date, end value
--We want to find out how old the employees are. You need to obtain the information in terms of years, months, and days.

select CONCAT(FirstName, ' ', LastName) as FullName, 
DATEDIFF(YY, BirthDate, GETDATE()) as Year,
DATEDIFF(MM, BirthDate, GETDATE()) as Mounth,
DATEDIFF(DD, BirthDate, GETDATE()) as Day
from Employees


--GETDATE: Returns the current date and time information for the day. The data type of the returned value is DateTime.
--DATENAME: Provides the name information of the date based on the provided parameter.
--DATEDAY, MONTH, YEAR: Returns the information of the date based on the specified parameter. For example, if DD is specified, it returns the day.
--ISDATE: Checks whether the provided data is in date format. If the data is in the correct date format, it returns 1.

--DATEPART: Returns a part of the date, such as day, month, year, hour, etc., for the given date.
--Usage: It is an abbreviation representing the date.
--Display order dates as day, month, year.

select CustomerID,EmployeeID,
	Datepart(YYYY, OrderDate) as OrderYear,
	Datepart(MM, OrderDate) as OrderMounth,
	Datepart(DD, OrderDate) as OrderDay,
	Datepart(QQ, OrderDate) as Quarters
	from Orders
	Order by EmployeeID
