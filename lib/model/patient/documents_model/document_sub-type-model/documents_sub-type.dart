
import 'package:json_annotation/json_annotation.dart';

part 'documents_sub-type.g.dart';

@JsonSerializable()
class DocumentsSubTypeModel {
  bool? success;
  Map<String,dynamic>? data;
  String? message;
  DocumentsSubTypeModel({
    this.success,
    this.data,
    this.message
});
  factory DocumentsSubTypeModel.fromjson(Map<String, dynamic> json) => _$DocumentsSubTypeModelFromJson(json);
}

@JsonSerializable()
class DocumentsSubTypeData{
  int? id;
  String? name;
  DocumentsSubTypeData({
    this.id,
    this.name,
});

  factory DocumentsSubTypeData.fromJson(Map<String ,dynamic>json) => _$DocumentsSubTypeDataFromJson(json);
}