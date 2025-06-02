SELECT * FROM healthcaredb.billing;

SELECT
  COUNT(*) AS TotalRows,
  SUM(CASE WHEN BillID IS NULL THEN 1 ELSE 0 END) AS Null_BillID,
  SUM(CASE WHEN AppointmentID IS NULL THEN 1 ELSE 0 END) AS Null_AppointmentID,
  SUM(CASE WHEN PatientID IS NULL THEN 1 ELSE 0 END) AS Null_PatientID,
  SUM(CASE WHEN DoctorID IS NULL THEN 1 ELSE 0 END) AS Null_DoctorID,
  SUM(CASE WHEN BillingDate IS NULL THEN 1 ELSE 0 END) AS Null_BillingDate,
  SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END) AS Null_Amount,
  SUM(CASE WHEN InsuranceCoveredAmount IS NULL THEN 1 ELSE 0 END) AS Null_InsuranceCoveredAmount,
  SUM(CASE WHEN PaidAmount IS NULL THEN 1 ELSE 0 END) AS Null_PaidAmount,
  SUM(CASE WHEN TotalSettledAmount IS NULL THEN 1 ELSE 0 END) AS Null_TotalSettledAmount,
  SUM(CASE WHEN PaymentMethod IS NULL THEN 1 ELSE 0 END) AS Null_PaymentMethod,
  SUM(CASE WHEN PaymentStatus IS NULL THEN 1 ELSE 0 END) AS Null_PaymentStatus,
  SUM(CASE WHEN DueDate IS NULL THEN 1 ELSE 0 END) AS Null_DueDate,
  SUM(CASE WHEN Notes IS NULL THEN 1 ELSE 0 END) AS Null_Notes
FROM Billing;

SELECT Amount 
FROM Billing
WHERE Amount < 0;

Update billing 
set Amount = Abs(Amount)
where Amount < 0 ;

Select Amount from billing where Amount < 0 ; 

Select * from billing; 

select InsuranceCoveredAmount from billing 
where InsuranceCoveredAmount < 0 ; 

select count(*)   from billing 
where InsuranceCoveredAmount < 0 ;

update billing 
set InsuranceCoveredAmount = Abs(InsuranceCoveredAmount)
where InsuranceCoveredAmount < 0;

select count(*)   from billing 
where PaidAmount < 0 ;

select count(*)   from billing 
where PaidAmount < 0 ;

select TotalSettledAmount from billing 
where TotalSettledAmount < 0 ;

update billing 
set TotalSettledAmount = abs(TotalSettledAmount) 
where TotalSettledAmount < 0 ; 

select TotalSettledAmount from billing 
where InsuranceCoveredAmount + PaidAmount != TotalSettledAmount; 

select count(*) from billing where InsuranceCoveredAmount + paidAmount != TotalSettledAmount; 

update billing 
set TotalSettledAmount = InsuranceCoveredAmount + PaidAmount 
where InsurancecoveredAmount + PaidAmount != TotalSettledAmount ;


select Amount , TotalSettledAmount , PaymentStatus 
from billing where Amount != TotalSettledAmount and PaymentStatus = "Paid"; 

select count(*)
from billing where Amount != TotalSettledAmount and PaymentStatus = "Paid"; 

select count(*)
from billing where Amount < TotalSettledAmount ;

select Amount , TotalSettledAmount , PaymentStatus 
from billing where Amount < TotalSettledAmount and PaymentStatus = "Paid"; 


SELECT *
FROM Billing
WHERE PaymentStatus = 'Paid'
  AND (
    TotalSettledAmount < Amount
    OR TotalSettledAmount > Amount
    OR TotalSettledAmount = 0
  );
  
  
UPDATE Billing
SET PaymentStatus = CASE
    WHEN TotalSettledAmount = 0 THEN 'Pending'
    WHEN TotalSettledAmount < Amount THEN 'PartiallyPaid'
    WHEN TotalSettledAmount > Amount THEN 'Overpaid'
    ELSE PaymentStatus
