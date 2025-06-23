// // ignore_for_file: non_constant_identifier_names
//
// import 'package:json_annotation/json_annotation.dart';
// part 'patients.g_model.dart';
//
// @JsonSerializable()
// class PatientsDocumentsModel {
//   bool? success;
//   List<PatientData>? data;
//   String? message;
//
//   PatientsDocumentsModel({
//     this.success,
//     this.data,
//     this.message,
//   });
//
//   factory PatientsDocumentsModel.fromJson(Map<String, dynamic> json) => _$PatientsDocumentsModelFromJson(json);
//
//   Map<String, dynamic> toJson() => _$PatientsDocumentsModelToJson(this);
// }
//
// @JsonSerializable()
// class PatientData {
//   int? id;
//   String? patient_name;
//
//   PatientData({
//     this.id,
//     this.patient_name,
//   });
//
//   factory PatientData.fromJson(Map<String, dynamic> json) => _$PatientDataFromJson(json);
//
//   Map<String, dynamic> toJson() => _$PatientDataToJson(this);
// }
