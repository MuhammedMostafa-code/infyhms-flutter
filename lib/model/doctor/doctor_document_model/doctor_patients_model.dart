// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'doctor_patients_model.g.dart';

@JsonSerializable()
class DoctorPatientsDocumentsModel {
  bool? success;
  List<PatientData>? data;
  String? message;

  DoctorPatientsDocumentsModel({
    this.success,
    this.data,
    this.message,
  });

  factory DoctorPatientsDocumentsModel.fromJson(Map<String, dynamic> json) => _$DoctorPatientsDocumentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorPatientsDocumentsModelToJson(this);
}

@JsonSerializable()
class PatientData {
  int? id;
  String? patient_name;
  int? user_id;

  PatientData({
    this.id,
    this.patient_name,
    this.user_id,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) => _$PatientDataFromJson(json);

  Map<String, dynamic> toJson() => _$PatientDataToJson(this);
}
