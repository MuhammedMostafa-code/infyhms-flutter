import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infyhms_flutter/component/common_alert_box.dart';
import 'package:infyhms_flutter/component/common_button.dart';
import 'package:infyhms_flutter/constant/color_const.dart';
import 'package:infyhms_flutter/constant/text_style_const.dart';
import 'package:infyhms_flutter/controller/doctor/doctor_appoinment_controller/doctor_appoinment_controller.dart';
import 'package:infyhms_flutter/controller/doctor/doctor_appoinment_controller/doctor_filter_appointment_controller.dart';
import 'package:infyhms_flutter/controller/patient/appointment_controller/appointment_controller.dart';
import 'package:infyhms_flutter/controller/patient/appointment_controller/filter_appointment_controller.dart';
import 'package:infyhms_flutter/screens/patient/appointment/new_appointment_screen.dart';
import 'package:infyhms_flutter/utils/image_utils.dart';
import 'package:infyhms_flutter/utils/preference_utils.dart';
import 'package:infyhms_flutter/utils/string_utils.dart';

class AppointmentScreen extends StatelessWidget {
  AppointmentScreen({Key? key}) : super(key: key);
  final AppointmentController appointmentController = Get.put(AppointmentController());
  final DoctorAppointmentController doctorAppointmentController = Get.put(DoctorAppointmentController());
  final FilterAppointmentController filterAppointmentController = Get.put(FilterAppointmentController());
  final DoctorFilterAppointmentController doctorFilterAppointmentController = Get.put(DoctorFilterAppointmentController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: ColorConst.whiteColor,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 70,
                margin: EdgeInsets.only(top: height * 0.01),
                width: double.infinity,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: PreferenceUtils.getBoolValue("isDoctor")
                      ? doctorAppointmentController.appointmentStatus.length
                      : appointmentController.appointmentStatus.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Obx(
                        () => GestureDetector(
                          onTap: () {
                            if (PreferenceUtils.getBoolValue("isDoctor")) {
                              doctorFilterAppointmentController.changeDoctorIndex(index);
                            } else {
                              filterAppointmentController.changeIndex(index);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: width * 0.03, right: index == 3 ? 10 : 0),
                            height: 50,
                            decoration: PreferenceUtils.getBoolValue("isDoctor")
                                ? index == doctorAppointmentController.currentIndex.value
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ColorConst.blueColor,
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 2,
                                          color: ColorConst.borderGreyColor,
                                        ),
                                      )
                                : index == appointmentController.currentIndex.value
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ColorConst.blueColor,
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 2,
                                          color: ColorConst.borderGreyColor,
                                        ),
                                      ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  PreferenceUtils.getBoolValue("isDoctor")
                                      ? doctorAppointmentController.appointmentStatus[index]
                                      : appointmentController.appointmentStatus[index],
                                  style: TextStyleConst.mediumTextStyle(
                                    PreferenceUtils.getBoolValue("isDoctor")
                                        ? index == doctorAppointmentController.currentIndex.value
                                            ? ColorConst.whiteColor
                                            : ColorConst.hintGreyColor
                                        : index == appointmentController.currentIndex.value
                                            ? ColorConst.whiteColor
                                            : ColorConst.hintGreyColor,
                                    width * 0.04,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Obx(() {
                if (PreferenceUtils.getBoolValue("isDoctor")) {
                  return doctorFilterAppointmentController.isDoctorFilterApiCall.value != false
                      ? doctorFilterAppointmentController.doctorAppointmentModel!.data!.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: doctorFilterAppointmentController.doctorAppointmentModel!.data!.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      doctorAppointmentController.currentIndex.value == 0
                                          ? Slidable(
                                              endActionPane: ActionPane(
                                                extentRatio: 0.25,
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      ContentOfDialog contentOfDialog = ContentOfDialog(
                                                        height: height,
                                                        width: width,
                                                        image: ImageUtils.alertIcon,
                                                        title: "Change status",
                                                        description: "Are you sure want to change\nAppointment status?",
                                                        leftText: StringUtils.confirm,
                                                        rightText: StringUtils.cancel,
                                                        leftTapEvent: () {
                                                          Get.back();
                                                          doctorFilterAppointmentController.confirmAppointment(
                                                              doctorFilterAppointmentController.doctorAppointmentModel!.data![index].id!);
                                                        },
                                                        rightTapEvent: () {
                                                          Get.back();
                                                        },
                                                      );
                                                      CommonAlertDialog.commonAlertDialog(context, contentOfDialog);
                                                    },
                                                    backgroundColor: const Color(0xFFE5F6EA),
                                                    foregroundColor: ColorConst.greenColor,
                                                    label: StringUtils.confirm,
                                                  ),
                                                ],
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  doctorFilterAppointmentController.doctorAppointmentModel!.data![index].patient_name!,
                                                  style: TextStyleConst.mediumTextStyle(
                                                    ColorConst.blackColor,
                                                    width * 0.045,
                                                  ),
                                                ),
                                                subtitle: Row(
                                                  children: [
                                                    Text(
                                                      "${doctorFilterAppointmentController.doctorAppointmentModel!.data![index].appointment_time!} - ",
                                                      style: TextStyleConst.mediumTextStyle(
                                                        ColorConst.hintGreyColor,
                                                        width * 0.036,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        doctorFilterAppointmentController.doctorAppointmentModel!.data![index].appointment_date!,
                                                        style: TextStyleConst.mediumTextStyle(
                                                          ColorConst.hintGreyColor,
                                                          width * 0.036,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                leading: Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          doctorFilterAppointmentController.doctorAppointmentModel!.data![index].patient_image!),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : ListTile(
                                              title: Text(
                                                doctorFilterAppointmentController.doctorAppointmentModel!.data![index].patient_name!,
                                                style: TextStyleConst.mediumTextStyle(
                                                  ColorConst.blackColor,
                                                  width * 0.045,
                                                ),
                                              ),
                                              subtitle: Row(
                                                children: [
                                                  Text(
                                                    "${doctorFilterAppointmentController.doctorAppointmentModel!.data![index].appointment_time!} - ",
                                                    style: TextStyleConst.mediumTextStyle(
                                                      ColorConst.hintGreyColor,
                                                      width * 0.036,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      doctorFilterAppointmentController.doctorAppointmentModel!.data![index].appointment_date!,
                                                      style: TextStyleConst.mediumTextStyle(
                                                        ColorConst.hintGreyColor,
                                                        width * 0.036,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              leading: Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        doctorFilterAppointmentController.doctorAppointmentModel!.data![index].patient_image!),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      SizedBox(height: height * 0.01),
                                    ],
                                  );
                                },
                              ),
                            )
                          : Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Appointment not found",
                                  style: TextStyleConst.mediumTextStyle(
                                    ColorConst.blackColor,
                                    width * 0.04,
                                  ),
                                ),
                              ),
                            )
                      : const Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                } else {
                  return filterAppointmentController.isApiCall.value != false
                      ? filterAppointmentController.filterAppointmentModel!.data!.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: filterAppointmentController.filterAppointmentModel!.data!.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      appointmentController.currentIndex.value == 1
                                          ? Slidable(
                                              startActionPane: ActionPane(
                                                extentRatio: 0.25,
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (context) {
                                                          return Center(
                                                            child: Container(
                                                              height: height / 2.7,
                                                              width: width / 1.12,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                                color: Colors.white,
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    height: 60,
                                                                    width: 60,
                                                                    decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                        image: AssetImage(ImageUtils.alertIcon),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: height * 0.03),
                                                                  Text(
                                                                    "Cancel Appointment",
                                                                    style: TextStyleConst.boldTextStyle(
                                                                      ColorConst.blackColor,
                                                                      width * 0.05,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: height * 0.01),
                                                                  Text(
                                                                    "Are you sure want to cancel\n Appointment?",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyleConst.mediumTextStyle(
                                                                      ColorConst.hintGreyColor,
                                                                      width * 0.042,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: height * 0.03),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      CommonButton(
                                                                        textStyleConst:
                                                                            TextStyleConst.mediumTextStyle(ColorConst.whiteColor, width * 0.05),
                                                                        onTap: () {
                                                                          Get.back();
                                                                          filterAppointmentController.cancelledPendingAppointment(
                                                                              filterAppointmentController.filterAppointmentModel!.data![index].id!);
                                                                        },
                                                                        color: ColorConst.blueColor,
                                                                        text: StringUtils.yes,
                                                                        width: width / 2.5,
                                                                        height: 50,
                                                                      ),
                                                                      CommonButton(
                                                                        textStyleConst:
                                                                            TextStyleConst.mediumTextStyle(ColorConst.hintGreyColor, width * 0.05),
                                                                        onTap: () {
                                                                          Get.back();
                                                                        },
                                                                        color: ColorConst.borderGreyColor,
                                                                        text: StringUtils.no,
                                                                        width: width / 2.5,
                                                                        height: 50,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    backgroundColor: ColorConst.borderGreyColor,
                                                    foregroundColor: ColorConst.blackColor,
                                                    label: StringUtils.cancel,
                                                  ),
                                                ],
                                              ),
                                              endActionPane: ActionPane(
                                                extentRatio: 0.25,
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (context) {
                                                          return Center(
                                                            child: Container(
                                                              height: height / 2.7,
                                                              width: width / 1.12,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                                color: Colors.white,
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    height: 60,
                                                                    width: 60,
                                                                    decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                        image: AssetImage(ImageUtils.deleteIcon),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: height * 0.03),
                                                                  Text(
                                                                    "Delete",
                                                                    style: TextStyleConst.boldTextStyle(
                                                                      ColorConst.blackColor,
                                                                      width * 0.05,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: height * 0.01),
                                                                  Text(
                                                                    "Are you sure want to delete this\n Appointment?",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyleConst.mediumTextStyle(
                                                                      ColorConst.hintGreyColor,
                                                                      width * 0.042,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: height * 0.03),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      CommonButton(
                                                                        textStyleConst: TextStyleConst.mediumTextStyle(
                                                                          ColorConst.whiteColor,
                                                                          width * 0.05,
                                                                        ),
                                                                        onTap: () {
                                                                          print('-=-=-=-=-=-=-=-=-Delete-=-=-=1');
                                                                          Get.back();
                                                                          filterAppointmentController.deletePendingAppointment(
                                                                              filterAppointmentController.filterAppointmentModel!.data![index].id!);
                                                                        },
                                                                        color: ColorConst.blueColor,
                                                                        text: StringUtils.delete,
                                                                        width: width / 2.5,
                                                                        height: 50,
                                                                      ),
                                                                      CommonButton(
                                                                        textStyleConst: TextStyleConst.mediumTextStyle(
                                                                          ColorConst.hintGreyColor,
                                                                          width * 0.05,
                                                                        ),
                                                                        onTap: () {
                                                                          Get.back();
                                                                        },
                                                                        color: ColorConst.borderGreyColor,
                                                                        text: StringUtils.cancel,
                                                                        width: width / 2.5,
                                                                        height: 50,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    backgroundColor: const Color(0xFFFCE5E5),
                                                    foregroundColor: ColorConst.redColor,
                                                    label: StringUtils.delete,
                                                  ),
                                                ],
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  filterAppointmentController.filterAppointmentModel!.data![index].doctor_name!,
                                                  style: TextStyleConst.mediumTextStyle(
                                                    ColorConst.blackColor,
                                                    width * 0.045,
                                                  ),
                                                ),
                                                subtitle: Row(
                                                  children: [
                                                    Text(
                                                      "${filterAppointmentController.filterAppointmentModel!.data![index].doctor_department!} | ",
                                                      style: TextStyleConst.mediumTextStyle(
                                                        ColorConst.hintGreyColor,
                                                        width * 0.036,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${filterAppointmentController.filterAppointmentModel!.data![index].appointment_time!} - ",
                                                      style: TextStyleConst.mediumTextStyle(
                                                        ColorConst.hintGreyColor,
                                                        width * 0.036,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        filterAppointmentController.filterAppointmentModel!.data![index].appointment_date!,
                                                        style: TextStyleConst.mediumTextStyle(
                                                          ColorConst.hintGreyColor,
                                                          width * 0.036,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                leading: Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          filterAppointmentController.filterAppointmentModel!.data![index].doctor_image_url!),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Slidable(
                                              endActionPane: ActionPane(
                                                extentRatio: 0.25,
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (context) {
                                                          return Center(
                                                            child: Container(
                                                              height: height / 2.7,
                                                              width: width / 1.12,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                                color: Colors.white,
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    height: 60,
                                                                    width: 60,
                                                                    decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                        image: AssetImage(ImageUtils.deleteIcon),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: height * 0.03),
                                                                  Text(
                                                                    "Delete",
                                                                    style: TextStyleConst.boldTextStyle(
                                                                      ColorConst.blackColor,
                                                                      width * 0.05,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: height * 0.01),
                                                                  Text(
                                                                    "Are you sure want to delete this\n appointment?",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyleConst.mediumTextStyle(
                                                                      ColorConst.hintGreyColor,
                                                                      width * 0.042,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: height * 0.03),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      CommonButton(
                                                                        textStyleConst: TextStyleConst.mediumTextStyle(
                                                                          ColorConst.whiteColor,
                                                                          width * 0.05,
                                                                        ),
                                                                        onTap: () {
                                                                          Get.back();
                                                                          filterAppointmentController.deleteAppointment(
                                                                              filterAppointmentController.filterAppointmentModel!.data![index].id!);
                                                                        },
                                                                        color: ColorConst.blueColor,
                                                                        text: StringUtils.delete,
                                                                        width: width / 2.5,
                                                                        height: 50,
                                                                      ),
                                                                      CommonButton(
                                                                        textStyleConst: TextStyleConst.mediumTextStyle(
                                                                          ColorConst.hintGreyColor,
                                                                          width * 0.05,
                                                                        ),
                                                                        onTap: () {
                                                                          Get.back();
                                                                        },
                                                                        color: ColorConst.borderGreyColor,
                                                                        text: StringUtils.cancel,
                                                                        width: width / 2.5,
                                                                        height: 50,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    backgroundColor: const Color(0xFFFCE5E5),
                                                    foregroundColor: ColorConst.redColor,
                                                    label: StringUtils.delete,
                                                  ),
                                                ],
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  filterAppointmentController.filterAppointmentModel!.data![index].doctor_name!,
                                                  style: TextStyleConst.mediumTextStyle(
                                                    ColorConst.blackColor,
                                                    width * 0.045,
                                                  ),
                                                ),
                                                subtitle: Row(
                                                  children: [
                                                    Text(
                                                      "${filterAppointmentController.filterAppointmentModel!.data![index].doctor_department!} | ",
                                                      style: TextStyleConst.mediumTextStyle(
                                                        ColorConst.hintGreyColor,
                                                        width * 0.036,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${filterAppointmentController.filterAppointmentModel!.data![index].appointment_time!} - ",
                                                      style: TextStyleConst.mediumTextStyle(
                                                        ColorConst.hintGreyColor,
                                                        width * 0.036,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        filterAppointmentController.filterAppointmentModel!.data![index].appointment_date!,
                                                        style: TextStyleConst.mediumTextStyle(
                                                          ColorConst.hintGreyColor,
                                                          width * 0.036,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                leading: Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          filterAppointmentController.filterAppointmentModel!.data![index].doctor_image_url!),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      SizedBox(height: height * 0.01),
                                    ],
                                  );
                                },
                              ),
                            )
                          : Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Appointment not found",
                                  style: TextStyleConst.mediumTextStyle(
                                    ColorConst.blackColor,
                                    width * 0.04,
                                  ),
                                ),
                              ),
                            )
                      : const Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                }
              })
            ],
          ),
          PreferenceUtils.getBoolValue("isDoctor")
              ? const SizedBox()
              : Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const NewAppointmentScreen(), transition: Transition.rightToLeft);
                      },
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorConst.blueColor,
                        ),
                        child: const Icon(Icons.add, color: ColorConst.whiteColor),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
