import pandas as pd
import random
from faker import Faker
from datetime import timedelta, date
import uuid

fake = Faker('en_IN')

# Configuration
NUM_PATIENTS = 1000
NUM_DOCTORS = 100
NUM_APPOINTMENTS = 5000
NUM_DIAGNOSES = 5000
NUM_PRESCRIPTIONS = 5000
NUM_BILLINGS = 5000

# Specialties and diagnosis mapping
specialties = {
    'Cardiology': ['Hypertension', 'Heart Disease', 'Arrhythmia'],
    'Pediatrics': ['Cold', 'Flu', 'Asthma'],
    'General Practice': ['Covid-19', 'Headache', 'General Check', 'Back Pain'],
    'Neurology': ['Migraine', 'Seizure', 'Multiple Sclerosis'],
    'Endocrinology': ['Diabetes', 'Thyroid Disorder'],
    'Dermatology': ['Acne', 'Eczema', 'Psoriasis'],
    'Orthopedics': ['Fracture', 'Arthritis', 'Sprain']
}

diagnosis_medication_map = {
    'Flu': ['Paracetamol', 'Ibuprofen'],
    'Covid-19': ['Remdesivir', 'Paracetamol'],
    'Cold': ['Paracetamol'],
    'Headache': ['Ibuprofen', 'Aspirin'],
    'Migraine': ['Sumatriptan', 'Ibuprofen'],
    'Diabetes': ['Metformin', 'Insulin'],
    'Hypertension': ['Amlodipine', 'Lisinopril'],
    'Heart Disease': ['Atorvastatin', 'Nitroglycerin'],
    'Asthma': ['Albuterol'],
    'Thyroid Disorder': ['Levothyroxine'],
    'Eczema': ['Hydrocortisone'],
    'Psoriasis': ['Methotrexate'],
    'Acne': ['Benzoyl Peroxide'],
    'Fracture': ['Ibuprofen'],
    'Arthritis': ['Naproxen'],
    'Sprain': ['Ibuprofen'],
    'Seizure': ['Lamotrigine'],
    'Multiple Sclerosis': ['Interferon'],
    'Arrhythmia': ['Amiodarone'],
    'Back Pain': ['Ibuprofen'],
    'General Check': ['Multivitamins']
}


# Generate patients first without LastVisit
# === 1. Generate Patients ===
patients = []
for patient_id in range(1, NUM_PATIENTS + 1):
    patient_data = {
        "PatientID": f"P{patient_id:05d}",
        "PatientName": fake.name(),
        "DOB": fake.date_of_birth(minimum_age=15, maximum_age=90),
        "Gender": random.choice(['Male', 'Female']),
        "Phone": fake.phone_number(),
        "Email": fake.email(),
        "Address": fake.address().replace('\n', ', '),
        "InsuranceType": random.choice(['Private', 'Medicare', 'None']),
        "EmergencyContact": fake.phone_number(),
        "LastVisit": None,  # Placeholder for later update
        "Status": None       # Placeholder for later update
    }

    # Inject some imperfections
    if random.random() < 0.1:
        patient_data["Phone"] = None
    if random.random() < 0.05:
        patient_data["DOB"] = None
    if random.random() < 0.1:
        patient_data["InsuranceType"] = None
    if random.random() < 0.1:
        patient_data["PatientName"] = fake.name().replace('a', 'e')
        patient_data["Address"] = patient_data["Address"].replace('Street', 'Streeet')

    patients.append(patient_data)

patients_df = pd.DataFrame(patients)

# Generate doctors
doctors = []
for doctor_id in range(1, NUM_DOCTORS + 1):
    spec = random.choice(list(specialties.keys()))
    doctor_data = {
        "DoctorID": f"DR{doctor_id:05d}",
        "DoctorName": fake.name(),
        "Specialty": spec,
        "Phone": fake.phone_number(),
        "YearsOfExperience": random.randint(5, 40),
        "HospitalAffiliation": fake.company(),
        "Location": fake.city(),
        "Rating": round(random.uniform(3.0, 5.0), 1)
    }

    if random.random() < 0.05:
        doctor_data["Rating"] = round(random.uniform(0.0, 1.0), 1)
    if random.random() < 0.1:
        doctor_data["YearsOfExperience"] = None

    doctors.append(doctor_data)
doctors_df = pd.DataFrame(doctors)

# Generate appointments with dates aligned based on AppointmentID
from datetime import datetime, timedelta
import random

# === 3. Generate Appointments ===
start_date = datetime(2023, 1, 1)
end_date = datetime.now()
total_days = (end_date - start_date).days

