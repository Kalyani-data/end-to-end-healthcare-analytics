SELECT * FROM healthcaredb.patients;

UPDATE Patients
SET 
    PatientName = TRIM(PatientName),
    Gender = TRIM(Gender),
    Phone = TRIM(Phone),
    Email = TRIM(Email),
    Address = TRIM(Address),
    InsuranceType = TRIM(InsuranceType),
    EmergencyContact = TRIM(EmergencyContact),
    Status = TRIM(Status);
    
SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN PatientName IS NULL THEN 1 ELSE 0 END) AS Null_PatientName,
    SUM(CASE WHEN DOB IS NULL THEN 1 ELSE 0 END) AS Null_DOB,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
    SUM(CASE WHEN Phone IS NULL THEN 1 ELSE 0 END) AS Null_Phone,
    SUM(CASE WHEN Email IS NULL THEN 1 ELSE 0 END) AS Null_Email,
    SUM(CASE WHEN Address IS NULL THEN 1 ELSE 0 END) AS Null_Address,
    SUM(CASE WHEN InsuranceType IS NULL THEN 1 ELSE 0 END) AS Null_InsuranceType,
    SUM(CASE WHEN EmergencyContact IS NULL THEN 1 ELSE 0 END) AS Null_EmergencyContact,
    SUM(CASE WHEN LastVisit IS NULL THEN 1 ELSE 0 END) AS Null_LastVisit,
    SUM(CASE WHEN Status IS NULL THEN 1 ELSE 0 END) AS Null_Status
FROM Patients;

update patients set InsuranceType = "Unknown"  where InsuranceType IS NULL; 

select * from patients; 

select count(InsuranceType) from patients where InsuranceType Is NULL ; 

SELECT 
    PatientID,
    Phone AS OriginalPhone,
    REGEXP_REPLACE(Phone, '[^0-9]', '') AS CleanedPhone
FROM Patients;

UPDATE Patients
SET Phone = RIGHT(REGEXP_REPLACE(Phone, '[^0-9]', ''), 10)
WHERE LENGTH(REGEXP_REPLACE(Phone, '[^0-9]', '')) > 10;

select Phone from patients; 

SELECT PatientID, Phone
FROM Patients
WHERE LENGTH(Phone) = 10 AND LEFT(Phone, 1) NOT IN ('6', '7', '8', '9');

UPDATE Patients
SET Phone = NULL
WHERE LENGTH(Phone) = 10 AND LEFT(Phone, 1) NOT IN ('6', '7', '8', '9');

SELECT PatientID,Phone
FROM Patients
WHERE LENGTH(Phone) != 10 OR LEFT(Phone, 1) NOT IN ('6', '7', '8', '9');

select PatientID,Phone from patients; 

select count(*) from patients where Phone is null ;

SELECT 
    PatientID,
    EmergencyContact AS OriginalPhone,
    REGEXP_REPLACE(EmergencyContact, '[^0-9]', '') AS CleanedPhone
FROM Patients;

UPDATE Patients
SET EmergencyContact = RIGHT(REGEXP_REPLACE(EmergencyContact, '[^0-9]', ''), 10)
WHERE LENGTH(REGEXP_REPLACE(EmergencyContact, '[^0-9]', '')) > 10;

SELECT PatientID, EmergencyContact
FROM Patients
WHERE LENGTH(EmergencyContact) = 10 AND LEFT(EmergencyContact, 1) NOT IN ('6', '7', '8', '9');

UPDATE Patients
SET EmergencyContact = NULL
WHERE LENGTH(EmergencyContact) = 10 AND LEFT(EmergencyContact, 1) NOT IN ('6', '7', '8', '9');

SELECT PatientID,EmergencyContact
FROM Patients
WHERE LENGTH(EmergencyContact) != 10 OR LEFT(EmergencyContact, 1) NOT IN ('6', '7', '8', '9');

select PatientID,EmergencyContact from patients; 

select count(*) from patients where Phone is null ;

SELECT PatientID, Address
FROM Patients
WHERE Address IS NOT NULL
  AND Address NOT LIKE 'H.NO.%';
  

update Patients
set Address = Concat("H.NO. ", Address)
where Address is Not null
and Address NOT LIKE 'H.NO.%';

select Address from patients;

Update Patients 
set Address = concat("H.NO. ", Substring(Address,5))
where Address  LIKE "H.No.%"; 

