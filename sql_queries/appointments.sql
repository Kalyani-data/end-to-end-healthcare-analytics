SELECT * FROM healthcaredb.appointments;

SELECT
    SUM(CASE WHEN AppointmentID IS NULL THEN 1 ELSE 0 END) AS Null_AppointmentID,
    SUM(CASE WHEN PatientID IS NULL THEN 1 ELSE 0 END) AS Null_PatientID,
    SUM(CASE WHEN DoctorID IS NULL THEN 1 ELSE 0 END) AS Null_DoctorID,
    SUM(CASE WHEN AppointmentDate IS NULL THEN 1 ELSE 0 END) AS Null_AppointmentDate,
    SUM(CASE WHEN Status IS NULL THEN 1 ELSE 0 END) AS Null_Status,
    SUM(CASE WHEN AppointmentType IS NULL THEN 1 ELSE 0 END) AS Null_AppointmentType,
    SUM(CASE WHEN Duration IS NULL THEN 1 ELSE 0 END) AS Null_Duration,
    SUM(CASE WHEN Room IS NULL THEN 1 ELSE 0 END) AS Null_Room,
    SUM(CASE WHEN VisitPurpose IS NULL THEN 1 ELSE 0 END) AS Null_VisitPurpose,
    SUM(CASE WHEN NoShowReason IS NULL THEN 1 ELSE 0 END) AS Null_NoShowReason
FROM Appointments;


select count(*) as count from appointments; 

select  Status , Count(*) as count from appointments group by status order by count desc ; 

select AppointmentType, count(*) as count from appointments group by AppointmentType order by count desc; 

select VisitPurpose , count(*) as count from appointments group by Visitpurpose order by count desc ; 

select 
      date_format(AppointmentDate,"%Y-%M") as YearMonth,
      count(*)  as count 
      from  Appointments 
      Group by YearMonth 
      order by YearMonth
      
select 
      date_format(AppointmentDate,"%Y-%M") as YearMonth,
      count(*) as count 
      from  Appointments  where status = "Completed"
      Group by YearMonth 
      
select 
	date_format(AppointmentDate,"%Y-%M") as YearMonth,
    AppointmentType,
    count(*)  as count 
    from Appointments
    group by YearMonth , AppointmentType

select 
	date_format(AppointmentDate,"%Y-%M") as YearMonth,
    DoctorID,
    count(*) as count 
    from Appointments 
    group by YearMonth, DoctorID

select 
    concat(year(AppointmentDate),"Q", quarter(AppointmentDate)) as YearQuarter,
    count(*)
    from Appointments 
    group by YearQuarter
    
    
select 
   patientID,count(*) as VisitCount 
   from Appointments where Status = "completed"
   group by PatientID
   Having VisitCount > 1
   order by VisitCount Desc; 
   
SELECT 
    PatientID,
    DATEDIFF(MAX(AppointmentDate), MIN(AppointmentDate)) AS DaysBetweenFirstAndLastVisit,
    COUNT(*) AS TotalVisits
FROM Appointments
GROUP BY PatientID
HAVING TotalVisits > 1;


select 
	patientID,
    count(*) as count
    from appointments 
    where Status = "No-Show"
    group by PatientId 
    having count>=4;
    
select DoctorID , count(*) 
from Appointments where Status = "completed" 
group by DoctorID 
order by count(*) desc ; 

select
  DoctorID,
  count(*) AS TotalAppointments,
  sum(Case when Status = "completed" then 1 else 0 end) as completedAppointments ,
  round(sum(Case when Status = "completed" then 1 else 0 end) / count(*), 2) AS CompletionRate
from Appointments
group by DoctorID;