END
WHERE PaymentStatus = 'Paid'
  AND 
     Amount != TotalSettledAmount
     
SELECT COUNT(*) AS InvalidPaymentStatusCount
FROM Billing
WHERE NOT (
    (Amount = TotalSettledAmount AND PaymentStatus = 'Paid') OR
    (Amount > TotalSettledAmount AND TotalSettledAmount > 0 AND PaymentStatus = 'PartiallyPaid') OR
    (TotalSettledAmount = 0 AND PaymentStatus = 'Pending') OR
    (TotalSettledAmount > Amount AND PaymentStatus = 'Overpaid')
);

SELECT *
FROM Billing
WHERE NOT (
    (Amount = TotalSettledAmount AND PaymentStatus = 'Paid') OR
    (Amount > TotalSettledAmount AND TotalSettledAmount > 0 AND PaymentStatus = 'PartiallyPaid') OR
    (TotalSettledAmount = 0 AND PaymentStatus = 'Pending') OR
    (TotalSettledAmount > Amount AND PaymentStatus = 'Overpaid')
);

Select * from billing where TotalSettledAmount = 0 ; 

UPDATE Billing
SET PaymentStatus = 
    CASE
        WHEN TotalSettledAmount = 0 THEN 'Pending'
        WHEN Amount = TotalSettledAmount THEN 'Paid'
        WHEN Amount > TotalSettledAmount THEN 'PartiallyPaid'
        WHEN TotalSettledAmount > Amount THEN 'Overpaid'
        ELSE PaymentStatus
    END;
    
select * from Billing where paymentMethod = "Insurance";

select PaymentMethod , count(*) as count from billing group by PaymentMethod order by count desc; 

select *  from billing where TotalSettledAmount = 0; 

select * from billing where PaymentStatus = "pending";

update billing 
set PaymentMethod = "Not Applicable"
where PaymentStatus = "Pending"; 

select * from billing where Amount = InsuranceCoveredAmount and PaymentMethod != "Insurance"; 

select distinct PaymentStatus from billing; 

select Paymentstatus , count(*) from billing group by PaymentStatus; 

select distinct Notes from billing;

select Notes , PaymentStatus from billing where PaymentStatus = "PartiallyPaid";


select 
    count(*) , 
    sum(Amount) as TotalBill,
    sum(InsuranceCoveredAmount) as TotalInsurance,
    sum(PaidAmount) as TotalPaid,
    sum(TotalSettledAmount) as TotalSettled,
    sum(Amount - TotalSettledAmount ) as TotalDue
from Billing ;




select 
	PaymentMethod,
    count(*) as count, 
    sum(Amount) as TotalBill,
    sum(PaidAmount) as TotalPaid,
    sum(TotalSettledAmount) as TotalSettled,
    sum(Amount - TotalSettledAmount) as TotalDue
from Billing
group by PaymentMethod
order by TotalSettled Desc;

select 
	PaymentStatus,
    count(*) as count, 
    sum(Amount) as TotalBill,
    sum(PaidAmount) as TotalPaid,
    sum(TotalSettledAmount) as TotalSettled,
    sum(Amount - TotalSettledAmount) as TotalDue
from Billing
group by PaymentStatus
order by TotalSettled Desc;

select 
	date_format(BillingDate,"%Y-%M") as BillingMonth,
    sum(TotalSettledAmount) as MonthlyRevenue
    from billing 
    group by BillingMonth; 
    
select 
	concat(year(BillingDate),"Q", quarter(BillingDate)) as BillingQuarter,
    sum(TotalSettledAmount) as MonthlyRevenue
    from billing 
    group by BillingQuarter; 



select * , Round(InsuranceCoveredAmount / Amount,2) as CoverageRatio 
from Billing where InsuranceCoveredAmount / Amount < 0.5; 
      
select 
     date_format(BillingDate,"%Y-%m") as BillingMonth,
     Paymentmethod,
     sum(TotalSettledAmount) as Revenue
     from billing 
     group by BillingMonth,Paymentmethod
     order By billingMonth, Revenue desc;
     
