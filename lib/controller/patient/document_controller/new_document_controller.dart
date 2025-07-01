import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infyhms_flutter/model/doctor/doctor_document_model/doctor_documents_model.dart';
import 'package:infyhms_flutter/model/patient/lab_tests/gat_lab_tests.dart';
import '../../../component/common_loader.dart';
import '../../../component/common_snackbar.dart';
import '../../../component/common_socket_exception.dart';
import '../../../model/doctor/doctor_document_model/doctor_documents_crud_model.dart';
import '../../../model/doctor/doctor_document_model/doctor_documents_type_model.dart';
import '../../../model/doctor/doctor_document_model/doctor_patients_model.dart';
import '../../../model/patient/auth_model/login_model.dart';
import '../../../model/patient/documents_model/document-parents/get-document-parents.dart';
import '../../../model/patient/documents_model/document_specific-type/document_specifc-type.dart';
import '../../../model/patient/documents_model/document_store_model/document_store.dart';
import '../../../model/patient/documents_model/document_sub-type-model/documents_sub-type.dart';
import '../../../model/patient/documents_model/documents_model/documents.dart';
import '../../../model/patient/documents_model/documents_type_model/documents_type.dart';
import '../../../utils/preference_utils.dart';
import '../../../utils/string_utils.dart';
import 'document_list_controller.dart';

class NewDocumentController extends GetxController {
  // قوائم من TextEditingController لكل حقل، لكل صفحة
  RxList<TextEditingController> titleControllers =
      <TextEditingController>[].obs;
  RxList<TextEditingController> notesControllers =
      <TextEditingController>[].obs;
  RxList<TextEditingController> documentDetailsControllers =
      <TextEditingController>[].obs;
  RxList<TextEditingController> reportDateControllers =
      <TextEditingController>[].obs;
  RxList<TextEditingController> conclusionControllers =
      <TextEditingController>[].obs;
  RxList<TextEditingController> labNameControllers =
      <TextEditingController>[].obs;

  final DocumentController documentController = Get.put(DocumentController());
  DocumentsTypeModel? documentsTypeModel;
  Rx<DocumentsSubTypeModel?> documentsSubTypeModel =
      Rx<DocumentsSubTypeModel?>(null);
  Rx<DocumentsSpecificTypeModel?> documentsSpecificTypeModel =
      Rx<DocumentsSpecificTypeModel?>(null);
  var getDocumentParentsModel = Rx<GetDocumentParentsModel?>(null);
  DocumentsModel? documentsModel;
  DoctorDocumentsModel? doctorDocumentsModel;
  DoctorDocumentsTypeModel? doctorDocumentsTypeModel;
  DoctorPatientsDocumentsModel? doctorPatientsDocumentsModel;
  LabtestsModel? labtestsModel;
  LabTestsDataModel? labTestsDataModel;
  var text = ''.obs;
  final entityExtractor =
      EntityExtractor(language: EntityExtractorLanguage.english);
  RxString docId = '0'.obs;
  RxString? docSubId = '0'.obs;
  RxString docSpecificId = '0'.obs;
  ImagePicker imagePicker = ImagePicker();
  RxBool showFile = false.obs; // لن يتم استخدامها بشكل مباشر بعد الآن
  RxBool gotData = false.obs;
  RxBool gotDocumentSubTypeData = false.obs;
  RxBool gotDocumentSpicificTypeData = false.obs;
  RxBool gotDocumentParentsData = false.obs;
  RxBool gotlabTestsData = false.obs;
  RxBool gotlabTestsLoadnigData = false.obs;
  RxBool Scaning = false.obs;
  var image = <String>[
    'assets/icon/take_photo.png',
  ].obs;
  RxList<LabTestsDataModel> selectedLabTests = <LabTestsDataModel>[].obs;
  RxMap<int, String> labTestInputs = <int, String>{}.obs;
  var extractedTexts = <String>[].obs; // قائمة نصوص لكل صفحة
  var extractedConclusion = <String>[].obs; // قائمة خلاصات لكل صفحة
  String? patientId;
  UserData? userData;
  RxList<File> files = <File>[].obs;
  RxList<RxBool> showFiles = <RxBool>[].obs;
  bool multiple = false;

