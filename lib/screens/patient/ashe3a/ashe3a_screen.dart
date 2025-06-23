import 'package:flutter/cupertino.dart';
import 'package:infyhms_flutter/controller/patient/ashe3a_controller/ashe3a_controller.dart';
import '../../../utils/preference_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infyhms_flutter/constant/color_const.dart';
import 'package:infyhms_flutter/constant/text_style_const.dart';
import 'package:infyhms_flutter/controller/patient/document_controller/document_list_controller.dart';
import 'package:infyhms_flutter/screens/patient/Document_Image.dart';
import 'package:infyhms_flutter/screens/patient/document/edit_document_screen.dart';
import 'package:infyhms_flutter/screens/patient/document/new_document_screen.dart';
import 'package:infyhms_flutter/utils/image_utils.dart';
import 'package:infyhms_flutter/utils/preference_utils.dart';
import 'package:infyhms_flutter/utils/string_utils.dart';

import '../../../New Functions/Search.dart';
import '../../../New Functions/Search_With_API.dart';
class Ashe3aScreen extends StatefulWidget {
  const Ashe3aScreen({super.key});
  
  @override
  State<Ashe3aScreen> createState() => _Ashe3aScreenState();
}

class _Ashe3aScreenState extends State<Ashe3aScreen> {
  @override
  Widget build(BuildContext context) {
    Ashe3aController ashe3aController = Get.put(Ashe3aController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (PreferenceUtils.getBoolValue("isDoctor")) {
      return Stack(
        children: [
          Container(
            color: Colors.white,
            child: Obx(() {
              final dataList = ashe3aController.doctorDocumentsModel?.data ?? [];
              final filteredList = dataList.where((doc) => doc.document_type_id == 2).toList();
              return ashe3aController.gotData.value == false
                  ? const Center(child: CircularProgressIndicator(color: ColorConst.primaryColor))
                  : dataList.isEmpty ?? true
                  ? Center(
                child: Text(
                  "No documents found",
                  style: TextStyleConst.mediumTextStyle(
                    ColorConst.blackColor,
                    width * 0.04,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredList.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Slidable(
                        startActionPane: ActionPane(
                          extentRatio: 0.25,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (contextAction) async {
                                final message = await Get.to(
                                        () => EditDocumentScreen(documentId: dataList[index].id ?? 0),
                                    transition: Transition.leftToRight,
                                    arguments: {
                                      "title": dataList[index].title,
                                      "docType": dataList[index].document_type_id,
                                      "attachment": dataList[index].document_url,
                                      "note": dataList[index].notes,
                                      "patientId": dataList[index].patient_id.toString(),
                                    });
                                if (message == "Call API") {
                                  ashe3aController.getDoctorDocuments();
                                }
                              },
                              backgroundColor: ColorConst.orangeColor.withOpacity(0.15),
                              label: StringUtils.edit,
                              foregroundColor: ColorConst.orangeColor,
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          extentRatio: 0.25,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (contextAction) {
                                ashe3aController.showDeleteDialog(context, height, width, index);
                              },
                              backgroundColor: const Color(0xFFFCE5E5),
                              label: StringUtils.delete,
                              foregroundColor: ColorConst.redColor,
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {},
                          contentPadding: EdgeInsets.only(top: index == 0 ? 15 : 0, right: 15, left: 15),
                          title: Text(
                            dataList[index].title ?? "",
                            style: TextStyleConst.mediumTextStyle(
                              ColorConst.blackColor,
                              width * 0.045,
                            ),
                          ),
                          subtitle: Text(
                            dataList[index].notes ?? "",
                            style: TextStyleConst.mediumTextStyle(
                              ColorConst.hintGreyColor,
                              width * 0.037,
                            ),
                          ),
                          leading: IconButton(onPressed: () {
                            ashe3aController.showDocumentWithZoom(context , index);
                          }, icon: Icon(Icons.image)),
                          trailing: Obx(() {
                            return ashe3aController.isCurrentDownloading[index].value
                                ? const CircularProgressIndicator(color: ColorConst.primaryColor)
                                : InkWell(
                              onTap: () {
                                ashe3aController.downloadDocument(context, index);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 25,
                                height: 25,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(ImageUtils.downloadIcon),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom:  25, right: 15),
                  child: GestureDetector(
                    onTap: () async {
                      showSearch(context: context, delegate: DocumentSearch());
                    },
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorConst.blueColor,
                      ),
                      child: const Icon(Icons.search_outlined, color: ColorConst.whiteColor),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom:  25, right: 15),
                  child: GestureDetector(
                    onTap: () async {
                      final message = await Get.to(() => NewDocumentScreen(), transition: Transition.rightToLeft);
                      if (message == "Call API") {
                        if (PreferenceUtils.getBoolValue("isDoctor")) {
                          ashe3aController.getDoctorDocuments();
                        } else {
                          ashe3aController.getDocuments();
                        }
                      }
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
            ],),
        ],
      );
    } else {
      return Stack(
        children: [
          Container(
            color: Colors.white,
            child: Obx(() {
              return ashe3aController.gotData.value == false
                  ? const Center(child: CircularProgressIndicator(color: ColorConst.primaryColor))
                  : ashe3aController.documentsModel?.data?.isEmpty ?? true
                  ? Center(
                child: Text(
                  "No documents found",
                  style: TextStyleConst.mediumTextStyle(
                    ColorConst.blackColor,
                    width * 0.04,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: ashe3aController.documentsModel!.data!.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Slidable(
                        startActionPane: ActionPane(
                          extentRatio: 0.25,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (contextAction) async {
                                final message = await Get.to(
                                        () => EditDocumentScreen(documentId: ashe3aController.documentsModel?.data?[index].id ?? 0),
                                    transition: Transition.leftToRight,
                                    arguments: {
                                      "title": ashe3aController.documentsModel?.data?[index].title,
                                      "docType": ashe3aController.documentsModel?.data?[index].document_type_id,
                                      "attachment": ashe3aController.documentsModel?.data?[index].document_url,
                                      "note": ashe3aController.documentsModel?.data?[index].notes,
                                    });
                                if (message == "Call API") {
                                  ashe3aController.getDocuments();
                                }
                              },
                              backgroundColor: ColorConst.orangeColor.withOpacity(0.15),
                              label: StringUtils.edit,
                              foregroundColor: ColorConst.orangeColor,
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          extentRatio: 0.25,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (contextAction) {
                                ashe3aController.showDeleteDialog(context, height, width, index);
                              },
                              backgroundColor: const Color(0xFFFCE5E5),
                              label: StringUtils.delete,
                              foregroundColor: ColorConst.redColor,
                            ),
                          ],
                        ),
                        child: ListTile(
                            onTap: () {},
                            contentPadding: EdgeInsets.only(top: index == 0 ? 15 : 0, right: 15, left: 15),
                            title: Text(
                              ashe3aController.documentsModel?.data?[index].title ?? "",
                              style: TextStyleConst.mediumTextStyle(
                                ColorConst.blackColor,
                                width * 0.045,
                              ),
                            ),
                            subtitle: Text(
                              ashe3aController.documentsModel?.data?[index].notes ?? "",
                              style: TextStyleConst.mediumTextStyle(
                                ColorConst.hintGreyColor,
                                width * 0.037,
                              ),
                            ),
                            leading: Container(
                              height: 35,
                              width: 35,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage("assets/icon/imageIcon.png"),
                                ),
                              ),
                            ),
                            trailing: Obx(
                                  () => ashe3aController.isCurrentDownloading[index].value
                                  ? const CircularProgressIndicator(color: ColorConst.primaryColor)
                                  : InkWell(
                                onTap: () {
                                  ashe3aController.downloadDocument(context, index);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 25,
                                  height: 25,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(ImageUtils.downloadIcon),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom:  25, right: 15),
                  child: GestureDetector(
                    onTap: () async {
                      showSearch(context: context, delegate: DocumentSearch());
                    },
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorConst.blueColor,
                      ),
                      child: const Icon(Icons.search_outlined, color: ColorConst.whiteColor),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom:  25, right: 15),
                  child: GestureDetector(
                    onTap: () async {
                      final message = await Get.to(() => Ashe3aScreen(), transition: Transition.rightToLeft);
                      if (message == "Call API") {
                        if (PreferenceUtils.getBoolValue("isDoctor")) {
                          ashe3aController.getDoctorDocuments();
                        } else {
                          ashe3aController.getDocuments();
                        }
                      }
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
            ],),
        ],
      );
    }
  }
}
