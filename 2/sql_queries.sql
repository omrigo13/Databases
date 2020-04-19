/*
Omri Goldberg - 208938985
Noa Chardon - 312164668
*/

BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "CarParking" (
	"CID"	varchar(9) NOT NULL,
	"StartTime"	datetime NOT NULL,
	"EndTime"	datetime NOT NULL CHECK(EndTime>StartTime),
	"Cost"	INTEGER DEFAULT 0 CHECK(Cost>=0),
	"AID"	INTEGER,
	PRIMARY KEY("CID","StartTime"),
	FOREIGN KEY("AID") REFERENCES "ParkingArea"("AID") on DELETE set null on update CASCADE,
	FOREIGN KEY("CID") REFERENCES "Car"("CID") on DELETE CASCADE on UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS "Car" (
	"CID"	varchar(9) NOT NULL,
	"CellPhoneNumber"	varchar(10) NOT NULL,
	"CreditCard"	varchar(16) NOT NULL,
	"ExpirationDate"	date NOT NULL,
	"ThreeDigits"	varchar(3) NOT NULL,
	"ID"	varchar(9) NOT NULL,
	PRIMARY KEY("CID"),
	FOREIGN KEY("ID") REFERENCES "Resident"("RID") on DELETE CASCADE on UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS "ParkingArea" (
	"AID"	INTEGER NOT NULL,
	"Name"	varchar(255) NOT NULL,
	"NID"	INTEGER NOT NULL,
	"PricePerHour"	INTEGER NOT NULL,
	"MaxPricePerDay"	INTEGER NOT NULL CHECK(MaxPricePerDay>PricePerHour),
	PRIMARY KEY("AID"),
	FOREIGN KEY("NID") REFERENCES "Neighborhood"("NID") on UPDATE CASCADE on DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Apartment" (
	"StreetName"	varchar(255) NOT NULL,
	"Number"	INTEGER NOT NULL,
	"Door"	INTEGER NOT NULL,
	"Type"	varchar(255) NOT NULL,
	"SizeSquareMeter"	INTEGER NOT NULL,
	"NID"	INTEGER NOT NULL,
	PRIMARY KEY("StreetName","Number","Door"),
	FOREIGN KEY("NID") REFERENCES "Neighborhood"("NID") on DELETE RESTRICT on UPDATE RESTRICT
);
CREATE TABLE IF NOT EXISTS "TrashCan" (
	"CatalogID"	INTEGER CHECK(CatalogID>0),
	"CreationDate"	date NOT NULL,
	"ExpirationDate"	date NOT NULL CHECK(ExpirationDate>CreationDate),
	"RID"	varchar(9) NOT NULL,
	PRIMARY KEY("CatalogID"),
	FOREIGN KEY("RID") REFERENCES "Resident"("RID") on DELETE CASCADE on UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS "Resident" (
	"RID"	varchar(9),
	"FirstName"	varchar(255) NOT NULL,
	"LastName"	varchar(255) NOT NULL,
	"BirthDate"	date NOT NULL,
	"StreetName"	varchar(255) NOT NULL,
	"Number"	INTEGER CHECK(Number>0),
	"Door"	INTEGER CHECK(Door>0),
	PRIMARY KEY("RID"),
	FOREIGN KEY("StreetName","Number","Door") REFERENCES "Apartment"("StreetName","Number","Door") on DELETE RESTRICT on UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS "CellPhoneNumber" (
	"EID"	varchar(9) NOT NULL,
	"CellPhone"	varchar(10) NOT NULL,
	PRIMARY KEY("EID","CellPhone"),
	FOREIGN KEY("EID") REFERENCES "Employee"("EID") on DELETE CASCADE on UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS "Neighborhood" (
	"NID"	INTEGER,
	"Name"	varchar(255) NOT NULL,
	PRIMARY KEY("NID")
);
CREATE TABLE IF NOT EXISTS "ProjectConstructorEmployee" (
	"StartWorkingDate"	date NOT NULL,
	"EndWorkingDate"	date,
	"JobDescription"	varchar(255) NOT NULL,
	"EID"	varchar(9) NOT NULL,
	"PID"	INTEGER NOT NULL,
	FOREIGN KEY("PID") REFERENCES "Project"("PID") on DELETE no action on UPDATE CASCADE,
	FOREIGN KEY("EID") REFERENCES "ConstructorEmployee"("EID") on DELETE RESTRICT on UPDATE CASCADE,
	PRIMARY KEY("EID","PID")
);
CREATE TABLE IF NOT EXISTS "Project" (
	"PID"	INTEGER,
	"Name"	varchar(255) NOT NULL,
	"Description"	varchar(255) NOT NULL,
	"Budget"	INTEGER DEFAULT 0,
	"Neighborhood"	INTEGER NOT NULL,
	PRIMARY KEY("PID"),
	FOREIGN KEY("Neighborhood") REFERENCES "Neighborhood"("NID") on DELETE RESTRICT on UPDATE RESTRICT
);
CREATE TABLE IF NOT EXISTS "Department" (
	"DID"	INTEGER NOT NULL,
	"Name"	varchar(255) NOT NULL,
	"Description"	varchar(255) NOT NULL,
	"ManagerID"	varchar(9),
	PRIMARY KEY("DID"),
	FOREIGN KEY("ManagerID") REFERENCES "OfficialEmployee"("EID") on DELETE RESTRICT on UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS "ConstructorEmployee" (
	"EID"	varchar(9),
	"CompanyName"	varchar(255) NOT NULL,
	"SalaryPerDay"	INTEGER NOT NULL,
	FOREIGN KEY("EID") REFERENCES "Employee"("EID") on DELETE CASCADE on UPDATE CASCADE,
	PRIMARY KEY("EID")
);
CREATE TABLE IF NOT EXISTS "OfficialEmployee" (
	"EID"	varchar(9),
	"StartWorkingDate"	date NOT NULL,
	"Degree"	varchar(255) NOT NULL,
	"Department"	INTEGER NOT NULL,
	FOREIGN KEY("EID") REFERENCES "Employee"("EID") on DELETE CASCADE on UPDATE CASCADE,
	PRIMARY KEY("EID"),
	FOREIGN KEY("Department") REFERENCES "Department"("DID") on DELETE CASCADE on UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS "Employee" (
	"EID"	varchar(9),
	"FirstName"	varchar(255) NOT NULL,
	"LastName"	varchar(255) NOT NULL,
	"BirthDate"	date NOT NULL,
	"City"	varchar(255) NOT NULL,
	"StreetName"	varchar(255) NOT NULL,
	"Number"	INTEGER NOT NULL,
	"Door"	INTEGER NOT NULL,
	PRIMARY KEY("EID")
);
COMMIT;
