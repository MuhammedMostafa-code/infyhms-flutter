// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:infyhms_flutter/constant/color_const.dart';
import 'package:infyhms_flutter/constant/text_style_const.dart';
import 'package:infyhms_flutter/controller/patient/document_controller/document_list_controller.dart';
import 'package:infyhms_flutter/controller/patient/t7aleel_controller/t7aleel_controller.dart';
import 'package:infyhms_flutter/screens/patient/Document_Image.dart';
import 'package:infyhms_flutter/screens/patient/document/edit_document_screen.dart';
import 'package:infyhms_flutter/screens/patient/document/new_document_screen.dart';
import 'package:infyhms_flutter/utils/image_utils.dart';
import 'package:infyhms_flutter/utils/preference_utils.dart';
import 'package:infyhms_flutter/utils/string_utils.dart';

import '../../../New Functions/Search.dart';
import '../../../New Functions/Search_With_API.dart';

class T7aleelScreen extends StatefulWidget {
  T7aleelScreen({Key? key}) : super(key: key);

  @override
  State<T7aleelScreen> createState() => _T7aleelScreenState();
}

class _T7aleelScreenState extends State<T7aleelScreen> {
  T7aleelController t7aleelController = Get.put(T7aleelController());

  String query = '' ;


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (PreferenceUtils.getBoolValue("isDoctor")) {
      return Stack(
        children: [
          Container(
            color: Colors.white,
            child: Obx(() {
              final dataList = t7aleelController.doctorDocumentsModel?.data ?? [];
              final filteredList = dataList.where((doc) => doc.document_type_id == 1).toList();
              return t7aleelController.gotData.value == false
                  ? const Center(child: CircularProgressIndicator(color: ColorConst.primaryColor))
                  : filteredList.isEmpty ?? true
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
                                        () => EditDocumentScreen(documentId: filteredList[index].id ?? 0),
                                    transition: Transition.leftToRight,
                                    arguments: {
                                      "title": filteredList[index].title,
                                      "docType": filteredList[index].document_type_id,
                                      "attachment": filteredList[index].document_url,
                                      "note": filteredList[index].notes,
                                      "patientId": filteredList[index].patient_id.toString(),
                                    });
                                if (message == "Call API") {
                                  t7aleelController.getDoctorDocuments();
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
                                t7aleelController.showDeleteDialog(context, height, width, index);
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
                            filteredList[index].title ?? "",
                            style: TextStyleConst.mediumTextStyle(
                              ColorConst.blackColor,
                              width * 0.045,
                            ),
                          ),
                          subtitle: Text(
                            filteredList[index].notes ?? "",
                            style: TextStyleConst.mediumTextStyle(
                              ColorConst.hintGreyColor,
                              width * 0.037,
                            ),
                          ),
                          leading: IconButton(onPressed: () {
                            t7aleelController.showDocumentWithZoom(context , index);
                          }, icon: Icon(Icons.image)),
                          trailing: Obx(() {
                            return t7aleelController.isCurrentDownloading[index].value
                                ? const CircularProgressIndicator(color: ColorConst.primaryColor)
                                : InkWell(
                              onTap: () {
                                t7aleelController.downloadDocument(context, index);
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
                          t7aleelController.getDoctorDocuments();
                        } else {
                          t7aleelController.getDocuments();
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
              return t7aleelController.gotData.value == false
                  ? const Center(child: CircularProgressIndicator(color: ColorConst.primaryColor))
                  : t7aleelController.documentsModel?.data?.isEmpty ?? true
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
                itemCount: t7aleelController.documentsModel!.data!.length,
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
                                        () => EditDocumentScreen(documentId: t7aleelController.documentsModel?.data?[index].id ?? 0),
                                    transition: Transition.leftToRight,
                                    arguments: {
                                      "title": t7aleelController.documentsModel?.data?[index].title,
                                      "docType": t7aleelController.documentsModel?.data?[index].document_type_id,
                                      "attachment": t7aleelController.documentsModel?.data?[index].document_url,
                                      "note": t7aleelController.documentsModel?.data?[index].notes,
                                    });
                                if (message == "Call API") {
                                  t7aleelController.getDocuments();
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
                                t7aleelController.showDeleteDialog(context, height, width, index);
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
                              t7aleelController.documentsModel?.data?[index].title ?? "",
                              style: TextStyleConst.mediumTextStyle(
                                ColorConst.blackColor,
                                width * 0.045,
                              ),
                            ),
                            subtitle: Text(
                              t7aleelController.documentsModel?.data?[index].notes ?? "",
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
                                  () => t7aleelController.isCurrentDownloading[index].value
                                  ? const CircularProgressIndicator(color: ColorConst.primaryColor)
                                  : InkWell(
                                onTap: () {
                                  t7aleelController.downloadDocument(context, index);
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
                      final message = await Get.to(() => NewDocumentScreen(), transition: Transition.rightToLeft);
                      if (message == "Call API") {
                        if (PreferenceUtils.getBoolValue("isDoctor")) {
                          t7aleelController.getDoctorDocuments();
                        } else {
                          t7aleelController.getDocuments();
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
