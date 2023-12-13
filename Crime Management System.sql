--Activity - Coding Challenge.
--Task Name - Crime Management System.

CREATE DATABASE CrimeManagement;
USE CrimeManagement;

CREATE TABLE Crime (
CrimeID INT PRIMARY KEY,
IncidentType VARCHAR(255),
IncidentDate DATE,
Location VARCHAR(255),
Description TEXT,
Status VARCHAR(20)
);

CREATE TABLE Victim (
VictimID INT PRIMARY KEY,
CrimeID INT,
Name VARCHAR(255),
ContactInfo VARCHAR(255),
Injuries VARCHAR(255),
FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

CREATE TABLE Suspect (
SuspectID INT PRIMARY KEY,
CrimeID INT,
Name VARCHAR(255),
Description TEXT,
CriminalHistory TEXT,
FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status) VALUES
(1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
(2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under Investigation'),
(3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed');

INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries) VALUES
(1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'),
(2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'),
(3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None');

INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory) VALUES
(1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'),
(2, 2, 'Unknown', 'Investigation ongoing', NULL),
(3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests');

--1. Select all open incidents.
SELECT*FROM Crime
WHERE status ='Open';

--2. Find the total number of incidents.
SELECT COUNT(*) AS TotalIncidents
FROM Crime;

--3. List all unique incident types.
SELECT DISTINCT IncidentType
FROM Crime;

--4. Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'.
SELECT * FROM Crime
WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';	

--5. List persons involved in incidents in descending order of age.
ALTER TABLE Victim
ADD VictimAge INT;

ALTER TABLE Suspect
ADD SuspectAge int;

UPDATE Victim
SET VictimAge=25
WHERE VictimID=1;

UPDATE Victim
SET VictimAge=35
WHERE VictimID=2;

UPDATE Victim
SET VictimAge=57
WHERE VictimID=3;

UPDATE Suspect
SET SuspectAge=46
WHERE SuspectID=1;

UPDATE Suspect
SET SuspectAge=23
WHERE SuspectID=2;

UPDATE Suspect
SET SuspectAge=76
WHERE SuspectID=3;

SELECT VictimID AS PersonID, Name, VictimAge
FROM Victim
ORDER BY VictimAge DESC;

SELECT SuspectID AS PersonID, Name, SuspectAge
FROM Suspect
ORDER BY SuspectAge DESC;

--6. Find the average age of persons involved in incidents.
SELECT AVG(VictimAge) AS VictimsAverageAge
FROM Victim;

SELECT AVG(SuspectAge) AS SuspectsAverageAge
FROM Suspect;

--7. List incident types and their counts, only for open cases.
SELECT IncidentType, COUNT(CrimeID) AS CountOfOpenCases
FROM Crime
WHERE Status='Open'
GROUP BY Crime.IncidentType;

--8. Find persons with names containing 'Doe'.
SELECT VictimID,Name,VictimAge
FROM Victim
WHERE Name LIKE '%Doe%'
UNION ALL
SELECT SuspectID,Name,SuspectAge
FROM Suspect
WHERE Name LIKE '%Doe%';

--9. Retrieve the names of persons involved in open cases and closed cases.
SELECT V.VictimID,V.Name,S.SuspectID,S.Name,Status
FROM Victim V
JOIN Crime C ON C.CrimeID=V.CrimeID
JOIN Suspect S ON S.CrimeID=C.CrimeID
WHERE Status='Open' OR Status='Closed';

--10. List incident types where there are persons aged 30 or 35 involved.
SELECT C.CrimeID, C.IncidentType,V.VictimAge,S.SuspectAge
FROM Crime C
LEFT JOIN Victim V ON V.CrimeID=C.CrimeID
LEFT JOIN Suspect S ON S.CrimeID=V.CrimeID
WHERE VictimAge=30 OR SuspectAge=30 OR VictimAge=35 OR SuspectAge=35;

--11. Find persons involved in incidents of the same type as 'Robbery'.
SELECT V.VictimID,V.Name,S.SuspectID,S.Name
FROM Victim V
JOIN Crime C ON C.CrimeID=V.CrimeID
JOIN Suspect S ON S.CrimeID=C.CrimeID
WHERE IncidentType='Robbery';

--12. List incident types with more than one open case.
SELECT IncidentType, COUNT(*) AS OpenCaseCount
FROM Crime
WHERE Status = 'Open'
GROUP BY IncidentType
HAVING COUNT(*) > 1;
-- (No such data is avialble)

--13. List all incidents with suspects whose names also appear as victims in other incidents.
SELECT C.CrimeID, C.IncidentType, V.VictimID, V.Name, S.SuspectID, S.Name
FROM Crime C
JOIN Victim V ON  V.CrimeID = C.CrimeID
JOIN Suspect S ON S.CrimeID = C.CrimeID
WHERE S.Name IN (SELECT Name FROM Victim WHERE CrimeID <> C.CrimeID);
-- (No such data is avialble)

--14. Retrieve all incidents along with victim and suspect details.
SELECT *FROM Crime C
LEFT JOIN Victim V ON C.CrimeID = V.CrimeID
LEFT JOIN Suspect S ON C.CrimeID = S.CrimeID;

--15. Find incidents where the suspect is older than any victim.
SELECT C.CrimeID,C.IncidentType,C.IncidentDate,C.Location,C.Description,C.Status,V.VictimID,V.Name,V.VictimAge,S.SuspectID,S.Name,S.SuspectAge 
FROM Crime C
LEFT JOIN Victim V ON C.CrimeID = V.CrimeID
LEFT JOIN Suspect S ON C.CrimeID = S.CrimeID
WHERE S.SuspectAge > V.VictimAge;

--16. Find suspects involved in multiple incidents.
SELECT S.SuspectID, S.Name, COUNT(C.CrimeID) AS IncidentCount
FROM Suspect S
JOIN Crime C ON C.CrimeID=S.CrimeID
GROUP BY S.SuspectID, S.Name
HAVING COUNT(C.CrimeID) > 1;
-- (No such data is avialble)

--17. List incidents with no suspects involved.
SELECT C.* FROM Crime C
LEFT JOIN Suspect S ON C.CrimeID = S.CrimeID
WHERE S.SuspectID IS NULL;
-- (No such data is avialble)

--18. List all cases where at least one incident is of type 'Homicide' and all other incidents are of type 'Robbery'.
SELECT*FROM Crime C
WHERE C.IncidentType = 'Homicide'
   OR (C.IncidentType = 'Robbery' AND NOT EXISTS (
       SELECT 1 FROM Crime C2
       WHERE C2.CrimeID = C.CrimeID
         AND C2.IncidentType = 'Homicide')
);

--19. Retrieve a list of all incidents and the associated suspects, showing suspects for each incident, or 'No Suspect' if there are none.
SELECT C.*, ISNULL(S.Name, 'No Suspect') AS SuspectName
FROM Crime C
LEFT JOIN Suspect S ON C.CrimeID = S.CrimeID AND S.Name <> 'Unknown';

--20. List all suspects who have been involved in incidents with incident types 'Robbery' or 'Assault'
SELECT S.SuspectID,C.CrimeID,S.Name,S.SuspectAge
FROM Suspect S
JOIN Crime C ON C.CrimeID=S.CrimeID
WHERE IncidentType IN ('Robbery','Assault');
