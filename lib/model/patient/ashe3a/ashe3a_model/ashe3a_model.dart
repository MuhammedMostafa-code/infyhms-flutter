part 'ashe3a_model.g.dart';

class Ashe3aModel {
  bool? Scusses;
  List<Ashe3aDataModel>? data;
  String? Message;

  Ashe3aModel({this.data, this.Message, this.Scusses});

  factory Ashe3aModel.fromJson(Map<String, dynamic> json) =>
      _$Ashe3aModelFromJson(json);
}

class Ashe3aDataModel {
  int? id;
  String? name;

  Ashe3aDataModel({this.name,this.id});

  factory Ashe3aDataModel.formJson(Map<String,dynamic> json) => _$Ashe3aDataModelFromJson(json);
}
