/*
Omri Goldberg - 208938985
Noa Chardon - 312164668
*/

--Q1
SELECT DISTINCT FirstName, SalaryPerDay, Name, Description
FROM Employee, ConstructorEmployee, ProjectConstructorEmployee, Project
WHERE Employee.EID = ConstructorEmployee.EID AND ConstructorEmployee.EID = ProjectConstructorEmployee.EID
AND ProjectConstructorEmployee.PID = Project.PID

--Q2
SELECT Employee.*, Name
FROM Employee, OfficialEmployee, Department
WHERE Employee.EID = OfficialEmployee.EID AND OfficialEmployee.Department = Department.DID

UNION

SELECT Employee.*, Name
FROM Employee, ConstructorEmployee, ProjectConstructorEmployee, Project
WHERE Employee.EID = ConstructorEmployee.EID AND ConstructorEmployee.EID = ProjectConstructorEmployee.EID
AND ProjectConstructorEmployee.PID = Project.PID AND EndWorkingDate = (SELECT MAX(EndWorkingDate) FROM ProjectConstructorEmployee as pce
WHERE ProjectConstructorEmployee.EID = pce.EID)

--Q3
SELECT Name, COUNT(Apartment.NID) AS counter
FROM Neighborhood,Apartment
WHERE Neighborhood.NID = Apartment.NID
GROUP BY Name
ORDER BY COUNT(Apartment.NID)

--Q4
SELECT Apartment.StreetName,Apartment.Number, Apartment.Door, LastName
FROM Apartment
LEFT JOIN Resident ON Resident.door = Apartment.Door AND Resident.Number = Apartment.Number AND Resident.StreetName = Apartment.StreetName

--Q5
SELECT *
FROM ParkingArea
WHERE MaxPricePerDay = (SELECT MIN(MaxPricePerDay) FROM ParkingArea)

--Q6
SELECT DISTINCT Car.CID, Car.ID
FROM Car, CarParking, ParkingArea
WHERE Car.CID = CarParking.CID and CarParking.AID = ParkingArea.AID
AND ParkingArea.MaxPricePerDay =(SELECT MIN(ParkingArea.MaxPricePerDay) FROM ParkingArea)

--Q7
SELECT details.RID, Resident.FirstName, Resident.LastName
FROM Resident,
(SELECT RID, Neighborhood.NID
FROM Resident, Car, CarParking, ParkingArea, Neighborhood
WHERE Resident.RID = Car.ID AND Car.CID = CarParking.CID AND CarParking.AID = ParkingArea.AID AND ParkingArea.NID = Neighborhood.NID
GROUP BY ID
HAVING COUNT(DISTINCT ParkingArea.NID) = 1) AS details,
(SELECT RID, Apartment.NID FROM Resident, Apartment
WHERE Resident.StreetName = Apartment.StreetName AND Resident.Number = Apartment.Number AND Resident.door = Apartment.Door) AS place
WHERE details.RID = place.RID AND details.NID = place.NID AND Resident.RID = details.RID

--Q8
SELECT RID, FirstName, LastName
FROM Resident, 
(SELECT ID, COUNT(DISTINCT CarParking.AID) AS parkcount FROM CarParking, Car WHERE CarParking.CID = Car.CID GROUP BY ID) AS park, 
(SELECT COUNT(DISTINCT CarParking.AID) AS totalparkcount FROM CarParking) AS totalpark
WHERE Resident.RID = park.ID AND park.parkcount = totalpark.totalparkcount

--Q9
CREATE VIEW r_ngbrhd AS
SELECT * 
FROM Neighborhood
WHERE Neighborhood.Name like 'R%';
