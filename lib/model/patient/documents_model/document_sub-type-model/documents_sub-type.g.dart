part of 'documents_sub-type.dart';

DocumentsSubTypeModel _$DocumentsSubTypeModelFromJson(
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
  return DocumentsSubTypeModel(
    success: json['success'] as bool?,
    data: Data,
    message: json['message'] as String?,
  );
}

DocumentsSubTypeData _$DocumentsSubTypeDataFromJson(
        Map<String, dynamic> json) =>
    DocumentsSubTypeData(id: json['id'], name: json['name']);
