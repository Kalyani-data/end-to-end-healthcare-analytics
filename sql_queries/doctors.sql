SELECT * FROM healthcaredb.doctors;

Update Doctors 
set 
	DoctorName = trim(DoctorName),
    Specialty = trim(Specialty),
    HospitalAffiliation = trim(HospitalAffiliation),
    Location = trim(Location);
    
select count(*) ;

SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN DoctorName IS NULL THEN 1 ELSE 0 END) AS Null_DoctorName,
    Sum(Case when specialty is Null then 1 else 0 end) as null_Specialty,
    sum(case when phone is null then 1 else 0 end) as null_phone,
    sum(case when yearsOfExperience is null then 1 else 0 end) as null_YearOfAffliation,
    sum(case when Location is null then 1 else 0 end) as null_Location,
    sum(case when Rating is null then 1 else 0 end) as null_Ration
    from doctors; 
    
SELECT 
    DoctorID,
    Phone AS OriginalPhone,
    REGEXP_REPLACE(Phone, '[^0-9]', '') AS CleanedPhone
FROM Doctors;

UPDATE doctors
SET Phone = RIGHT(REGEXP_REPLACE(Phone, '[^0-9]', ''), 10)
WHERE LENGTH(REGEXP_REPLACE(Phone, '[^0-9]', '')) > 10;

SELECT DoctorId, Phone
FROM Doctors
WHERE LENGTH(Phone) = 10 AND LEFT(Phone, 1) NOT IN ('6', '7', '8', '9');

UPDATE Doctors
SET Phone = NULL
WHERE Phone LIKE '0%';

select phone from doctors; 

update doctors 
set Phone = "Unknown"
where Phone is null; 

select count(*) from doctors where YearsOfExperience is null ; 


WITH OrderedExperience AS (
  SELECT 
    YearsOfExperience,
    ROW_NUMBER() OVER (ORDER BY YearsOfExperience) AS row_num,
    COUNT(*) OVER () AS total_rows
  FROM Doctors
  WHERE YearsOfExperience IS NOT NULL
)

SELECT AVG(YearsOfExperience) AS MedianYearsOfExperience
FROM OrderedExperience
WHERE row_num IN (
  FLOOR((total_rows + 1) / 2),
  CEIL((total_rows + 1) / 2)
);

update doctors 
set YearsOfExperience = 23 
where YearsOfExperience is null; 

select specialty ,count(*) as count from doctors group by specialty order by count desc; 

select specialty,
round(avg(YearsOfExperience),1) as AvgExperience,
round(avg(Rating),1) as AvgRating, 
count(*) as count from doctors 
group by specialty 
order by count DESC;








    
    
