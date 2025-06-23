
import 'package:json_annotation/json_annotation.dart';

part 'document_specifc-type.g.dart';

@JsonSerializable()
class DocumentsSpecificTypeModel {
  bool? success;
  Map<String,dynamic>? data;
  String? message;

  DocumentsSpecificTypeModel({
    this.success,
    this.data,
    this.message
});
  factory DocumentsSpecificTypeModel.fromjson(Map<String ,dynamic>json) => _$DocumentsSpecificTypeModelFromJson(json);
}

@JsonSerializable()
class DocumentsSpecificTypeData{
  int? id;
  String? name;
  DocumentsSpecificTypeData({this.id,this.name});

  factory DocumentsSpecificTypeData.fromjson(Map<String ,dynamic>json) => _$DocumentsSpecificTypeDataFromJson(json);
}