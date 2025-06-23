import 'package:dio/dio.dart';
import 'package:infyhms_flutter/api_request/api_request.dart';

class StringUtils {
  /// Patient Panel

  /// api calling
  static final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
  static const loginPatient = "login";
  static const appointments = "appointments";

  /// auth
  static const signIn = "Sign In";
  static const patientRegistration = "Patient Registration";
  static const resetPassword = "Reset Password";
  static const signInEmail = "Enter Email Address";
  static const enterNewPassword = "Enter New Password";
  static const enterConfirmPassword = "Enter Confirm Password";
  static const signInPassword = "Enter Password";
  static const forgotPassword = "Forgot Password?";
  static const rememberPassword = "Remember Me";
  static const login = "Login";
  static const forgotScreenDetail = "Enter your email to reset your password";
  static const sendLink = "Send Link";
  static const cancel = "Cancel";
  static String? token;
  static String sendEmail = "";

  static const yes = "Yes";
  static const no = "No";

  static const edit = "Edit";
  static const editDocument = "Edit Document";
  static const newDocument = "New Document";
  static const delete = "Delete";
  static const introOneTitle = "Book an Appointment";
  static const introOneSubTitle = "Book appointments with ease, putting your health in your hands";
  static const introTwoTitle = "Schedule Live Consultation";
  static const introTwoSubTitle = "Seamlessly schedule live consultations, connecting you with healthcare professionals on your terms";
  static const introThreeTitle = "Read Prescriptions";
  static const introThreeSubTitle = "Navigate your treatment with clarity – easily read and follow your doctor's prescribed plan";
  static const appointment = "Appointment";
  static const bills = "Bills";
  static const billsDetails = "Bill Details";
  static const diagnosisTests = "Diagnosis Tests";
  static const diagnosisTestsDetails = "Diagnosis Test Details";
  static const documents = "Documents";
  static const noticeBoards = "Notice Boards";
  static const invoices = "Invoices";
  static const liveConsultations = "Live Consultations";
  static const patientsCases = "Cases";
  static const casesDetails = "Case Details";
  static const myCases = "Case";
  static const patientAdmissions = "Patient Admissions";
  static const myAdmissions = "My Admissions";
  static const prescriptions = "Prescriptions";
  static const vaccinatedPatients = "Vaccination";
  static const visits = "Visits";
  static const patients = "Patients";
  static const ashe3a = "Medical x-rays";
  static const t7aleel = "Medical tests";
  static const NewT7aleel = "New Medical tests";
  static const addpatients = "Addpatients";
  static const logOut = "Logout";
  static const myAccount = "My Account";
  static const editProfile = "Edit Profile";
  static const changePassword = "Change Password";
  static const firstName = "First Name:";
  static const lastName = "Last Name:";
  static const email = "Email:";
  static const phone = "Phone:";
  static const save = "Save";

  static const currentPassword = "Current Password:";
  static const newPassword = "New Password:";
  static const confirmPassword = "Confirm Password:";
  static const newAppointment = "New Appointment";
  static const doctorDepartment = "Doctor Department:";
  static const doctor = "Doctor:";

  static const slotAvailable = "Available Slot:";
  static const description = "Description:";

  /// Admission
  static const admissionDetails = "Admission Details";
  static const insuranceDetails = "Insurance Details";
  static const admissionId = "Admission ID:";
  static const admissionDate = "Admission Date:";
  static const dischargeDate = "Discharge Date:";
  static const bed = "Bed:";
  static const guardianName = "Guardian Name:";
  static const guardianRelation = "Guardian Relation:";
  static const guardianContact = "Guardian Contact:";
  static const guardianAddress = "Guardian Address:";
  static const createOn = "Created On:";
  static const packageName = "Package Name:";
  static const insuranceName = "Insurance Name:";
  static const agentName = "Agent Name:";
  static const policyNo = "Policy No:";

  /// bill
  static const patientCellNO = "Patient Cell No:";
  static const totalDays = "Total Days:";
  static const itemDetails = "Item Details";
  static const totalAmount = "Total Amount";
  static const downloadBill = "Download Bill";
  static const fee = "Fee:";

