part of 'get-document-parents.dart';

GetDocumentParentsModel _GetDocumentParentsModel(Map<String, dynamic> json) {
  Map<String, dynamic>? Data;
  dynamic listData = json['data'];
  if (listData != null) {
    if (listData is Map<String, dynamic>) {
      Data = listData;
    }
  }

  return GetDocumentParentsModel(
    Scusses: json['success'],
    Data: Data,
    Message: json['message'],
  );
}
