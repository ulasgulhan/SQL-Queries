/*
Temporal Table is a feature introduced with SQL Server 2016 primarily to track changes in DML (Update, Delete) operations. 
Temporal tables are also known as system-versioned tables. Temporal tables store the history of data along with the data itself, 
preserving versions based on the modification date.

A Temporal table consists of two tables. The first table is the system-versioned table, which is designed for tracking and querying the actual data. 
The current data is stored in this table. The second table is the history table, which contains the changes made to the data. In other words, 
the modifications made in the system-versioned table are stored in the history table.
*/
--We are creating a database named TemporalDb.

create database TemporalDb
use TemporalDB

drop database TemporalDb

CREATE TABLE URUN1
(
	ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Adi NVARCHAR(50),
	Fiyati Money,
	StokMiktari SMALLINT,
	RowStart DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	RowEnd DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME(RowStart, RowEnd)
)WITH(SYSTEM_VERSIONING = ON(HISTORY_TABLE = dbo.URUN1History))

insert into URUN1(Adi,Fiyati,StokMiktari) 
VALUES 
('A Ürünü',750,10),
('B Ürünü',750,20),
('C Ürünü',750,30)

select * from URUN1

select * from dbo.Urun URUN1History
