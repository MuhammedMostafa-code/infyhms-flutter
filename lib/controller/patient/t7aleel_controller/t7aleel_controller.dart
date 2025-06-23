import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:infyhms_flutter/component/common_button.dart';
import 'package:infyhms_flutter/component/common_loader.dart';
import 'package:infyhms_flutter/component/common_snackbar.dart';
import 'package:infyhms_flutter/component/common_socket_exception.dart';
import 'package:infyhms_flutter/constant/color_const.dart';
import 'package:infyhms_flutter/constant/text_style_const.dart';
import 'package:infyhms_flutter/model/doctor/doctor_document_model/doctor_documents_crud_model.dart';
import 'package:infyhms_flutter/model/doctor/doctor_document_model/doctor_documents_model.dart';
import 'package:infyhms_flutter/model/patient/documents_model/document_delete_model/document_delete.dart';
import 'package:infyhms_flutter/model/patient/documents_model/documents_model/documents.dart';
import 'package:infyhms_flutter/utils/image_utils.dart';
import 'package:infyhms_flutter/utils/preference_utils.dart';
import 'package:infyhms_flutter/utils/string_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class T7aleelController extends GetxController {
  DocumentsModel? documentsModel;
  DoctorDocumentsModel? doctorDocumentsModel;
  RxBool gotData = false.obs;

  int? currentIndex;

  List<RxBool> isCurrentDownloading = <RxBool>[];

  RxInt progress = 0.obs;
  ReceivePort receivePort = ReceivePort();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    listenDownload();
    if (PreferenceUtils.getBoolValue("isDoctor")) {
      getDoctorDocuments();
    } else {
      getDocuments();
    }
  }

  void listenDownload() {
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloading");
    receivePort.listen((message) {
      progress.value = message[2];
      if (progress.value == 100) {
        if (isCurrentDownloading[currentIndex ?? 0].value) {
          DisplaySnackBar.displaySnackBar("Document downloaded", 3 , ColorConst.greenColor);
          isCurrentDownloading[currentIndex ?? 0].value = false;
          currentIndex = null;
        }
      }
    });
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  static downloadingCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");
    sendPort?.send([id, status, progress]);
  }

  void downloadDocument(context, int index) async {
    if (!isCurrentDownloading.contains(true.obs)) {
      currentIndex = index;
      String url;
      if (PreferenceUtils.getBoolValue("isDoctor")) {
        url = doctorDocumentsModel?.data?[index].document_url ?? "";
      } else {
        url = documentsModel?.data?[index].document_url ?? "";
      }
      if (Platform.isIOS) {
        launchUrl(Uri.parse(url));
      } else {
        isCurrentDownloading[index].value = true;
        try {
          Directory filePath = await Directory("storage/emulated/0/Documents/HMS").create(recursive: true);
          await FlutterDownloader.enqueue(
            url: url,
            savedDir: filePath.path,
            showNotification: true,
            openFileFromNotification: true,
            saveInPublicStorage: true,
          );
        } catch (e) {
          isCurrentDownloading[index].value = false;
          DisplaySnackBar.displaySnackBar("Document can't be downloaded", 3, ColorConst.redColor);
        }
      }
    }
  }

  void showDocumentWithZoom(context, int index) async {
    String url;
    if (PreferenceUtils.getBoolValue("isDoctor")) {
      url = doctorDocumentsModel?.data?[index].document_url ?? "";
    } else {
      url = documentsModel?.data?[index].document_url ?? "";
    }

    if (url.isEmpty) {
      DisplaySnackBar.displaySnackBar("No document URL found", 3, ColorConst.redColor);
      return;
    }

    // تعريف PhotoViewController للتحكم في الزووم
    PhotoViewController photoViewController = PhotoViewController();

    // عرض الصورة باستخدام PhotoView داخل Container مع حجم محدد
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Document Preview"),
          content: Container(
            width: 800, // يعين العرض ليكون 100% من عرض الشاشة
            height: 400, // يمكنك تعديل هذا بناءً على متطلباتك
            child: PhotoView(
              controller: photoViewController, // تعيين PhotoViewController
              imageProvider: NetworkImage(url), // تحميل الصورة من الرابط
              minScale: PhotoViewComputedScale.contained, // الحد الأدنى للزووم
              maxScale: PhotoViewComputedScale.covered, // الحد الأقصى للزووم
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // إغلاق المعاينة عند الضغط على "إغلاق"
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(context, double height, double width, int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext contextOfDialog) {
        return Center(
          child: Container(
            height: height / 2.6,
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
                  "Are you sure want to delete this\n document?",
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
                        if (PreferenceUtils.getBoolValue("isDoctor")) {
                          deleteDoctorDocument(doctorDocumentsModel?.data?[index].id ?? 0);
                        } else {
                          deleteDocData(documentsModel?.data?[index].id ?? 0);
                        }
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
  }

  void deleteDocData(int id) {
    CommonLoader.showLoader();
    StringUtils.client.deleteDocument(PreferenceUtils.getStringValue("token"), id)
      ..then((value) {
        Get.back();
        DisplaySnackBar.displaySnackBar("Document deleted");
        getDocuments();
      })
      ..onError((DioError error, stackTrace) {
        Get.back();
        CheckSocketException.checkSocketException(error);
        return DocumentDeleteModel();
      });
  }

  void getDocuments() {
    gotData.value = false;
    StringUtils.client.getDocuments(PreferenceUtils.getStringValue("token")).then((value) {
      documentsModel = value;
      gotData.value = true;
      isCurrentDownloading = List.generate(value.data?.length ?? 1, (index) {
        return false.obs;
      });
    }).onError((DioError error, stackTrace) {
      documentsModel = DocumentsModel();
      gotData.value = true;
      CheckSocketException.checkSocketException(error);
    });
  }

  /// Doctor administration

  void getDoctorDocuments() {
    gotData.value = false;
    StringUtils.client.doctorDocuments(PreferenceUtils.getStringValue("token"))
      ..then((value) {
        doctorDocumentsModel = value;
        isCurrentDownloading = List.generate(value.data?.length ?? 1, (index) {
          return false.obs;
        });
        // print("----${value.data?[0].document_url}");
        gotData.value = true;
      })
      ..onError((error, stackTrace) {
        doctorDocumentsModel = DoctorDocumentsModel();
        gotData.value = true;
        return DoctorDocumentsModel();
      });
  }

  void deleteDoctorDocument(int id) {
    CommonLoader.showLoader();
    StringUtils.client.deleteDoctorDocuments(PreferenceUtils.getStringValue("token"), id.toString())
      ..then((value) {
        Get.back();
        DisplaySnackBar.displaySnackBar("Document deleted");
        getDoctorDocuments();
      })
      ..onError((DioError error, stackTrace) {
        Get.back();
        CheckSocketException.checkSocketException(error);
        return DoctorDocumentsCRUDModel();
      });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    receivePort.close();
    IsolateNameServer.removePortNameMapping('downloading');
  }
}
