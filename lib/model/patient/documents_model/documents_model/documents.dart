import 'package:json_annotation/json_annotation.dart';

part 'documents.g.dart';

@JsonSerializable()
class DocumentsModel {
  bool? success;
  List<DocumentData>? data;
  String? message;

  DocumentsModel({
    this.success,
    this.data,
    this.message,
  });

  factory DocumentsModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentsModelToJson(this);
}

@JsonSerializable()
class DocumentData {
  int? id;
  String? title;
  int? document_type_id;
  int? patient_id;
  int? uploaded_by;
  String? notes;
  String? is_default;
  String? document_url;

  DocumentData({
    this.id,
    this.title,
    this.document_type_id,
    this.patient_id,
    this.uploaded_by,
    this.notes,
    this.is_default,
    this.document_url,
  });
  factory DocumentData.fromJson(Map<String, dynamic> json) =>
      _$DocumentDataFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentDataToJson(this);
}