appointments = []

for appointment_id in range(1, NUM_APPOINTMENTS + 1):
    doc = random.choice(doctors)

    # Gradually introduce patients: early appointments use low-ID patients
    max_patient_index = int((appointment_id / NUM_APPOINTMENTS) * len(patients))
    if max_patient_index == 0:
        max_patient_index = 1
    smoothed_max = min(len(patients), max_patient_index + random.randint(10, 50))
    patient = random.choice(patients[:smoothed_max])


    days_offset = int(appointment_id * total_days / NUM_APPOINTMENTS)
    appointment_date = start_date + timedelta(days=days_offset)
    appointment_type = random.choice(['Routine Checkup', 'Emergency', 'Follow-up'])
    spec = doc["Specialty"]

    # VisitPurpose logic
    if appointment_type == 'Routine Checkup':
        if spec in ['General Practice', 'Pediatrics', 'Dermatology']:
            visit_purpose = random.choice(['General Check', 'Consultation'])
        elif spec == 'Neurology':
            visit_purpose = 'Consultation'
        else:
            visit_purpose = 'General Check'
    elif appointment_type == 'Emergency':
        if spec in ['Orthopedics', 'Cardiology']:
            visit_purpose = random.choice(['Surgery', 'Emergency Treatment'])
        else:
            visit_purpose = 'Critical Care'
    elif appointment_type == 'Follow-up':
        if spec in ['Endocrinology', 'General Practice', 'Neurology']:
            visit_purpose = 'Medication Review'
        else:
            visit_purpose = 'Consultation'

    # Status and Duration logic
    status_choice = random.random()
    if status_choice < 0.75:
        status = 'Completed'
        if appointment_type == 'Routine Checkup':
            if spec in ['General Practice', 'Pediatrics']:
                duration = random.choice([15, 30])
            elif spec == 'Dermatology':
                duration = random.choice([30, 45])
            elif spec == 'Neurology':
                duration = random.choice([45, 60])
            else:
                duration = random.choice([15, 30, 45])
        elif appointment_type == 'Emergency':
            if spec in ['Orthopedics', 'Cardiology']:
                duration = random.choice([30, 45, 60])
            else:
                duration = random.choice([15, 30, 45])
        elif appointment_type == 'Follow-up':
            if spec in ['Endocrinology', 'General Practice', 'Neurology']:
                duration = random.choice([30, 45])
            else:
                duration = random.choice([15, 30])
        no_show_reason = None
    elif status_choice < 0.90:
        status = 'No-show'
        duration = 0
        no_show_reason = random.choice(['Forgot', 'Unexpected Obligation', 'No Reason', 'Rescheduled'])
    else:
        status = 'Cancelled'
        duration = 0
        no_show_reason = random.choice(['Rescheduled', 'Other'])

    appointment_data = {
        "AppointmentID": f"A{appointment_id:05d}",
        "PatientID": patient["PatientID"],
        "DoctorID": doc["DoctorID"],
        "AppointmentDate": appointment_date,
        "Status": status,
        "AppointmentType": appointment_type,
        "Duration": duration,
        "Room": random.choice(['Room 1', 'Room 2', 'Room 3', 'Room 4']),
        "VisitPurpose": visit_purpose,
        "NoShowReason": no_show_reason
    }

    appointments.append(appointment_data)
    # Ensure all patients are used at least once without increasing appointment count
used_patient_ids = set(appt["PatientID"] for appt in appointments)
all_patient_ids = set(p["PatientID"] for p in patients)

unused_patient_ids = list(all_patient_ids - used_patient_ids)
random.shuffle(unused_patient_ids)

for patient_id in unused_patient_ids:
    # Pick a random appointment and assign it to an unused patient
    random_appointment = random.choice(appointments)
    random_appointment["PatientID"] = patient_id


appointments_df = pd.DataFrame(appointments)

# === 4. Update LastVisit and Patient Status ===
completed_appointments = appointments_df[appointments_df["Status"] == "Completed"]
latest_visits = completed_appointments.groupby("PatientID")["AppointmentDate"].max()
patients_df["LastVisit"] = patients_df["PatientID"].map(latest_visits)

current_date = pd.to_datetime('today')
patients_df["Status"] = patients_df["LastVisit"].apply(
    lambda last_visit: 'Active' if pd.to_datetime(last_visit) >= current_date - timedelta(days=180) else 'Inactive'
)


from collections import defaultdict
import random