  PageController pageController =
      PageController(initialPage: 0); // PageController للتحكم في PageView
  RxInt currentPageIndex = 0.obs; // لتتبع الصفحة الحالية

  @override
  void onInit() {
    super.onInit();
    if (PreferenceUtils.getBoolValue("isDoctor")) {
      getDoctorDocumentsType();
      getDocumentSubType(id: docId);
      getDocumentSpicificType();
      getLabTests();
    } else {
      getDocumentTypes();
      getDocumentSubType(id: docId);
      getDocumentSpicificType();
      getLabTests();
    }
    _initializeControllers(); // تهيئة controllers في البداية
    pageController.addListener(() {
      // الاستماع لتغييرات الصفحة
      currentPageIndex.value = pageController.page!.toInt();
    });
  }

  void _initializeControllers() {
    // تهيئة قائمة من controllers لصفحة واحدة فارغة في البداية
    titleControllers.value = [TextEditingController()];
    notesControllers.value = [TextEditingController()];
    documentDetailsControllers.value = [TextEditingController()];
    reportDateControllers.value = [TextEditingController()];
    conclusionControllers.value = [TextEditingController()];
    labNameControllers.value = [TextEditingController()];
    extractedTexts.value = [""];
    extractedConclusion.value = [""];
    showFiles.value = [RxBool(false)]; // صفحة واحدة بدون صورة في البداية
    files.value = []; // لا توجد ملفات في البداية
  }

  // Future<void> pickImage({int? index}) async {
  //   try {
  //     if (multiple == true) {
  //       final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
  //       if (pickedFiles != null) {
  //         files.value = pickedFiles.map((xfile) => File(xfile.path)).toList();
  //
  //         // إعادة تهيئة القوائم لتناسب عدد الصور الجديدة
  //         _initializeControllersForNewImages(files.length);
  //
  //         showFiles.value = List.generate(files.length, (_) => RxBool(true));
  //
  //         for (int i = 0; i < pickedFiles.length; i++) {
  //           await textRecognition(pickedFiles[i], index: i).then(
  //             (value) {
  //               extractEntities(index: i);
  //             },
  //           );
  //         }
  //         if (files.isNotEmpty) {
  //           pageController.animateToPage(
  //               0, // الانتقال للصفحة الأولى بعد اختيار الصور
  //               duration: Duration(milliseconds: 300),
  //               curve: Curves.easeInOut);
  //         }
  //       }
  //     } else {
  //       final XFile? pickedFile =
  //           await ImagePicker().pickImage(source: ImageSource.gallery);
  //       if (pickedFile != null) {
  //         files.value = [File(pickedFile.path)].obs;
  //         _initializeControllersForNewImages(files.length);
  //         showFiles.value = List.generate(files.length, (_) => RxBool(true));
  //         await textRecognition(pickedFile, index: 0).then((value) {
  //           extractEntities(index: 0);
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print("Error picking images: $e");
  //   }
  // }
  Future<void> pickImage({int? index}) async {
    try {
      if (multiple == true) {
        final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
        if (pickedFiles != null && pickedFiles.isNotEmpty) {
          files.value = pickedFiles.map((xfile) => File(xfile.path)).toList();
          _initializeControllersForNewImages(files.length);
          showFiles.value = List.generate(files.length, (_) => RxBool(true));

          for (int i = 0; i < pickedFiles.length; i++) {
            await textRecognition(pickedFiles[i], index: i).then(
              (value) {
                extractEntities(index: i);
              },
            );
          }
          if (files.isNotEmpty) {
            pageController.animateToPage(0,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          }
        } else {
          return;
        }
      } else {
        final XFile? pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          files.value = [File(pickedFile.path)].obs;
          _initializeControllersForNewImages(files.length);
          showFiles.value = List.generate(files.length, (_) => RxBool(true));
          await textRecognition(pickedFile, index: 0).then((value) {
            extractEntities(index: 0);
          });
        } else {
          return;
        }
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  void _initializeControllersForNewImages(int numberOfImages) {
    // إعادة تهيئة قوائم controllers و extractedTexts و extractedConclusion لتناسب عدد الصور الجديد
    if (numberOfImages != null) {
      titleControllers.value =
          List.generate(numberOfImages, (_) => TextEditingController());
      notesControllers.value =
          List.generate(numberOfImages, (_) => TextEditingController());
      documentDetailsControllers.value =
          List.generate(numberOfImages, (_) => TextEditingController());
      reportDateControllers.value =
          List.generate(numberOfImages, (_) => TextEditingController());
      conclusionControllers.value =
          List.generate(numberOfImages, (_) => TextEditingController());
      labNameControllers.value =
          List.generate(numberOfImages, (_) => TextEditingController());
      extractedTexts.value = List.generate(numberOfImages, (_) => "");
      extractedConclusion.value = List.generate(numberOfImages, (_) => "");
    }
  }

  Future<void> textRecognition(XFile? img, {required int index}) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(img!.path);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    List<Map<String, dynamic>> blocksWithCoordinates = [];

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        blocksWithCoordinates.add({
          'text': line.text,
          'top': line.boundingBox?.top ?? 0,
          'left': line.boundingBox?.left ?? 0,
          'bottom': line.boundingBox?.bottom ?? 0,
        });
      }
    }

    const verticalTolerance = 10;
    blocksWithCoordinates.sort((a, b) {
      int verticalComparison = (a['top'] - b['top']).abs() <= verticalTolerance
          ? 0
          : a['top'].compareTo(b['top']);
      return verticalComparison != 0
          ? verticalComparison
          : a['left'].compareTo(b['left']);
    });

    String extractedText =
        blocksWithCoordinates.map((e) => e['text']).join('\n');
    extractedTexts.value[index] =
        extractedText; // تخزين النص المستخرج في القائمة

    documentDetailsControllers[index].text =
        extractedText; // تعيين النص في controller المقابل

    List<String> conclusionRelatedTexts = [];
    bool foundConclusion = false;
    for (int i = 0; i < blocksWithCoordinates.length; i++) {
      final currentText = blocksWithCoordinates[i]['text'].toLowerCase();

      if (currentText.contains("conclusion")) {
        foundConclusion = true;
        continue;
      }

      if (foundConclusion) {
        if (blocksWithCoordinates[i]['text'].trim().length < 3 ||
            blocksWithCoordinates[i]['text']
                .toLowerCase()
                .contains("best regards") ||
            (i > 0 &&
                (blocksWithCoordinates[i]['top'] -
                            blocksWithCoordinates[i - 1]['bottom'])
                        .abs() >
                    50)) {
          break;
        }
        conclusionRelatedTexts.add(blocksWithCoordinates[i]['text']);
      }
    }
    if (conclusionRelatedTexts.isNotEmpty) {
      extractedConclusion.value[index] = conclusionRelatedTexts
          .join('\n')
          .replaceAll(RegExp(r'\n\s*\n'), '\n')
          .trim(); // تخزين الخلاصة المستخرجة في القائمة
      conclusionControllers[index].text = extractedConclusion
          .value[index]; // تعيين الخلاصة في controller المقابل
    }
    textRecognizer.close();
  }

