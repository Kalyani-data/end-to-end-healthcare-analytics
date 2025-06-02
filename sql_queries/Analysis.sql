
select 
	date_format(AppointmentDate,"%Y-%M") as YearMonth,
    Specialty,
    count(*) as count 
    from Appointments join Doctors on Appointments.DoctorID = Doctors.DoctorId
    group by YearMonth, Specialty;

select 
    d.DoctorID,
    d.DoctorName,
    d.Specialty,
    ROUND(SUM(b.TotalSettledAmount), 2) AS TotalRevenue
FROM Billing b
JOIN Doctors d ON b.DoctorID = d.DoctorID
GROUP BY d.DoctorID,  d.DoctorName, d.Specialty
ORDER BY TotalRevenue DESC;


select 
  Specialty,
  sum(TotalSettledAmount) as TotalRevenue
  from Billing join Doctors on Doctors.DoctorID = Billing.DoctorID
  group by Specialty 
  order by TotalRevenue Desc; 
  
select 
     p.Gender, 
     Count(*) as NoShowCount 
     from appointments as a join patients as p on a.PatientID = p.PatientId 
     where a.Status = "No-Show"
     group By Gender ; 
     
select 
     p.InsuranceType,
     count(*) as count 
     from appointments as a join patients as p  on a.PatientID = p.PatientID
     group by p.InsuranceType
     order by count desc; 
     
select 
     p.InsuranceType,
     count(*) as count,
     sum(b.Amount) as TotalBilled,
     sum(b.TotalSettledAmount) as TotalSettled,
     sum(b.Amount - b.TotalSettledAmount) as TotalDue
     from billing b join patients p on b.patientID  = p.patientID
     group by InsuranceType;
     

select a.PatientId , d.DiagnosisType, count(*) as count 
from Diagnoses d join appointments a on d.AppointmentID = a.AppointmentID 
group by a.PatientID , d.DiagnosisType having count>=2; 



select d.DoctorID,
	d.DoctorName,
    d.Specialty,
    d.YearsOfExperience,
    sum(b.TotalSettledAmount) as TotalRevenue
    from billing b join doctors d on b.DoctorID = d.DoctorID
    group by d.DoctorID, d.DoctorName, d.Specialty,d.YearsOfExperience
    order by TotalRevenue desc; 
    

select 
      d.Specialty,
      p.Medication,
      count(*) as prescriptionCount
      from Prescriptions p join appointments a  on p.AppointmentID = a.AppointmentID
      join doctors d on a.DoctorID = d.DoctorID
      group by d.Specialty , p.medication 
      order by d.Specialty , p.medication  desc; 
      
      
SELECT *
FROM Diagnoses d
LEFT JOIN Appointments a ON d.AppointmentID = a.AppointmentID
WHERE a.AppointmentID IS NULL;

SELECT *
FROM Prescriptions pr
LEFT JOIN Diagnoses d ON pr.AppointmentID = d.AppointmentID
WHERE d.AppointmentID IS NULL;



     
     
     


    

     



    

    
     