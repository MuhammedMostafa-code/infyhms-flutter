
part 'get-document-parents.g.dart';

class GetDocumentParentsModel {
  bool? Scusses;
  Map<String,dynamic>? Data;
  String? Message;

  factory GetDocumentParentsModel.fromJson(Map<String,dynamic> json) => _GetDocumentParentsModel(json);


  GetDocumentParentsModel(
      {
        this.Scusses,
        this.Data,
        this.Message,
      });
}