  List<String> dateEntitiees = [];
  List<String> phoneEntitiees = [];

  final TextEditingController? documentSubTypeTextController =
      TextEditingController();
  final TextEditingController? documentSpecificTypeTextController =
      TextEditingController();

  Future<void> extractEntities({required int index}) async {
    final Map<String, List<String>> entityMap = {};

    String currentImageText =
        extractedTexts.value[index]; // الحصول على النص الخاص بالصفحة/الصورة

    final List<EntityAnnotation> annotations =
        await entityExtractor.annotateText(currentImageText);

    for (final annotation in annotations) {
      if (annotation.entities.first.type == EntityType.phone) {
        phoneEntitiees.add(annotation.text);
      }
      if (annotation.entities.first.type == EntityType.dateTime) {
        dateEntitiees.add(annotation.text);
        for (int i = 0; i < dateEntitiees.length; i++) {
          reportDateControllers[index].text +=
              "${dateEntitiees[i]}"; // تعيين تاريخ التقرير في controller المقابل
        }
      }
      for (final entity in annotation.entities) {
        final String entityType = entity.type.toString();

        if (entityMap.containsKey(entityType)) {
          entityMap[entityType]!.add(entity.rawValue);
        } else {
          entityMap[entityType] = [entity.rawValue];
        }
      }
    }
    entityExtractor.close();
  }