UPDATE Patients
SET Address = REPLACE(Address, 'H.NO. .', 'H.NO. ')
WHERE Address LIKE 'H.NO. .%';

SELECT Address
FROM Patients
WHERE Address RLIKE '[a-zA-Z]+ [0-9]{6}$';



SELECT
  Address,
  CASE
    WHEN Address REGEXP '-[0-9]{6}$' THEN Address
    ELSE
      CONCAT(
        SUBSTRING(Address, 1, LENGTH(Address) - LENGTH(SUBSTRING_INDEX(Address, ' ', -1)) - 1),
        '-',
        SUBSTRING_INDEX(Address, ' ', -1)
      )
  END AS Address_With_Dash
FROM Patients
LIMIT 10;

UPDATE Patients
SET Address = CONCAT(
    SUBSTRING(Address, 1, LENGTH(Address) - LENGTH(SUBSTRING_INDEX(Address, ' ', -1)) - 1),
    '-',
    SUBSTRING_INDEX(Address, ' ', -1)
)
WHERE Address NOT REGEXP '-[0-9]{6}$'
AND Address REGEXP '[0-9]{6}$';

select count(*) from patients where LastVisit is null;

SELECT PatientID, LastVisit
FROM Patients
WHERE LastVisit > CURDATE();

SELECT PatientID, DOB, LastVisit
FROM Patients
WHERE LastVisit < DOB;

select LastVisit , Status from Patients where LastVisit is Null; 

UPDATE Patients p
SET LastVisit = (
    SELECT MAX(a.AppointmentDate)
    FROM Appointments a
    WHERE a.PatientID = p.PatientID
)
WHERE p.LastVisit IS NULL
AND EXISTS (
    SELECT 1
    FROM Appointments a2
    WHERE a2.PatientID = p.PatientID
);


SELECT 
    PatientID, 
    PatientName, 
    LastVisit,
    (SELECT MAX(AppointmentDate) FROM Appointments a WHERE a.PatientID = p.PatientID) AS LatestAppointmentDate
FROM Patients p
WHERE LastVisit IS NOT NULL;

SELECT PatientID, LastVisit,status FROM Patients WHERE LastVisit IS NULL; 

select PatientID, LastVisit, status from patients; 

SELECT PatientID, LastVisit, Status
FROM Patients
WHERE Status = 'Inactive'
  AND LastVisit IS NOT NULL
  AND LastVisit >= DATE('2025-05-13') - INTERVAL 180 DAY;

SELECT PatientID, LastVisit, Status
FROM Patients
WHERE Status = 'Active'
  AND (LastVisit IS NULL OR LastVisit < DATE('2025-05-13') - INTERVAL 180 DAY);
  
SELECT COUNT(*) AS IncorrectlyMarkedInactive
FROM Patients
WHERE Status = 'Inactive'
  AND LastVisit IS NOT NULL
  AND LastVisit >= DATE('2025-05-13') - INTERVAL 180 DAY;

UPDATE Patients
SET Status = 'Active'
WHERE Status = 'Inactive'
  AND LastVisit IS NOT NULL
  AND LastVisit >= DATE('2025-05-13') - INTERVAL 180 DAY;
  
  
update patients 
set Phone = "Unknown"
where Phone is null; 

update patients 
set EmergencyContact = "Unknown"
where EmergencyContact is null; 
  

select Count(*) from Patients; 

select count(*) as MissingDOB from patients where DOB is null; 

select Gender,count(*) as Count from patients group by Gender; 

select InsuranceType, count(*) as Count from patients group by InsuranceType order by count desc; 

select Status , count(*) as Count from patients group by Status; 

SELECT
  CASE 
    WHEN DOB IS NULL THEN 'Unknown'
    WHEN TIMESTAMPDIFF(YEAR, DOB, CURDATE()) < 18 THEN '0-17'
    WHEN TIMESTAMPDIFF(YEAR, DOB, CURDATE()) BETWEEN 18 AND 35 THEN '18-35'
    WHEN TIMESTAMPDIFF(YEAR, DOB, CURDATE()) BETWEEN 36 AND 50 THEN '36-50'
    WHEN TIMESTAMPDIFF(YEAR, DOB, CURDATE()) BETWEEN 51 AND 65 THEN '51-65'
    ELSE '66+' 
  END AS AgeGroup,
  COUNT(*) AS NumberOfPatients
FROM Patients
GROUP BY AgeGroup;


select PatientID from patients where Status = "Inactive";
 




































