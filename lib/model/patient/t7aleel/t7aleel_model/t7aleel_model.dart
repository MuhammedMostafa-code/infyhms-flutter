part 't7aleel_model.g.dart';

class Ta7aleelModel {
  bool? Scusses;
  List<Ta7aleelDataModel>? data;
  String? Message;

  Ta7aleelModel({this.data, this.Message, this.Scusses});

  factory Ta7aleelModel.fromJson(Map<String, dynamic> json) =>
      _$Ta7aleelModelFromJson(json);
}

class Ta7aleelDataModel {
  int? id;
  String? name;

  Ta7aleelDataModel({this.name,this.id});

  factory Ta7aleelDataModel.formJson(Map<String,dynamic> json) => _$Ta7aleelDataModelFromJson(json);
}