  Future getDocumentTypes() async {
    StringUtils.client.getDocumentsType(PreferenceUtils.getStringValue("token"))
      ..then((value) {
        documentsTypeModel = value;
        gotData.value = true;
        // getDocumentSpecificType();
        getPatients();
        update();
      })
      ..onError((DioError error, stackTrace) {
        gotData.value = true;
        CheckSocketException.checkSocketException(error);
        return DocumentsTypeModel();
      });
  }

  Future getLabTests() async {
    StringUtils.client.getLabTests(PreferenceUtils.getStringValue("token"))
      ..then((value) {
        labtestsModel = value;
        gotlabTestsData.value = true;
        getPatients();
        print(labtestsModel!.data![0].json_labels);
        update();
      })
      ..onError((DioError error, stackTrace) {
        gotlabTestsData.value = true;
        CheckSocketException.checkSocketException(error);
        return LabtestsModel();
      });
  }

  Future<DocumentsSubTypeModel> getDocumentSubType(
      {required RxString? id}) async {
    try {
      final value = await StringUtils.client.getDocumentsSubType(
          PreferenceUtils.getStringValue("token"), id!.value ?? '0');
      documentsSubTypeModel.value = value;
      gotDocumentSubTypeData.value = true;
      update();
      return value;
    } catch (error) {
      gotDocumentSubTypeData.value = true;
      if (error is DioError) {
        CheckSocketException.checkSocketException(error);
      }
      return DocumentsSubTypeModel();
    }
  }

  Future getDocumentSpicificType() async {
    StringUtils.client.getDocumentsSpecificType(
        PreferenceUtils.getStringValue("token"), docSubId?.value ?? '0')
      ..then((value) {
        documentsSpecificTypeModel.value = value;
        gotDocumentSpicificTypeData.value = true;
        print('getDocumentSpicificType = true');
        update();
      })
      ..onError((DioError error, stackTrace) {
        gotDocumentSpicificTypeData.value = true;
        CheckSocketException.checkSocketException(error);
        return DocumentsSpecificTypeModel();
      });
  }

  Future<void> getDocumentParents() async {
    try {
      final value = await StringUtils.client.getDocumentParents(
        PreferenceUtils.getStringValue("token"),
        docSpecificId.value ?? '0',
      );
      getDocumentParentsModel.value = value;
      gotDocumentParentsData.value = true;
      print('getDocumentParents');
      update();
    } catch (error) {
      gotDocumentParentsData.value = true;
      if (error is DioError) {
        CheckSocketException.checkSocketException(error);
      }
      getDocumentParentsModel.value = GetDocumentParentsModel(); // fallback
    }
  }

  RxString selectedDocType = ''.obs;
  RxString selectedDocSubType = ''.obs;

  void updateDropdownControllers() async {
    // تحديث حقل Document Type
    final docTypeItem = doctorDocumentsTypeModel!.data!.firstWhere(
        (item) => item.id.toString() == docId.value,
        orElse: () => null!);
    if (docTypeItem != null) {
      selectedDocType.value = docTypeItem.id.toString();
    }
    gotDocumentSubTypeData.value = false;
    await getDocumentSubType(id: docId).then(
      (value) {
        print(value);
        final docSubTypeItem = documentsSubTypeModel.value?.data?.entries
            .firstWhere((entry) => entry.key == docSubId!.value,
                orElse: () => null!);
        if (docSubTypeItem != null) {
          selectedDocSubType.value = docSubTypeItem.key;
          documentSubTypeTextController!.text = docSubTypeItem.value;
        }
      },
    );
  }

  Future AddPatient() async {}

