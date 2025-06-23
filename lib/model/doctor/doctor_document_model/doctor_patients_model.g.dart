// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_patients_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorPatientsDocumentsModel _$DoctorPatientsDocumentsModelFromJson(
        Map<String, dynamic> json) =>
    DoctorPatientsDocumentsModel(
      success: json['success'] as bool?,
      // data: (json['data'] as List<dynamic>?)
      //     ?.map((e) => PatientData.fromJson(e as Map<String, dynamic>))
      //     .toList(),
      data: (json['data'] is Map)
          ? (json['data']['data'] as List<dynamic>?) // إذا كانت data عبارة عن Map، استخرج الـ List من داخلها
          ?.map((e) => PatientData.fromJson(e as Map<String, dynamic>))
          .toList()
          : (json['data'] as List<dynamic>?) // إذا كانت data بالفعل List (للاحتياط)
          ?.map((e) => PatientData.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DoctorPatientsDocumentsModelToJson(
        DoctorPatientsDocumentsModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };

PatientData _$PatientDataFromJson(Map<String, dynamic> json) => PatientData(
      id: json['id'] as int?,
      patient_name:'${json['first_name'] ?? ""} ${json['last_name'] ?? ""}'.trim() as String?,
      user_id: json['user_id'],
    );

Map<String, dynamic> _$PatientDataToJson(PatientData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patient_name': instance.patient_name,
      'user_id' : instance.user_id
    };
