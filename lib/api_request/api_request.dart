import 'dart:io';

import 'package:dio/dio.dart';
import 'package:infyhms_flutter/model/doctor/bed_assign_model/bed_assign_delete_model.dart';
import 'package:infyhms_flutter/model/doctor/bed_assign_model/bed_assign_edit_model.dart';
import 'package:infyhms_flutter/model/doctor/bed_assign_model/bed_assign_model.dart';
import 'package:infyhms_flutter/model/doctor/bed_assign_model/bed_details_model.dart';
import 'package:infyhms_flutter/model/doctor/bed_assign_model/bed_update_model.dart';
import 'package:infyhms_flutter/model/doctor/bed_assign_model/beds_model.dart';
import 'package:infyhms_flutter/model/doctor/bed_assign_model/create_new_bed_model.dart';
import 'package:infyhms_flutter/model/doctor/bed_assign_model/ipd_patients_model.dart';
import 'package:infyhms_flutter/model/doctor/bed_assign_model/patient_cases_model.dart';
import 'package:infyhms_flutter/model/doctor/bed_status_model/bed_status_details_model.dart';
import 'package:infyhms_flutter/model/doctor/bed_status_model/bed_status_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_appointment_model/confirm_appointment_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_appointment_model/doctor_appointment_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_diagnosis_test_model/delete_test_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_diagnosis_test_model/doctor_diagnosis_test_detail_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_diagnosis_test_model/doctor_diagnosis_test_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_document_model/doctor_documents_crud_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_document_model/doctor_documents_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_document_model/doctor_documents_type_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_document_model/doctor_patients_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_live_consultations_model/doctor_live_consultations_details_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_live_consultations_model/doctor_live_consultations_meeting_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_live_consultations_model/doctor_live_consultations_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_model/doctor_detail_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_model/doctor_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_payroll_model/payroll_details_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_payroll_model/payroll_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_prescription_model/doctor_prescription_detail_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_prescription_model/doctor_prescription_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_schedule_model/doctor_schedule_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_schedule_model/doctor_schedule_update_model.dart';
import 'package:infyhms_flutter/model/doctor/patient_admission_model/delete_admission_model.dart';
import 'package:infyhms_flutter/model/doctor/patient_admission_model/patient_admission_details_model.dart';
import 'package:infyhms_flutter/model/doctor/patient_admission_model/patient_admission_model.dart';
import 'package:infyhms_flutter/model/doctor/report_model/common_report_model/common_report_model.dart';
import 'package:infyhms_flutter/model/doctor/report_model/common_report_model/delete_common_report_model.dart';
import 'package:infyhms_flutter/model/doctor/report_model/doctor_case_details_model.dart';
import 'package:infyhms_flutter/model/doctor/report_model/investigation_report_model/investigation_report_model.dart';
import 'package:infyhms_flutter/model/patient/account_model/edit_profile_model.dart';
import 'package:infyhms_flutter/model/patient/account_model/get_profile_model.dart';
import 'package:infyhms_flutter/model/patient/admission_model/admission_model.dart';
import 'package:infyhms_flutter/model/patient/appointment_model/appointment_model.dart';
import 'package:infyhms_flutter/model/patient/appointment_model/cancel_appointment/cancel_appointment_model.dart';
import 'package:infyhms_flutter/model/patient/appointment_model/create_appointment/create_appointment_model.dart';
import 'package:infyhms_flutter/model/patient/appointment_model/delete_appointment/delete_appointment_model.dart';
import 'package:infyhms_flutter/model/patient/appointment_model/doctor/doctor_department_model.dart';
import 'package:infyhms_flutter/model/patient/appointment_model/doctor/get_doctor_model.dart';
import 'package:infyhms_flutter/model/patient/appointment_model/filter/filter_appointment_model.dart';
import 'package:infyhms_flutter/model/patient/appointment_model/slot_booking/slot_booking_model.dart';
import 'package:infyhms_flutter/model/patient/auth_model/forgot_password_model.dart';
import 'package:infyhms_flutter/model/patient/auth_model/login_model.dart';
import 'package:infyhms_flutter/model/patient/auth_model/logout_model.dart';
import 'package:infyhms_flutter/model/patient/auth_model/reset_password_model.dart';
import 'package:infyhms_flutter/model/patient/auth_model/send_token_model.dart';
import 'package:infyhms_flutter/model/patient/auth_model/sigup_model.dart';
import 'package:infyhms_flutter/model/patient/bills_model/bill_detail_model.dart';
import 'package:infyhms_flutter/model/patient/bills_model/bill_model.dart';
import 'package:infyhms_flutter/model/patient/case_model/case_model.dart';
import 'package:infyhms_flutter/model/patient/diagnosis_model/diagnosis_test_details_model.dart';
import 'package:infyhms_flutter/model/patient/diagnosis_model/diagnosis_test_model.dart';
import 'package:infyhms_flutter/model/patient/documents_model/document_delete_model/document_delete.dart';
import 'package:infyhms_flutter/model/patient/documents_model/document_download_model/document_download.dart';
import 'package:infyhms_flutter/model/patient/documents_model/document_store_model/document_store.dart';
import 'package:infyhms_flutter/model/patient/documents_model/document_update_model/document_update.dart';
import 'package:infyhms_flutter/model/patient/documents_model/documents_model/documents.dart';
import 'package:infyhms_flutter/model/patient/documents_model/documents_type_model/documents_type.dart';
import 'package:infyhms_flutter/model/patient/invoice_model/invoice_details_model.dart';
import 'package:infyhms_flutter/model/patient/invoice_model/invoice_model.dart';
import 'package:infyhms_flutter/model/patient/lab_tests/gat_lab_tests.dart';
import 'package:infyhms_flutter/model/patient/live_consultancy/live_consultation_details_model.dart';
import 'package:infyhms_flutter/model/patient/live_consultancy/live_consultation_filter.dart';
import 'package:infyhms_flutter/model/patient/live_consultancy/live_consultation_meeting_model.dart';
import 'package:infyhms_flutter/model/patient/notice_board_model/notice_board.dart';
import 'package:infyhms_flutter/model/patient/prescriptions_model/prescription_details_model.dart';
import 'package:infyhms_flutter/model/patient/prescriptions_model/prescriptions_model.dart';
import 'package:infyhms_flutter/model/patient/t7aleel/t7aleel_model/t7aleel_model.dart';
import 'package:infyhms_flutter/model/patient/vaccinated_model/vaccinated_model.dart';
import 'package:infyhms_flutter/utils/string_utils.dart';
import 'package:retrofit/retrofit.dart';