# Get only completed appointments
completed_appointments = [appt for appt in appointments if appt["Status"] == "Completed"]

# Group by date
appointments_by_date = defaultdict(list)
for appt in completed_appointments:
    date_key = appt["AppointmentDate"].date()
    appointments_by_date[date_key].append(appt)

# Sort dates, then shuffle appointments within each date group
diagnoses = []
diag_idx = 1

for date in sorted(appointments_by_date.keys()):
    same_day_appointments = appointments_by_date[date]
    random.shuffle(same_day_appointments)

    for appointment in same_day_appointments:
        doc_spec = next((d["Specialty"] for d in doctors if d["DoctorID"] == appointment["DoctorID"]), 'General Practice')
        specialty_diagnoses = specialties.get(doc_spec, ['General Check'])

        if appointment["AppointmentType"] == 'Emergency':
            emergency_pool = specialties['Cardiology'] + specialties['Orthopedics'] + ['Asthma', 'Fracture', 'Stroke']
            possible_diagnoses = list(set(specialty_diagnoses).intersection(emergency_pool))
        elif appointment["AppointmentType"] == 'Routine Checkup':
            routine_pool = specialties['General Practice'] + specialties['Pediatrics'] + ['Migraine', 'Back Pain']
            possible_diagnoses = list(set(specialty_diagnoses).intersection(routine_pool))
        elif appointment["AppointmentType"] == 'Follow-up':
            followup_pool = ['Hypertension', 'Diabetes', 'Asthma', 'Chronic Disease Management']
            possible_diagnoses = list(set(specialty_diagnoses).intersection(followup_pool))
        else:
            possible_diagnoses = specialty_diagnoses

        if not possible_diagnoses:
            possible_diagnoses = specialty_diagnoses

        diag_type = random.choice(possible_diagnoses)
        diag_date = date

        # Severity logic
        if appointment["AppointmentType"] == 'Emergency':
            severity = random.choices(['Moderate', 'Severe'], weights=[0.3, 0.7])[0]
        elif diag_type in ['Fracture', 'Stroke', 'Heart Attack', 'Cancer']:
            severity = random.choices(['Moderate', 'Severe'], weights=[0.4, 0.6])[0]
        elif diag_type in ['Diabetes', 'Hypertension', 'Asthma']:
            severity = random.choices(['Mild', 'Moderate'], weights=[0.5, 0.5])[0]
        elif diag_type in ['Common Cold', 'Back Pain', 'Migraine']:
            severity = random.choices(['Mild', 'Moderate'], weights=[0.8, 0.2])[0]
        else:
            severity = random.choices(['Mild', 'Moderate', 'Severe'], weights=[0.5, 0.3, 0.2])[0]

        # Test requirement logic
        if severity == 'Severe':
            additional_tests = random.choices([1, 0], weights=[0.8, 0.2])[0]
        elif severity == 'Moderate':
            additional_tests = random.choices([1, 0], weights=[0.5, 0.5])[0]
        else:
            additional_tests = random.choices([1, 0], weights=[0.2, 0.8])[0]

        diagnosis_data = {
            "DiagnosisID": f"D{diag_idx:05d}",
            "AppointmentID": appointment["AppointmentID"],
            "DiagnosisType": diag_type,
            "DiagnosisCode": fake.bothify(text='ICD-10 ####'),
            "Severity": severity,
            "AdditionalTestsRequired": additional_tests,
            "DiagnosisDate": diag_date
        }

        diagnoses.append(diagnosis_data)
        diag_idx += 1

diagnoses_df = pd.DataFrame(diagnoses)





from collections import defaultdict
import random
from datetime import timedelta

# Realistic dosage map per medication
medication_dosage_map = {
    'Paracetamol': ['500mg', '650mg'],
    'Ibuprofen': ['200mg', '400mg', '600mg'],
    'Remdesivir': ['100mg'],
    'Aspirin': ['81mg', '325mg'],
    'Sumatriptan': ['50mg', '100mg'],
    'Metformin': ['500mg', '850mg'],
    'Insulin': ['10 units', '20 units'],
    'Amlodipine': ['5mg', '10mg'],
    'Lisinopril': ['10mg', '20mg'],
    'Atorvastatin': ['10mg', '20mg'],
    'Nitroglycerin': ['0.3mg', '0.6mg'],
    'Albuterol': ['2 puffs', '90mcg'],
    'Levothyroxine': ['50mcg', '75mcg', '100mcg'],
    'Hydrocortisone': ['1%', '2.5%'],
    'Methotrexate': ['7.5mg', '15mg'],
    'Benzoyl Peroxide': ['2.5%', '5%'],
    'Naproxen': ['250mg', '500mg'],
    'Lamotrigine': ['25mg', '50mg'],
    'Interferon': ['3 MIU', '5 MIU'],
    'Amiodarone': ['200mg'],
    'Multivitamins': ['Standard Dose'],
    'default': ['10mg', '20mg']
}

