SELECT * FROM healthcaredb.diagnoses;

SELECT
  COUNT(*) AS TotalRows,
  SUM(CASE WHEN DiagnosisID IS NULL THEN 1 ELSE 0 END) AS Null_DiagnosisID,
  SUM(CASE WHEN AppointmentID IS NULL THEN 1 ELSE 0 END) AS Null_AppointmentID,
  SUM(CASE WHEN DiagnosisType IS NULL THEN 1 ELSE 0 END) AS Null_DiagnosisType,
  SUM(CASE WHEN DiagnosisCode IS NULL THEN 1 ELSE 0 END) AS Null_DiagnosisCode,
  SUM(CASE WHEN Severity IS NULL THEN 1 ELSE 0 END) AS Null_Severity,
  SUM(CASE WHEN AdditionalTestsRequired IS NULL THEN 1 ELSE 0 END) AS Null_AdditionalTestsRequired,
  SUM(CASE WHEN DiagnosisDate IS NULL THEN 1 ELSE 0 END) AS Null_DiagnosisDate
FROM Diagnoses;

select 
     DiagnosisType,
     count(*) as count
     from Diagnoses
     group by Diagnosistype
     order by count desc
     
     

      
