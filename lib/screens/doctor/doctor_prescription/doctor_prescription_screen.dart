import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infyhms_flutter/constant/color_const.dart';
import 'package:infyhms_flutter/constant/text_style_const.dart';
import 'package:infyhms_flutter/controller/doctor/doctor_prescription_controller/doctor_prescription_controller.dart';
import 'package:infyhms_flutter/screens/doctor/doctor_prescription/doctor_prescription_detail_screen.dart';

import '../../../utils/preference_utils.dart';
import '../../patient/prescription/new_prescriptions_screen.dart';

class DoctorPrescriptionScreen extends StatelessWidget {
  DoctorPrescriptionScreen({Key? key}) : super(key: key);
  final DoctorPrescriptionController doctorPrescriptionController = Get.put(DoctorPrescriptionController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        color: ColorConst.whiteColor,
        child: Obx(() {
          return doctorPrescriptionController.isGetPrescription.value != true
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: doctorPrescriptionController.doctorPrescriptionModel!.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.only(top: index == 0 ? 5 : 0, left: 15, right: 15),
                          onTap: () {
                            Get.to(
                              () => DoctorPrescriptionDetailScreen(),
                              transition: Transition.rightToLeft,
                              arguments: doctorPrescriptionController.doctorPrescriptionModel!.data![index].id,
                            );
                          },
                          leading: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(doctorPrescriptionController.doctorPrescriptionModel!.data![index].patient_image!),
                              ),
                            ),
                            // child: CachedNetworkImage(
                            //   imageUrl:
                            //       appointmentModel!.data![index].doctor_image_url!,
                            //   placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            //   errorWidget: (context, url, error) => const Icon(Icons.error),
                            // ),
                          ),
                          title: Text(
                            doctorPrescriptionController.doctorPrescriptionModel!.data![index].patient_name!,
                            style: TextStyleConst.mediumTextStyle(
                              ColorConst.blackColor,
                              width * 0.045,
                            ),
                          ),
                          subtitle: Text(
                            doctorPrescriptionController.doctorPrescriptionModel!.data![index].created_date!,
                            style: TextStyleConst.mediumTextStyle(ColorConst.hintGreyColor, width * 0.036),
                          ),
                        ),
                      ],
                    );
                  },
                );
        }));
  }
}
