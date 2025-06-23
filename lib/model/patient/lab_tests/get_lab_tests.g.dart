part of 'gat_lab_tests.dart';

LabtestsModel _LabTestsModelFromjson(Map<String, dynamic> json) =>
    LabtestsModel(
      success: json['success'],
      data: (json['data'] as List<dynamic?>)
          ?.map((e) => LabTestsDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'],
    );

LabTestsDataModel _LabTestsModelDataFromjson(Map<String, dynamic> json) {
  RxList<String>? stringLabels = <String>[].obs;

  try {
    final raw = json['json_labels'];
    if (raw != null && raw is String && raw.trim().isNotEmpty) {
      List<dynamic> labelsList = jsonDecode(raw);
      stringLabels = RxList<String>.from(labelsList);
    }
  } catch (e) {
    print("⚠️ خطأ أثناء تحويل json_labels: $e");
    // لو حصل خطأ، يرجع stringLabels فاضية
  }


  return LabTestsDataModel(
    id: json['id'],
    test_name: json['test_name'],
    json_labels: stringLabels,
  );
}

