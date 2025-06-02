SELECT * FROM healthcaredb.prescriptions;

SELECT
  COUNT(*) AS TotalRows,
  SUM(CASE WHEN PrescriptionID IS NULL THEN 1 ELSE 0 END) AS Null_PrescriptionID,
  SUM(CASE WHEN AppointmentID IS NULL THEN 1 ELSE 0 END) AS Null_AppointmentID,
  SUM(CASE WHEN Medication IS NULL THEN 1 ELSE 0 END) AS Null_Medication,
  SUM(CASE WHEN Dosage IS NULL THEN 1 ELSE 0 END) AS Null_Dosage,
  SUM(CASE WHEN Frequency IS NULL THEN 1 ELSE 0 END) AS Null_Frequency,
  SUM(CASE WHEN StartDate IS NULL THEN 1 ELSE 0 END) AS Null_StartDate,
  SUM(CASE WHEN EndDate IS NULL THEN 1 ELSE 0 END) AS Null_EndDate,
  SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Null_Quantity
FROM Prescriptions;



