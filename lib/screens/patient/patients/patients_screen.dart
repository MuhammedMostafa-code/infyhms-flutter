import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../../../component/common_dropdown_button.dart';
import '../../../constant/color_const.dart';
import '../../../constant/text_style_const.dart';
import '../../../controller/patient/patients_controller/patient_controller.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/string_utils.dart';
import '../document/edit_document_screen.dart';

class patientsScreen extends StatelessWidget {
  patientsScreen({Key? key}) : super(key: key);
  PatientsController PatientController = Get.put(PatientsController());
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return  Scaffold(
      body:  Container(
        color: Colors.white,
        child: Obx(() {
          return PatientController.gotData.value == false
              ? const Center(child: CircularProgressIndicator(color: ColorConst.primaryColor))
              : PatientController.doctorPatientsDocumentsModel?.data?.isEmpty ?? true
              ? Center(
            child: Text(
              "No patients found",
              style: TextStyleConst.mediumTextStyle(
                ColorConst.blackColor,
                width * 0.04,
              ),
            ),
          )
              :ListView.builder(
            itemCount: PatientController.doctorPatientsDocumentsModel!.data?.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.only(top: index == 0 ? 15 : 0, right: 15, left: 15),
                    title: Text(
                      PatientController.doctorPatientsDocumentsModel!.data?[index].patient_name ?? "",
                      style: TextStyleConst.mediumTextStyle(
                        ColorConst.blackColor,
                        width * 0.045,
                      ),
                    ),
                    trailing: Text('${PatientController.doctorPatientsDocumentsModel!.data?[index].id ?? ''}'),
                  ),

                ],
              );
            },
          );
        }),
      ),
    );
  }
}