# Frequency rules based on diagnosis
def determine_frequency(diagnosis):
    chronic_conditions = ['Diabetes', 'Hypertension', 'Thyroid Disorder', 'Heart Disease']
    pain_or_acute = ['Flu', 'Cold', 'Headache', 'Migraine', 'Back Pain', 'Fracture', 'Sprain', 'Arthritis']
    if diagnosis in chronic_conditions:
        return 'Once a Day'
    elif diagnosis in pain_or_acute:
        return random.choice(['Twice a Day', 'As Needed'])
    else:
        return random.choice(['Once a Day', 'Twice a Day'])

# Generate prescriptions
prescriptions = []
prescription_counter = 1  # Global counter

# Group diagnoses by date
appointments_by_date = defaultdict(list)
for diag in diagnoses:
    appointments_by_date[diag["DiagnosisDate"]].append(diag)

# Now, generate prescriptions, ensuring randomization within each date group
for date, appts_on_date in appointments_by_date.items():
    # Shuffle AppointmentIDs for the same date group to ensure randomness
    random.shuffle(appts_on_date)
    
    for idx, diag in enumerate(appts_on_date):
        meds = diagnosis_medication_map.get(diag["DiagnosisType"], ['Paracetamol'])
        medication = random.choice(meds)
        start_date = diag["DiagnosisDate"]

        dosage_options = medication_dosage_map.get(medication, medication_dosage_map['default'])
        dosage = random.choice(dosage_options)
        frequency = determine_frequency(diag["DiagnosisType"])

        prescription_data = {
            "PrescriptionID": f"P{prescription_counter:05d}",
            "AppointmentID": diag["AppointmentID"],
            "Medication": medication,
            "Dosage": dosage,
            "Frequency": frequency,
            "StartDate": start_date,
            "EndDate": start_date + timedelta(days=random.randint(5, 30)),
            "Quantity": random.randint(5, 20)
        }

        prescriptions.append(prescription_data)
        prescription_counter += 1  # Increment globally
    

prescriptions_df = pd.DataFrame(prescriptions)



from datetime import timedelta
import random
import pandas as pd

# Base costs by appointment type
appointment_base_cost = {
    "Emergency": 3000,
    "Routine Checkup": 1000,
    "Follow-up": 1500,
    "Surgery": 8000  # include only if Surgery is in use
}

# Multiplier based on doctor specialty
specialty_cost_multiplier = {
    "Cardiology": 2.0,
    "Neurology": 1.8,
    "Orthopedics": 1.7,
    "Dermatology": 1.3,
    "General Practice": 1.0,
    "Pediatrics": 1.1,
    "Endocrinology": 1.5,
    "default": 1.0
}

# Cost additions based on severity
severity_cost_addition = {
    "Mild": 0,
    "Moderate": 500,
    "Severe": 1500
}

billing_data = []
bill_counter = 1

completed_appts = [appt for appt in appointments if appt["Status"] == "Completed"]

# Group by the appointment date to handle randomization of AppointmentIDs
grouped_by_date = {}
for appt in completed_appts:
    appt_date = appt["AppointmentDate"].date()
    if appt_date not in grouped_by_date:
        grouped_by_date[appt_date] = []
    grouped_by_date[appt_date].append(appt)

