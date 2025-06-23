import 'dart:convert';

import 'package:get/get.dart';

part 'get_lab_tests.g.dart';

class LabtestsModel {
  bool? success;
  List<LabTestsDataModel>? data;
  String? message;

  LabtestsModel({
    this.success,
    this.data,
    this.message,
  });

  factory LabtestsModel.fromJson(Map<String,dynamic>json) => _LabTestsModelFromjson(json);
}

class LabTestsDataModel{
  int? id;
  String? test_name;
  RxList<String>? json_labels;
  LabTestsDataModel({
    this.id,
    this.test_name,
    this.json_labels
});
  factory LabTestsDataModel.fromJson(Map<String,dynamic>json) => _LabTestsModelDataFromjson(json);
}