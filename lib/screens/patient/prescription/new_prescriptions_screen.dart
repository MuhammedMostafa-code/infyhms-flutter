import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constant/color_const.dart';
import '../../../controller/patient/prescription_controller/new_prescriptions_controller.dart';
import '../../../utils/preference_utils.dart';

class NewPrescriptionsScreen extends StatelessWidget {
  const NewPrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    NewPrescriptionsController newPrescriptionsController =
        Get.put(NewPrescriptionsController());
    return SafeArea(
        child: Stack(
      children: [],
    ));
  }
}