# Process appointments within each date group
for appt_date, appts_on_same_day in grouped_by_date.items():
    random.shuffle(appts_on_same_day)  # Shuffle to randomize AppointmentID order for the same date

    for appt in appts_on_same_day:
        appt_id = appt["AppointmentID"]
        patient_id = appt["PatientID"]
        doctor_id = appt["DoctorID"]
        billing_date = appt["AppointmentDate"]
        appt_type = appt["AppointmentType"]

        doctor_specialty = next((d["Specialty"] for d in doctors if d["DoctorID"] == doctor_id), "General Practice")
        diag = next((d for d in diagnoses if d["AppointmentID"] == appt_id), None)

        base = appointment_base_cost.get(appt_type, 1000)
        multiplier = specialty_cost_multiplier.get(doctor_specialty, specialty_cost_multiplier["default"])
        severity_addition = severity_cost_addition.get(diag["Severity"], 0) if diag else 0
        tests_cost = 800 if diag and diag["AdditionalTestsRequired"] else 0

        base_amount = round((base * multiplier) + severity_addition + tests_cost, 0)

        # Inject dirty data
        if random.random() < 0.05:
            base_amount = -abs(base_amount)

        # Get patient's insurance
        patient_insurance = patients_df.loc[patients_df["PatientID"] == patient_id, "InsuranceType"].values

        # Default to no insurance
        if len(patient_insurance) == 0 or pd.isna(patient_insurance[0]) or patient_insurance[0] in ['None', None]:
            insurance_type = 'None'
            insurance_coverage = 0
        else:
            insurance_type = patient_insurance[0]
            if insurance_type == 'Private':
                insurance_coverage = round(random.uniform(0.6, 1.0), 2)
            elif insurance_type == 'Medicare':
                insurance_coverage = round(random.uniform(0.3, 0.7), 2)
            else:
                insurance_coverage = 0

        insurance_amount = round(base_amount * insurance_coverage, 0)
        remaining_amount = max(0, base_amount - insurance_amount)

        rand = random.random()
        if rand < 0.15:
            paid_amount = 0
        elif rand < 0.6:
            paid_amount = round(random.uniform(1, remaining_amount), 0)
        elif rand < 0.98:
            paid_amount = remaining_amount
        else:
            paid_amount = round(random.uniform(remaining_amount + 1, remaining_amount + 500), 0)

        total_paid = insurance_amount + paid_amount

        # Prevent overpayment unless dirty data
        overpaid_flag = total_paid > base_amount
        if overpaid_flag and random.random() > 0.02:
            paid_amount = max(0, base_amount - insurance_amount)
            total_paid = insurance_amount + paid_amount
            overpaid_flag = False

        # Determine payment status
        if total_paid >= base_amount:
            payment_status = "Paid"
        elif total_paid > 0:
            payment_status = "Partially Paid"
        else:
            payment_status = "Pending"

        if random.random() < 0.03:
            payment_status = "Ppaid"

        # Payment method
        if insurance_coverage == 1.0:
            payment_method = "Insurance"
        elif paid_amount == 0:
            payment_method = random.choice(["Cash", "Online Payment", "Credit Card"])
        else:
            payment_method = random.choices(
                ["Cash", "Credit Card", "Online Payment"],
                weights=[0.3, 0.4, 0.3],
                k=1
            )[0]

        due_date = billing_date + timedelta(days=30)

        notes = ""
        if payment_status == "Pending":
            notes = "Pending insurance approval" if insurance_amount > 0 else "Awaiting payment"
        elif payment_status == "Partially Paid" and random.random() < 0.3:
            notes = random.choice(["Paid late", "Discount applied", "Awaiting full clearance"])
        elif payment_status == "Paid" and random.random() < 0.1:
            notes = "Paid early"
        if overpaid_flag:
            notes += " | Overpaid - to be reviewed"

        billing_data.append({
            "BillID": f"BILL{str(bill_counter).zfill(4)}",
            "AppointmentID": appt_id,
            "PatientID": patient_id,
            "DoctorID": doctor_id,
            "BillingDate": billing_date,
            "Amount": base_amount,
            "InsuranceCoveredAmount": insurance_amount,
            "PaidAmount": paid_amount,
            "TotalSettledAmount": total_paid,
            "PaymentMethod": payment_method,
            "PaymentStatus": payment_status,
            "DueDate": due_date,
            "Notes": notes
        })

        bill_counter += 1

# Convert to DataFrame
billing_df = pd.DataFrame(billing_data)





# Save to CSV
base_path = "C:\\Users\\dilee\\Documents\\Data Analysis Projects\\Healthcare_project\\Dataset\\"
patients_df.to_csv(base_path + "Patients_with_noise.csv", index=False, na_rep='NULL')
doctors_df.to_csv(base_path + "Doctors_with_noise.csv", index=False, na_rep='NULL')
appointments_df.to_csv(base_path + "Appointments_with_noise.csv", index=False, na_rep='NULL')
diagnoses_df.to_csv(base_path + "Diagnoses_with_noise.csv", index=False, na_rep='NULL')
prescriptions_df.to_csv(base_path + "Prescriptions_with_noise.csv", index=False, na_rep='NULL')
billing_df.to_csv(base_path + "Billing_with_noise.csv", index=False, na_rep='NULL')

print("✅ Finalized data with logically aligned dates and LastVisit accuracy generated.")