import '../model/patient/documents_model/document-parents/get-document-parents.dart';
import '../model/patient/documents_model/document_specific-type/document_specifc-type.dart';
import '../model/patient/documents_model/document_sub-type-model/documents_sub-type.dart';

part 'api_request.g.dart';

// @RestApi(baseUrl: "https://upd.mdibridge.com/api/")
@RestApi(baseUrl: "https://local.mdiprove.com/api/")
// @RestApi(baseUrl: "https://live.mdiprove.com/api/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST(StringUtils.loginPatient)
  Future<LoginModel> loginPatient(@Body() Map<String, dynamic> data);

  @GET(StringUtils.appointments)
  Future<AppointmentModel> getAppointments(
    @Header('Authorization') String? token,
  );

  @POST("appointment-filter?status={filter}")
  Future<FilterAppointmentModel> getPastAppointments(
    @Header('Authorization') String? token,
    @Path("filter") String filter,
  );

  @GET("doctor-department")
  Future<DoctorDepartmentModel> getDoctorDepartment(
    @Header('Authorization') String? token,
  );

  @POST("doctor/{id}")
  Future<GetDoctorModel> getDoctor(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @POST("slot-booking")
  Future<SlotBookingModel> getBookingSlotDate(
    @Header('Authorization') String? token,
    @Field("editSelectedDate") String editSelectedDate,
    @Field("doctor_id") String doctorId,
  );

  @POST("appointment-create")
  Future<CreateAppointmentModel> createAppointment(
    @Header('Authorization') String? token,
    @Field("department_id") String departmentId,
    @Field("doctor_id") String doctorId,
    @Field("opd_date") String selectedDate,
    @Field("time") String selectedTime,
    @Field("patient_id") String patientId,
  );


  @GET("documents")
  Future<DocumentsModel> getDocuments(
    @Header('Authorization') String? token,
  );

  @GET("document-type")
  Future<DocumentsTypeModel> getDocumentsType(
    @Header('Authorization') String? token,
  );

  @GET("get-doc-subtypes/{documentTypeId}")
  Future<DocumentsSubTypeModel> getDocumentsSubType(
      @Header('Authorization') String? token,
      @Path("id") String? documentTypeId,
      );

  @GET("get-doc-specific-types/{documentTypeId}")
  Future<DocumentsSpecificTypeModel> getDocumentsSpecificType(
      @Header('Authorization') String? token,
      @Path("id") String? documentTypeId,
      );

  @GET("get-lab-tests")
  Future<LabtestsModel> getLabTests(
      @Header('Authorization') String? token,
      );

  @GET("get-document-parents/{documentTypeId}")
  Future<GetDocumentParentsModel> getDocumentParents(
      @Header('Authorization') String? token,
      @Path("id") String? documentSpecificTypeId,
      );


  // @GET("get-doc-specific-types/{documentSubtypeId?}")
  // Future<DocumentsSpecificTypeModel> getDocumentsSpecificType(
  //     @Header('Authorization') String? token,
  //     @Path("id") int documentSubtypeId,
  //     );

  @MultiPart()
  @POST("document-store")
  Future<DocumentStoreModel> storeDocument(
    @Header('Authorization') String? token,
    @Part(name: "title") String title,
    @Part(name: "document_type_id") String documentTypeId,
    @Part(name: "notes") String notes,
    @Part(name: "file") File file,
  );

  @MultiPart()
  @POST("document-update/{id}")
  Future<DocumentUpdateModel> updateDocument(
    @Header('Authorization') String? token,
    @Part(name: "title") String title,
    @Part(name: "document_type_id") String documentTypeId,
    @Part(name: "notes") String notes,
    @Part(name: "file") File? file,
    @Path("id") int documentId,
  );

  @GET("document-delete/{id}")
  Future<DocumentDeleteModel> deleteDocument(
    @Header('Authorization') String? token,
    @Path("id") int documentId,
  );

  @GET("document-download/{id}")
  Future<DocumentDownloadModel> downloadDocument(
    @Header('Authorization') String? token,
    @Path("id") int documentId,
  );

  @GET("notice-board")
  Future<NoticeBoardModel> getNoticeBoard(
    @Header('Authorization') String? token,
  );

  @GET("invoices")
  Future<InvoiceModel> getInvoices(
    @Header('Authorization') String? token,
  );

  @GET("invoice/{id}")
  Future<InvoiceDetailsModel> getInvoiceData(
    @Header('Authorization') String? token,
    @Path("id") int invoiceId,
  );

  @GET("live-consultation/{id}")
  Future<LiveConsultationDetailsModel> liveConsultationData(
    @Header('Authorization') String? token,
    @Path("id") int consultationId,
  );

  @GET("live-consultation-meeting/{id}")
  Future<LiveConsultationMeetingModel> liveConsultationMeetingData(
    @Header('Authorization') String? token,
    @Path("id") int consultationId,
  );

  @POST("live-consultation-filter?status={status}")
  Future<LiveConsultationFilter> liveConsultationFilter(
    @Header('Authorization') String? token,
    @Path("status") String status,
  );

  @POST("cancel-appointment")
  Future<CancelAppointmentModel> cancelAppointment(
    @Header('Authorization') String? token,
    @Field("id") int id,
  );

  @POST("delete-appointment")
  Future<DeleteAppointmentModel> deleteAppointment(
    @Header('Authorization') String? token,
    @Field("id") int id,
  );

  @GET("bills")
  Future<BillsModel> getBills(
    @Header('Authorization') String? token,
  );

  @GET("bills/{id}")
  Future<BillDetailModel> getBillsDetails(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("diagnosis")
  Future<DiagnosisTestModel> getDiagnosisTest(
    @Header('Authorization') String? token,
  );

  @GET("diagnosis/{id}")
  Future<DiagnosisTestDetailsModel> getDiagnosisTestDetails(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("patient-cases")
  Future<CaseModel> getCase(
    @Header('Authorization') String? token,
  );

  @GET("patient-admissions")
  Future<AdmissionModel> getAdmission(
    @Header('Authorization') String? token,
  );

  @GET("patient-prescription")
  Future<PrescriptionsModel> getPrescription(
    @Header('Authorization') String? token,
  );

  @GET("patient-prescription/{id}")
  Future<PrescriptionDetailModel> getPrescriptionDetails(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("vaccinated-patient")
  Future<VaccinatedModel> getVaccinated(
    @Header('Authorization') String? token,
  );

  @MultiPart()
  @POST("update-profile")
  Future<EditProfileModel> editProfile(
    @Header('Authorization') String? token,
    @Part(name: "first_name") String firstName,
    @Part(name: "last_name") String lastName,
    @Part(name: "email") String email,
    @Part(name: "phone") String phone,
    @Part(name: "image") File? profileImage,
  );

  @POST("logout")
  Future<LogoutModel> logout(
    @Header('Authorization') String? token,
  );

  @POST("reset-password")
  Future<ResetPasswordModel> resetPassword(
    @Header('Authorization') String? token,
    @Body() Map<String, dynamic> data,
  );

  @POST("forgot-password")
  Future<ForgotPasswordModel> forgotPassword(
    @Body() Map<String, dynamic> data,
  );

  @POST("password")
  Future<SendTokenModel> sendToken(
    @Field("token") String token,
    @Field("password") String password,
    @Field("password_confirmation") String passwordConfirmation,
    @Field("email") String email,
  );

  @GET("get-profile")
  Future<GetProfileModel> getProfile(
    @Header('Authorization') String? token,
  );

  @POST("patient-register")
  Future<SignUpModel> patientRegistration(
      @Field("first_name") String firstName,
      @Field("last_name") String lastName,
      @Field("email") String email,
      @Field("gender") String gender,
      @Field("password") String password,
      @Field("password_confirmation") String passwordConfirmation,
      );


  /// Doctor panel

  @GET("doctors/appointment-filter?status={status}")
  Future<DoctorAppointmentModel> getDoctorAppointments(
    @Header('Authorization') String? token,
    @Path("status") String status,
  );

  @POST("doctors/confirm-appointment/{id}")
  Future<ConfirmAppointmentModel> confirmAppointment(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("doctors/doctors")
  Future<DoctorsModel> getDoctors(
    @Header('Authorization') String? token,
  );

  @GET("doctors/doctors/{id}")
  Future<DoctorsDetailModel> getDoctorsDetail(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("doctors/prescriptions")
  Future<DoctorPrescriptionModel> getDoctorsPrescription(
    @Header('Authorization') String? token,
  );

  @GET("doctors/prescriptions/{id}")
  Future<DoctorPrescriptionDetailModel> getDoctorsPrescriptionDetail(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("doctors/doctor-diagnosis")
  Future<DoctorDiagnosisTestModel> getDoctorsDiagnosisTest(
    @Header('Authorization') String? token,
  );

  @GET("doctors/doctor-diagnosis/{id}")
  Future<DoctorDiagnosisTestDetailsModel> getDoctorsDiagnosisTestDetails(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @DELETE("doctors/doctor-diagnosis/{id}")
  Future<DeleteTestModel> deleteTest(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("doctors/doctor-payroll")
  Future<PayrollModel> getPayroll(
    @Header('Authorization') String? token,
  );

  @GET("doctors/doctor-payroll/{id}")
  Future<PayrollDetailsModel> getPayrollDetails(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("doctors/live-consultation-show/{id}")
  Future<DoctorLiveConsultationsDetailsModel> liveDoctorConsultationData(
    @Header('Authorization') String? token,
    @Path("id") int consultationId,
  );

  @GET("doctors/live-consultation-meeting/{id}")
  Future<DoctorLiveConsultationsMeetingModel> liveDoctorConsultationMeetingData(
    @Header('Authorization') String? token,
    @Path("id") int consultationId,
  );

  @GET("doctors/live-consultation-filter?status={status}")
  Future<DoctorLiveConsultationsModel> liveDoctorConsultationFilter(
    @Header('Authorization') String? token,
    @Path("status") String status,
  );

  @GET("doctors/patient-admission")
  Future<PatientAdmissionModel> getPatientAdmission(
    @Header('Authorization') String? token,
  );

  @GET("doctors/patient-admission-show/{id}")
  Future<PatientAdmissionDetailsModel> getPatientAdmissionDetails(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @DELETE("doctors/patient-admission-delete/{id}")
  Future<DeleteAdmissionModel> deleteAdmission(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("doctors/birth-report")
  Future<CommonReportModel> getBirthReport(
    @Header('Authorization') String? token,
  );

  @DELETE("doctors/birth-report/{id}")
  Future<DeleteCommonReportModel> deleteBirthReport(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("doctors/death-report")
  Future<CommonReportModel> getDeathReport(
    @Header('Authorization') String? token,
  );

  @DELETE("doctors/death-report/{id}")
  Future<DeleteCommonReportModel> deleteDeathReport(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("doctors/operation-report")
  Future<CommonReportModel> getOperationReport(
    @Header('Authorization') String? token,
  );

  @DELETE("doctors/operation-report/{id}")
  Future<DeleteCommonReportModel> deleteOperationReport(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("doctors/investigation-report")
  Future<InvestigationReportModel> getInvestigationReport(
    @Header('Authorization') String? token,
  );

  @DELETE("doctors/investigation-report/{id}")
  Future<DeleteCommonReportModel> deleteInvestigationReport(
    @Header('Authorization') String? token,
    @Path("id") int id,
  );

  @GET("doctors/case-detail/{caseId}")
  Future<DoctorCaseDetailsModel> getDoctorCaseDetails(
    @Header('Authorization') String? token,
    @Path("caseId") String caseId,
  );

  ////////

  @GET("doctors/bed-assign-filter?status={status}")
  Future<BedAssignFilterModel> getBedData(
    @Header('Authorization') String? token,
    @Path("status") String status,
  );

  @GET("doctors/bed-assign/{id}")
  Future<BedDetailsModel> getBedDataDetails(
    @Header('Authorization') String? token,
    @Path("id") String id,
  );

  //
  @GET("doctors/bed-status")
  Future<BedStatusModel> getBedStatus(
    @Header('Authorization') String? token,
  );

  @GET("doctors/bed-status-detail/{id}")
  Future<BedStatusDetailsModel> getBedStatusDetails(
    @Header('Authorization') String? token,
    @Path("id") String id,
  );

  @GET("doctors/beds")
  Future<BedsModel> getBeds(
    @Header('Authorization') String? token,
  );

  @POST("doctors/bed-assign-edit-bed")
  Future<BedsModel> getBedsForEdit(
    @Header('Authorization') String? token,
    @Field("bed_id") String bedId,
  );

  @GET("doctors/ipd-patient/{caseId}")
  Future<IPDPatientsModel> getIPDModel(
    @Header('Authorization') String? token,
    @Path("caseId") String caseId,
  );

  @GET("doctors/patient-cases")
  Future<PatientCases> getPatientCases(
    @Header('Authorization') String? token,
  );

  @GET("doctors/bed-assign-edit/{bedAssignId}")
  Future<EditBedAssignModel> getBedEditAssignDetails(
    @Header('Authorization') String? token,
    @Path("bedAssignId") int id,
  );

  @POST("doctors/bed-assign-update/{id}")
  Future<BedUpdatedDetailsModel> updateBedAssign(
    @Header('Authorization') String? token,
    @Path("id") String id,
    @Field("case_id") String caseId,
    @Field("ipd_patient_department_id") String patientId,
    @Field("bed_id") String bedId,
    @Field("assign_date") String assignDate,
    @Field("discharge_date") String dischargeDate,
      @Field("description") String description
  );

  @POST("doctors/bed-assign-delete/{id}")
  Future<BedAssignDelete> deleteBedAssign(
    @Header('Authorization') String? token,
    @Path("id") String id,
  );

  @POST("doctors/bed-assign-create")
  Future<CreateNewBedModel> createNewBedAssign(
    @Header('Authorization') String? token,
    @Field("case_id") String caseId,
    @Field("bed_id") String? bedId,
    @Field("assign_date") String? assignDate,
    @Field("ipd_patient_department_id") String patientId,
      @Field("description") String description
  );

  /// doctor documents

  @GET("doctors/doctor-documents")
  Future<DoctorDocumentsModel> doctorDocuments(
    @Header('Authorization') String? token,
  );

  // @GET("doctors/doctor-document-type")
  @GET("document-type")
  Future<DoctorDocumentsTypeModel> doctorDocumentType(
    @Header('Authorization') String? token,
  );

  // @GET("doctors/doctor-patients")
  @GET("patients")
  Future<DoctorPatientsDocumentsModel> doctorPatientsDocument(
    @Header('Authorization') String? token,
  );

  /// doctor documents crud

  @MultiPart()
  @POST("documents/store")
  // @POST("doctors/doctor-document-store")
  Future<DoctorDocumentsCRUDModel> createNewDoctorDocument(
    @Header('Authorization') String? token,
    @Part(name: "title") String title,
    @Part(name: "details") String details,
    @Part(name: "document_type_id") String documentTypeId,
    @Part(name: "patient_id") String patientId,
    @Part(name: "file") File? attachment,
      @Part(name: "notes") String notes,
  );

  @MultiPart()
  @POST("doctors/doctor-document-update/{id}")
  Future<DoctorDocumentsCRUDModel> updateDoctorsDocuments(
    @Header('Authorization') String? token,
    @Path("id") String docId,
    @Part(name: "title") String title,
    @Part(name: "document_type_id") String documentTypeId,
    @Part(name: "patient_id") String patientId,
    @Part(name: "file") File? attachment,
      @Part(name: "notes") String notes,
  );

  @DELETE("doctors/doctor-document-delete/{id}")
  Future<DoctorDocumentsCRUDModel> deleteDoctorDocuments(
    @Header('Authorization') String? token,
    @Path("id") String docId,
  );

  @GET("doctors/doctor-schedule")
  Future<DoctorScheduleModel> schedule(
    @Header('Authorization') String? token,
  );

  @POST("doctors/doctor-schedule/update/{id}")
  Future<DoctorScheduleUpdateModel> scheduleUpdate(
    @Header('Authorization') String? token,
    @Path("id") String id,
    @Body() Map<String, dynamic> data,
  );
}