  /// Consultancy
  static const liveConsultationsDetails = "Live Consultations Details";
  static const consultationTitle = "Consultation Title:";
  static const consultationDate = "Consultation Date:";
  static const durationMinute = "Duration Minutes:";
  static const doctorName = "Doctor Name:";
  static const type = "Type:";
  static const typeNumber = "Type Number:";

  /// diagnosis
  static const diagnosisCategory = "Diagnosis Category:";
  static const reportNumber = "Report number:";
  static const averageGlucose = "Average Glucose:";
  static const fastingBloodSugar = "Fasting Blood Sugar:";
  static const urineSugar = "Urine Sugar:";
  static const bloodPressure = "Blood Pressure:";
  static const diabetes = "Diabetes:";
  static const cholesterol = "Cholesterol:";
  static const downloadDiagnosisTest = "Download Diagnosis Test PDF";

  ///document
  static const title = "Title:";
  static const reportDoc = "Report:";
  static const conclusion = "Conclusion:";
  static const labName = "LabName:";
  static const details = "Details:";
  static const documentType = "Document Type:";
  static const attachment = "Attachment:";
  static const note = "Notes:";

  /// invoice
  static const issueFor = "Issue For:";
  static const issueBy = "Issue By:";
  static const subTotal = "Sub Total:";
  static const discount = "Discount:";
  static const downloadInvoice = "Download Invoice:";
  static const downInvoice = "Download Invoice";

  /// prescription
  static const foodAllergies = "Food Allergies:";
  static const tendencyBleed = "Tendency Bleed:";
  static const heartDisease = "Heart Disease";
  static const highBloodPressure = "High Blood Pressure:";
  static const surgery = "Surgery:";
  static const accident = "Accident:";
  static const others = "Others:";
  static const medicalHistory = "Medical History:";
  static const currentMedication = "Current Medication:";
  static const femalePregnancy = "Female Pregnancy:";
  static const breastFeeding = "Breast Feeding:";
  static const healthInsurance = "Health Insurance:";
  static const lowIncome = "Low Income:";
  static const reference = "Reference";

  /// hint text
  static const selectDepartment = "Select Department";
  static const selectDoctor = "Select Doctor";
  static const selectDate = "Select Date";
  static const typeHere = "Type here..";
  static const date = "Date";

  /// Doctor Panel

  static const bedAssign = "Bed Assigns";
  static const bedStatus = "Bed Status";
  static const doctorDrawer = "Doctor";
  static const schedules = "Schedules";
  static const myPayRoll = "My Payrolls";
  static const reports = "Reports";
  static const icu = "ICU";
  static const confirm = "Confirm";
  static const patientAdmissionInDoctor = "Patient Admissions";
  static const patientDetails = "Patient Details";
  static const prescriptionDetails = "Prescription Details";
  static const overview = "Overview";
  static const rx = "Rx:";
  static const downloadPrescription = "Download Prescription";
  static const patient = "Patient";
  static const height = "Height:";
  static const age = "Age:";
  static const weight = "Weight:";

  /// payRoll
  static const srNo = "Sr No:";
  static const myPayrolls = "My Payrolls";
  static const payrollsDetails = "Payroll Details";
  static const salaryDetails = "Salary Details";
  static const basicSalary = "Basic Salary:";
  static const allowance = "Allowance:";
  static const deductions = "Deductions:";
  static const netSalary = "Net Salary:";

  ///
  static const patientName = "Patient Name:";

  /// report

  static const reportDate = "ReportDate";
  static const birthReport = "Birth Reports";
  static const deathReport = "Death Reports";
  static const investigationReport = "Investigation Reports";
  static const operationReport = "Operation Reports";

  static const newCase = "Case";
  static const ipdPatient = "IPD Patient";
  static const bedInEditBed = "Bed";
  static const assignDate = "Assign Date";
  static const disChargeDate = "Discharge Date";
}
