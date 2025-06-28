

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controller/doctor/doctor_prescription_controller/doctor_new_prescriptions_controller.dart';

class DoctorNewPrescriptionsScreen extends StatelessWidget {
  const DoctorNewPrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    NewDoctorPrescriptionsController newDoctorPrescriptionsController = Get.put(NewDoctorPrescriptionsController());
    return Container();
  }
}
