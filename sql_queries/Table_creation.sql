Drop Database HealthcareDB; 

CREATE DATABASE HealthcareDB;
USE HealthcareDB;

CREATE TABLE Patients (
    PatientID VARCHAR(10) PRIMARY KEY,
    PatientName VARCHAR(100) NOT NULL,
    DOB DATE NULL,
    Gender VARCHAR(10) NULL,
    Phone VARCHAR(20) NULL,
    Email VARCHAR(100) NULL,
    Address TEXT NULL,
    InsuranceType VARCHAR(50) NULL,
    EmergencyContact VARCHAR(20) NULL,
    LastVisit DATE NULL,
    Status VARCHAR(20) NULL
);

CREATE TABLE Doctors (
    DoctorID VARCHAR(10) PRIMARY KEY,
    DoctorName VARCHAR(100) NOT NULL,
    Specialty VARCHAR(50) NULL,
    Phone VARCHAR(20) NULL,
    YearsOfExperience INT NULL,
    HospitalAffiliation VARCHAR(100) NULL,
    Location VARCHAR(100) NULL,
    Rating DECIMAL(2,1) NULL
);

CREATE TABLE Appointments (
    AppointmentID VARCHAR(10) PRIMARY KEY,
    PatientID VARCHAR(10) NOT NULL,
    DoctorID VARCHAR(10) NOT NULL,
    AppointmentDate DATE NOT NULL,
    Status VARCHAR(20) NULL,
    AppointmentType VARCHAR(50) NULL,
    Duration INT NULL,
    Room VARCHAR(20) NULL,
    VisitPurpose VARCHAR(100) NULL,
    NoShowReason VARCHAR(100) NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Diagnoses (
    DiagnosisID VARCHAR(10) PRIMARY KEY,
    AppointmentID VARCHAR(10) NOT NULL,
    DiagnosisType VARCHAR(100) NULL,
    DiagnosisCode VARCHAR(20) NULL,
    Severity VARCHAR(20) NULL,
    AdditionalTestsRequired BOOLEAN NULL,
    DiagnosisDate DATE NULL,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

CREATE TABLE Prescriptions (
    PrescriptionID VARCHAR(10) PRIMARY KEY,
    AppointmentID VARCHAR(10) NOT NULL,
    Medication VARCHAR(100) NULL,
    Dosage VARCHAR(50) NULL,
    Frequency VARCHAR(50) NULL,
    StartDate DATE NULL,
    EndDate DATE NULL,
    Quantity INT NULL,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

CREATE TABLE Billing (
    BillID VARCHAR(10) PRIMARY KEY,
    AppointmentID VARCHAR(10) NOT NULL,
    PatientID VARCHAR(10) NOT NULL,
    DoctorID VARCHAR(10) NOT NULL,
    BillingDate DATE  NULL,
    Amount DECIMAL(10,2) NULL,
    InsuranceCoveredAmount DECIMAL(10,2) NULL,
    PaidAmount DECIMAL(10,2) NULL,
    TotalSettledAmount DECIMAL(10,2) NULL,
    PaymentMethod VARCHAR(50) NULL,
    PaymentStatus VARCHAR(50) NULL,
    DueDate DATE NULL,
    Notes TEXT NULL,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);













