/*Aggregate Functions*/
/*These functions are clustering functions. They have the ability to operate on multiple rows. When used alone, they return a result for each row, one column at a time. If another column is added to the query other than the column on which clustering will be done, it is necessary to group the query according to this added column. The Group by statement should include every column except the one on which the aggregate function is used. Aggregate functions only work with numerical data and do not consider null values. We can filter the data containing the results created using aggregate functions using the HAVING clause instead of the WHERE clause. Columns cannot use alias names with the HAVING expression. */


--Sum: It gives us the sum of values in a column.
select SUM(EmployeeID) as [Sum of Id] from Employees

--The sum of quantity * unit price.
select Sum(UnitPrice*Quantity) as [Unit Price Sum] from [Order Details]

--The sum of the ages of employees.
select Sum(DATEDIFF(Year,BirthDate,GETDATE())) as [Sum of Ages] from Employees

--Count: It returns the number of rows returned in the query result.
select Count(OrderID) as [Total Order] from Orders

--Find out how many orders your employees have taken.
select EmployeeId, Count(OrderId) TotalOrder
from Orders
group by EmployeeID

--List the total number of records.
select Count(*) TotalEmployee from Employees

--The total number of regions.

select Count(Region) TotalRegion from Employees

--Write the total of different cities.
select Count(distinct City) Cities from Employees


--AVG => Used to calculate the average.
select AVG(EmployeeID) From Employees

--Avarage Age
select avg(DATEDIFF(Year,BirthDate,GETDATE())) [Avarage Age] from Employees

--Find the oldest and youngest employees in terms of age.
select max(DATEDIFF(Year,BirthDate,GETDATE())) MaxAge, min(DATEDIFF(Year,BirthDate,GETDATE())) MinAge from Employees


--Case -When - Then
select FirstName, 
	   LastName,
	   Case(Country)
		WHEN 'USA'
		THEN 'America BÝrleþik Devlettleri'
		WHEN 'UK'
		THEN 'Ýngiltere birleþik krallaðý'
		Else 'Ülke belirtilmedi' 
	END AS Country 
from Employees