  void createDocuments() {
    for (int i = 0; i < files.length; i++) {
      // ... (باقي الكود كما هو، ولكن يمكن تعديله لاحقًا إذا كنت تريد معالجة البيانات لكل صفحة بشكل منفصل)
      if (titleControllers[i].text.trim().isEmpty) {
        // استخدام controller الصفحة الحالية
        DisplaySnackBar.displaySnackBar("Please enter title");
      } else if (docId == null) {
        DisplaySnackBar.displaySnackBar("Please select document type");
      } else if (files.isEmpty) {
        DisplaySnackBar.displaySnackBar("Please attach file");
      } else if (reportDateControllers[i].text.isEmpty) {
        // استخدام controller الصفحة الحالية
        DisplaySnackBar.displaySnackBar("Please enter ReportDate");
      } else {
        String token = PreferenceUtils.getStringValue("token");
        String title = titleControllers[i]
            .text
            .trim(); // استخدام controller الصفحة الحالية
        String documentId = docId.value ?? "";
        String notes = notesControllers[i]
            .text
            .trim(); // استخدام controller الصفحة الحالية
        String patient = patientId ?? "";
        File? fileToUpload =
            files.isNotEmpty ? files[i] : null; // استخدام ملف الصفحة الحالية
        if (fileToUpload == null && files.isNotEmpty) fileToUpload = files[i];
        if (i == files.length - 1) {CommonLoader.showLoader();}

        if (patientId == null) {
          DisplaySnackBar.displaySnackBar("Please select patient");
        } else {
          _uploadDoctorDocument(
              token, title, documentId, patient, notes, fileToUpload, i);
        }
      }
    }
  }

  void _uploadDoctorDocument(String token, String title, String documentId,
      String patient, String notes, File? fileToUpload, int index) {
    String details = documentDetailsControllers[index]
        .text
        .trim(); // استخدام controller الصفحة الحالية
    String conclusion = conclusionControllers[index]
        .text
        .trim(); // استخدام controller الصفحة الحالية

    StringUtils.client.createNewDoctorDocument(
      token,
      title,
      details,
      documentId,
      patient,
      fileToUpload!, // تم التأكد من وجود ملف في createDocuments
      notes,
    )
      ..then(
        (value) {
          Get.back();
          Get.back(result: "Call API");
          DisplaySnackBar.displaySnackBar("Document uploaded successfully");
        },
      )
      ..onError((DioError error, stackTrace) {
        _handleDocumentUploadError(error);
        return DoctorDocumentsCRUDModel();
      });
  }

  void _uploadPatientDocument(String token, String title, String documentId,
      String notes, File? fileToUpload) {
    String details = documentDetailsControllers[currentPageIndex.value]
        .text
        .trim(); // استخدام controller الصفحة الحالية
    String conclusion = conclusionControllers[currentPageIndex.value]
        .text
        .trim(); // استخدام controller الصفحة الحالية

    StringUtils.client.storeDocument(
      token,
      title,
      documentId,
      notes,
      fileToUpload!, // تم التأكد من وجود ملف في createDocuments
    )
      ..then((value) {
        handleDocumentUploadSuccess();
      })
      ..onError((DioError error, stackTrace) {
        _handleDocumentUploadError(error);
        return DocumentStoreModel();
      });
  }

  void handleDocumentUploadSuccess() {
    Get.back();
    Get.back(result: "Call API");
    DisplaySnackBar.displaySnackBar("Document uploaded successfully");
  }

  void _handleDocumentUploadError(DioError error) {
    Get.back();
    Get.back();
    print("DioError: ${error.response?.statusCode}");
    print("Response Data: ${error.response?.data}");
    print("Request URL: ${error.requestOptions.uri}");
    CheckSocketException.checkSocketException(error);
  }

  /// doctor
  Future getDoctorDocumentsType() async {
    StringUtils.client
        .doctorDocumentType(PreferenceUtils.getStringValue("token"))
      ..then((value) {
        doctorDocumentsTypeModel = value;
        getPatients();

        // getDocumentSpecificType();
      })
      ..onError((DioError error, stackTrace) {
        getPatients();
        CheckSocketException.checkSocketException(error);
        return DoctorDocumentsTypeModel();
      });
  }

  Future getPatients() async {
    StringUtils.client
        .doctorPatientsDocument(PreferenceUtils.getStringValue("token"))
      ..then((value) {
        doctorPatientsDocumentsModel = value;
        if (PreferenceUtils.getBoolValue("isDoctor") == false) {
          final targetPatient = value.data!.firstWhere(
            (element) => element.user_id == userData!.id,
            orElse: () => null!,
          );

          if (targetPatient != null) {
            // خزّن الـ id في متغير
            patientId = targetPatient.id.toString(); // RxString مثلاً
            print("Patient ID: ${patientId}");
          } else {
            print("No matching patient found.");
          }
        }

        gotData.value = true;
      })
      ..onError((DioError error, stackTrace) {
        gotData.value = true;
        return DoctorPatientsDocumentsModel();
      });
  }
}
