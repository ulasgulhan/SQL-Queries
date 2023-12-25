--Live Query Statistics

--It is one of the performance features introduced with SQL Server 2016. Unlike the Actual Execution Plan, it provides us with a live view of the execution plan of our query. With this feature, we can monitor our query, see the number of rows read, and track how much of the query has been completed.

--Before executing the query, you can access this screen by right-clicking and selecting "Live Query Statistics."

select * from Products

select * from Orders o inner join Customers c on o.CustomerID=c.CustomerID

select * from Orders cross join Customers

--When examining the live query statistics window in the result set, the ribbon-like lines show us that the query is still running, and at the same time, we can see the number of rows read and its cost in real-time.
