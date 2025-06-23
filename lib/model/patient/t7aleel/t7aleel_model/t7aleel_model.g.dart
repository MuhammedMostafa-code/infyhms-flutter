part of 't7aleel_model.dart';

Ta7aleelModel _$Ta7aleelModelFromJson(Map<String, dynamic> json) =>
    Ta7aleelModel(
        Scusses: json['success'],
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => Ta7aleelDataModel.formJson(e as Map<String, dynamic>))
            .toList(),
        Message: json['message']);

Ta7aleelDataModel _$Ta7aleelDataModelFromJson(Map<String, dynamic> json) =>
    Ta7aleelDataModel(
      id: json['id'],
      name: json['test_name'],
    );
