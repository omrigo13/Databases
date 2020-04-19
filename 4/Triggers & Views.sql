CREATE VIEW ConstructorEmployeeOverFifty AS
SELECT Employee.*, CompanyName , SalaryPerDay
FROM Employee, ConstructorEmployee
WHERE Employee.EID = ConstructorEmployee.EID AND strftime('%Y', 'now')- strftime('%Y', BirthDate) >= 50;

CREATE VIEW ApartmentNumberInNeighborhood AS
SELECT Neighborhood.NID, COUNT(Apartment.NID) AS ApartmentNumber
FROM Neighborhood,Apartment
WHERE Neighborhood.NID = Apartment.NID
GROUP BY Neighborhood.NID;


CREATE TRIGGER DeleteProject
AFTER DELETE On Project
BEGIN

DELETE FROM ProjectConstructorEmployee WHERE PID = Old.PID;

DELETE FROM ConstructorEmployee WHERE ConstructorEmployee.EID NOT IN 
(SELECT EID FROM ProjectConstructorEmployee);

DELETE FROM Employee WHERE Employee.EID NOT IN
(SELECT EID FROM ConstructorEmployee);

END;

CREATE TRIGGER MaxManger
BEFORE UPDATE On Department
BEGIN
SELECT CASE
WHEN ( New.ManagerID in (SELECT ManagerID
FROM Department, OfficialEmployee
WHERE Department.ManagerID = OfficialEmployee.EID
group by ManagerID
HAVING COUNT(ManagerID) >= 2))
THEN RAISE(ABORT, 'This Official Employee already manages two departments') 
END;
END;

CREATE TRIGGER MaxManger2
BEFORE INSERT On Department
BEGIN
SELECT CASE
WHEN ( New.ManagerID in (SELECT ManagerID
FROM Department, OfficialEmployee
WHERE Department.ManagerID = OfficialEmployee.EID
group by ManagerID
HAVING COUNT(ManagerID) >= 2))
THEN RAISE(ABORT, 'This Official Employee already manages two departments') 
END;
END;