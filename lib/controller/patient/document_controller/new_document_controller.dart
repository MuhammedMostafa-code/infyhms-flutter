import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infyhms_flutter/model/doctor/doctor_document_model/doctor_documents_model.dart';
import 'package:infyhms_flutter/model/patient/lab_tests/gat_lab_tests.dart';
import '../../../New Functions/Search_With_API.dart';
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
  RxList<TextEditingController> documentSubTypeTextController =
      <TextEditingController>[].obs;
  RxList<TextEditingController> documentSpecificTypeTextController =
      <TextEditingController>[].obs;
  final RxList<TextEditingController> patientController =
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

  List<RxString> docId = <RxString>['0'.obs];
  List<RxString> docSubId = <RxString>['0'.obs];
  List<RxString> docSpecificId = <RxString>['0'.obs];
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
  List<RxString> patientId = <RxString>[].obs;
  UserData? userData;
  RxList<File?> files = <File?>[].obs;
  // RxList<File> files = <File>[File('/data/user/0/com.example.infyhms_flutter/cache/c442c818-2e5c-4f46-8615-f41574d2dcda/1000033342')].obs;
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
      getDocumentSubType(index: currentPageIndex.value);
      getDocumentSpicificType(index: currentPageIndex.value);
      getLabTests();
      getPatients(index: 0);
    } else {
      getDocumentTypes();
      getDocumentSubType(index: currentPageIndex.value + 1);
      getDocumentSpicificType(index: currentPageIndex.value + 1);
      getLabTests();
      getPatients(index: 0);
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
    documentSubTypeTextController.value = [TextEditingController()];
    documentSpecificTypeTextController.value = [TextEditingController()];
    patientController.value = [TextEditingController()];
    patientId = ['0'.obs];
    extractedTexts.value = [""];
    extractedConclusion.value = [""];
    showFiles.value = [RxBool(false)]; // صفحة واحدة بدون صورة في البداية
    files.value = []; // لا توجد ملفات في البداية
  }

  RxInt imageLenght = 0.obs;
  Future<void> pickImage({int? index}) async {
    try {
      if (multiple == true) {
        final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
        if (pickedFiles != null && pickedFiles.isNotEmpty) {
          files.value = pickedFiles.map((xfile) => File(xfile.path)).toList();
          imageLenght.value = files.length;
          initializeControllersForNewImages(imageLenght.value);
          showFiles.value =
              List.generate(imageLenght.value, (_) => RxBool(true));

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
          imageLenght.value = files.length;
          initializeControllersForNewImages(imageLenght.value);
          showFiles.value =
              List.generate(imageLenght.value, (_) => RxBool(true));
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

  List<RxString> selectedDocType = <RxString>[''.obs];
  List<RxString> selectedDocSubType = <RxString>[''.obs];

  void initializeControllersForNewImages(int numberOfImages) {
    SearchableDropdownState searchableDropdownState =
        Get.put(SearchableDropdownState());
    // إعادة تهيئة قوائم controllers و extractedTexts و extractedConclusion لتناسب عدد الصور الجديد
    if (numberOfImages != null) {
      /// Controllers
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
      documentSubTypeTextController.value =
          List.generate(numberOfImages, (_) => TextEditingController());
      documentSpecificTypeTextController.value =
          List.generate(numberOfImages, (_) => TextEditingController());
      // showFiles.value = List.generate(imageLenght.value, (_) => RxBool(false));
      /// Documents IDS
      docId = List.generate(numberOfImages, (_) => '0'.obs);
      docSubId = List.generate(numberOfImages, (_) => '0'.obs);
      docSpecificId = List.generate(numberOfImages, (_) => '0'.obs);

      /// Parent IDS
      selectedDocType = List.generate(numberOfImages, (_) => ''.obs);
      selectedDocSubType = List.generate(numberOfImages, (_) => ''.obs);

      /// Date And Time
      extractedTexts.value = List.generate(numberOfImages, (_) => "");
      extractedConclusion.value = List.generate(numberOfImages, (_) => "");

      /// Patient
      patientController.value =
          List.generate(numberOfImages, (_) => TextEditingController());
      patientId = List.generate(numberOfImages, (_) => '0'.obs);
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
        // getPatients(index: patientIndex);
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
        // getPatients(index: patientIndex);
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
      {required int? index}) async {
    try {
      final value = await StringUtils.client.getDocumentsSubType(
          PreferenceUtils.getStringValue("token"), docId[index!].value ?? '0');
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

  Future getDocumentSpicificType({required int? index}) async {
    StringUtils.client.getDocumentsSpecificType(
        PreferenceUtils.getStringValue("token"), docSubId[index!].value ?? '0')
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

  Future<void> getDocumentParents({required int? index}) async {
    try {
      final value = await StringUtils.client.getDocumentParents(
        PreferenceUtils.getStringValue("token"),
        docSpecificId[index!].value ?? '0',
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

  void updateDropdownControllers({required int? index}) async {
    // تحديث حقل Document Type
    final docTypeItem = doctorDocumentsTypeModel!.data!.firstWhere(
        (item) => item.id.toString() == docId[index!].value,
        orElse: () => null!);
    print('number1 ${docTypeItem.id}');
    if (docTypeItem != null) {
      selectedDocType[index!].value = docTypeItem.id.toString();
      print('number2 ${docTypeItem.id}');
    }
    gotDocumentSubTypeData.value = false;
    await getDocumentSubType(index: index).then(
      (value) {
        print(value);
        final docSubTypeItem = documentsSubTypeModel.value?.data?.entries
            .firstWhere((entry) => entry.key == docSubId[index!].value,
                orElse: () => null!);
        if (docSubTypeItem != null) {
          selectedDocSubType[index!].value = docSubTypeItem.key;
          documentSubTypeTextController[index!].text = docSubTypeItem.value;
        }
      },
    );
  }

  Future AddPatient() async {}

  Future<void> createDocuments() async {
    final String token = PreferenceUtils.getStringValue("token");

    if (files.isEmpty) {
      DisplaySnackBar.displaySnackBar("Please add at least one file");
      return;
    }

    // ✅ 1. التأكد من أن كل المستندات مكتملة
    for (int i = 0; i < files.length; i++) {
      final String documentId = docId[i].value ?? "";
      final String patient = patientId[i].value ?? "";
      final String title = titleControllers[i].text.trim();
      final String reportDate = reportDateControllers[i].text.trim();

      if (files[i] == null) {
        DisplaySnackBar.displaySnackBar(
            "Document ${i + 1}: Please attach file");
        return;
      }

      if (documentId.isEmpty || documentId == '0') {
        DisplaySnackBar.displaySnackBar(
            "Document ${i + 1}: Please select document type");
        return;
      }

      print(patient[0]);
      if (patientId[i].value == '0') {
        DisplaySnackBar.displaySnackBar(
            "Document ${i + 1}: Please select patient");
        return;
      }

      if (title.isEmpty) {
        DisplaySnackBar.displaySnackBar(
            "Document ${i + 1}: Please enter title");
        return;
      }

      if (reportDate.isEmpty) {
        DisplaySnackBar.displaySnackBar(
            "Document ${i + 1}: Please enter report date");
        return;
      }
    }

    // ✅ 2. بدأ الرفع بعد التأكد إن كله تمام
    CommonLoader.showLoader();

    for (int i = 0; i < files.length; i++) {
      final File fileToUpload = files[i]!;
      final String documentId = docId[i].value ?? "";
      final String patient = patientId[i].value ?? "";
      final String title = titleControllers[i].text.trim();
      final String reportDate = reportDateControllers[i].text.trim();
      final String notes = notesControllers[i].text.trim();
      final String details = documentDetailsControllers[i].text.trim();
      final String conclusion = conclusionControllers[i].text.trim();

      try {
        await _uploadDoctorDocument(
          token: token,
          title: title,
          documentId: documentId,
          patient: patient,
          notes: notes,
          file: fileToUpload,
          details: details,
          conclusion: conclusion,
        );
      } catch (e) {
        CommonLoader.hideLoader();
        DisplaySnackBar.displaySnackBar("Error uploading document ${i + 1}");
        return;
      }
    }

    CommonLoader.hideLoader();
    Get.back(result: "Call API");

    ScaffoldMessenger.of(Get.key.currentContext!).showSnackBar(
      SnackBar(
        content: Text('All documents uploaded successfully'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _uploadDoctorDocument({
    required String token,
    required String title,
    required String documentId,
    required String patient,
    required String notes,
    required File file,
    required String details,
    required String conclusion,
  }) async {
    try {
      await StringUtils.client.createNewDoctorDocument(
        token,
        title,
        details,
        documentId,
        patient,
        file,
        notes,
      );
    } on DioError catch (error) {
      _handleDocumentUploadError(error);
      rethrow; // علشان يتم كشف الخطأ في Future.wait
    } catch (e) {
      print("Unexpected error: $e");
      rethrow;
    }
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
        // getPatients(index: patientIndex);

        // getDocumentSpecificType();
      })
      ..onError((DioError error, stackTrace) {
        // getPatients(index: patientIndex);
        CheckSocketException.checkSocketException(error);
        return DoctorDocumentsTypeModel();
      });
  }

  Future getPatients({required int index}) async {
    StringUtils.client
        .doctorPatientsDocument(PreferenceUtils.getStringValue("token"))
      ..then((value) {
        doctorPatientsDocumentsModel = value;
        // print(patientId[index].value);
        // if (PreferenceUtils.getBoolValue("isDoctor") == false) {
        //   final targetPatient = value.data!.firstWhere
        //     (
        //     (element) => element.user_id == userData!.id,
        //     orElse: () => null!,
        //   );
        //
        //   if (targetPatient != null) {
        //     // خزّن الـ id في متغير
        //     patientId[index].value =
        //         targetPatient.id.toString(); // RxString مثلاً
        //     print("Patient ID: ${patientId}");
        //   } else {
        //     print("No matching patient found.");
        //   }
        // }

        gotData.value = true;
      })
      ..onError((DioError error, stackTrace) {
        gotData.value = true;
        return DoctorPatientsDocumentsModel();
      });
  }
}
