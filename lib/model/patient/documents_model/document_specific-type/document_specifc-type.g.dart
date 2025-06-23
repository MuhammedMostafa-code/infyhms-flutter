part of 'document_specifc-type.dart';

DocumentsSpecificTypeModel _$DocumentsSpecificTypeModelFromJson(
    Map<String, dynamic> json) {
  Map<String, dynamic>? Data;
  dynamic listData = json['data'];

  if (listData != null) {
    if (listData is List<dynamic>) {

      for(var items in listData){

        if(items is Map<String,dynamic>){
          final String name = items['name'];
          final int id = items['id'];

          if(id != null && name != null){
            Data?[id.toString()] = name.toString();
          }

        }
      }
    }

    if (listData is Map<String, dynamic>) {
      Data = json['data'];
    }
  }
  return DocumentsSpecificTypeModel(
    success: json['success'] as bool?,
    data: Data,
    message: json['message'] as String?,
  );
}

DocumentsSpecificTypeData _$DocumentsSpecificTypeDataFromJson(
        Map<String, dynamic> json) =>
    DocumentsSpecificTypeData(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
