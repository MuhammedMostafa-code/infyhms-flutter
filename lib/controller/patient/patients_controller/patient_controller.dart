import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../model/doctor/doctor_document_model/doctor_patients_model.dart';
import '../../../utils/preference_utils.dart';
import '../../../utils/string_utils.dart';

class PatientsController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  RxBool gotData = false.obs;
  DoctorPatientsDocumentsModel? doctorPatientsDocumentsModel;
  String? patientId;
  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
      getPatients();
  }
  void getPatients() {
    StringUtils.client.doctorPatientsDocument(PreferenceUtils.getStringValue("token"))
      ..then((value) {
        doctorPatientsDocumentsModel = value;
        gotData.value = true;
      })
      ..onError((DioError error, stackTrace) {
        gotData.value = true;
        return DoctorPatientsDocumentsModel();
      });
  }

}