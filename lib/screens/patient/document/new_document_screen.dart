import 'dart:io';
import 'package:cross_file/src/types/interface.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infyhms_flutter/component/common_app_bar.dart';
import 'package:infyhms_flutter/component/common_button.dart';
import 'package:infyhms_flutter/component/common_dropdown_button.dart';
import 'package:infyhms_flutter/component/common_required_text.dart';
import 'package:infyhms_flutter/component/common_text_field.dart';
import 'package:infyhms_flutter/constant/color_const.dart';
import 'package:infyhms_flutter/constant/text_style_const.dart';
import 'package:infyhms_flutter/controller/patient/document_controller/new_document_controller.dart';
import 'package:infyhms_flutter/utils/preference_utils.dart';
import 'package:infyhms_flutter/utils/string_utils.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:smart_searchable_dropdown/smart_searchable_dropdown.dart';
import 'package:shimmer/shimmer.dart';
import '../../../New Functions/Normal_Search.dart';
import '../../../New Functions/Search_With_API.dart';
import '../../../model/patient/documents_model/document-parents/get-document-parents.dart';
import '../../../model/patient/lab_tests/gat_lab_tests.dart';

class NewDocumentScreen extends StatefulWidget {
  NewDocumentScreen({Key? key}) : super(key: key);

  @override
  State<NewDocumentScreen> createState() => _NewDocumentScreenState();
}

class _NewDocumentScreenState extends State<NewDocumentScreen> {
  final NewDocumentController newDocumentController =
      Get.put(NewDocumentController());
  final LabTestsDataModel labTestsDataModel = Get.put(LabTestsDataModel());
  final SearchDropItemsLocal searchableDropdownLocal = SearchDropItemsLocal();
  final GetDocumentParentsModel getDocumentParentsModel =
      GetDocumentParentsModel();
  final SearchDropItemsLocalState _searchDropItemsLocalState =
      SearchDropItemsLocalState();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonAppBar(
            title: StringUtils.newDocument,
            leadOnTap: () {
              Get.back();
            },
            leadIcon: const Icon(
              Icons.arrow_back_rounded,
              color: ColorConst.blackColor,
            ),
          ),
          body: Obx(() {
            if (newDocumentController.gotData.value == false) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Stack(
                  // استخدام Stack لعرض مؤشر الصفحات فوق PageView
                  alignment:
                      Alignment.bottomCenter, // محاذاة مؤشر الصفحات إلى الأسفل
                  children: [
                    PageView.builder(
                      itemCount: newDocumentController.files.length == 0
                          ? 1
                          : newDocumentController.files
                              .length, // عدد الصفحات = عدد الصور أو 1 إذا لم توجد صور
                      controller: newDocumentController
                          .pageController, // إضافة PageController
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          // وضع المحتوى داخل SingleChildScrollView لكل صفحة
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonRequiredText(
                                  width: width, text: StringUtils.title),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                controller:
                                    newDocumentController.titleControllers[
                                        index], // استخدام قائمة controllers
                              ),
                              SizedBox(height: height * 0.02),
                              CommonRequiredText(
                                  width: width, text: StringUtils.documentType),
                              SizedBox(height: height * 0.01),

                              /// Document Type
                              PreferenceUtils.getBoolValue("isDoctor")
                                  ? Obx(() => CommonDropDown(
                                        value: newDocumentController
                                                    .selectedDocType.value ==
                                                ''
                                            ? null
                                            : newDocumentController
                                                .selectedDocType.value,
                                        onChange: (value) async {
                                          newDocumentController.docId.value =
                                              value!;
                                          newDocumentController
                                                  .gotDocumentSubTypeData
                                                  .value =
                                              false; // أول حاجة خلي الـ loading true
                                          await newDocumentController
                                              .getDocumentSubType(); // انتظر لحد ما تخلص
                                          if (newDocumentController.docId.value ==
                                              '1') {
                                            newDocumentController.getLabTests();
                                          }
                                          print(newDocumentController.docId);
                                        },
                                        hintText: "Select Document Type",
                                        onCansle: () {
                                            newDocumentController.selectedDocType.value = '';
                                          print('sfkjkdafjsafjkahdkasmjjhdbblksahmga,jjjkhf,fh,jfhz,jd,jBjh');
                                        },
                                        dropdownItems: newDocumentController
                                            .doctorDocumentsTypeModel!.data!
                                            .map((items) {
                                          return DropdownMenuItem(
                                            value: items.id.toString(),
                                            child: Text(items.name ?? ""),
                                          );
                                        }).toList(),
                                      ))
                                  : Obx(
                                      () => CommonDropDown(
                                        value: newDocumentController
                                                    .selectedDocType.value ==
                                                ''
                                            ? null
                                            : newDocumentController
                                                .selectedDocType.value,
                                        onChange: (value) async {
                                          newDocumentController.docId!.value =
                                              value!;
                                          newDocumentController
                                                  .gotDocumentSubTypeData
                                                  .value =
                                              false; // أول حاجة خلي الـ loading true
                                          await newDocumentController
                                              .getDocumentSubType(); // انتظر لحد ما تخلص
                                          print(newDocumentController.docId);
                                        },
                                        onCansle: () {
                                          newDocumentController
                                              .selectedDocType.value = '';
                                        },
                                        hintText: "Select Document Type",
                                        dropdownItems: newDocumentController
                                            .documentsTypeModel!.data!
                                            .map((items) {
                                          return DropdownMenuItem(
                                            value: items.id.toString(),
                                            child: Text(items.name ?? ""),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                              PreferenceUtils.getBoolValue("isDoctor")
                                  ? SizedBox(height: height * 0.02)
                                  : const SizedBox(),

                              /// Document SubType
                              SizedBox(height: height * 0.02),
                              SearchDropItemsLocal(
                                controller: newDocumentController
                                    .documentSubTypeTextController,
                                model:
                                    newDocumentController.documentsSubTypeModel,
                                gotData: newDocumentController
                                    .gotDocumentSubTypeData,
                                id: newDocumentController.docSubId,
                                FunctionToCall: () async {
                                  newDocumentController
                                      .gotDocumentSpicificTypeData
                                      .value = false;
                                  await newDocumentController
                                      .getDocumentSpicificType();
                                  await newDocumentController
                                      .getDocumentParentsModel();
                                },
                                cancleDocumentField: () async {
                                  newDocumentController
                                      .documentSubTypeTextController!.text = '';
                                  newDocumentController
                                      .documentSpecificTypeTextController!
                                      .text = '';
                                  newDocumentController.docSubId!.value = '0';
                                  newDocumentController
                                      .gotDocumentSpicificTypeData
                                      .value = false;
                                  newDocumentController
                                      .getDocumentSpicificType();
                                },
                              ),

                              PreferenceUtils.getBoolValue("isDoctor")
                                  ? SizedBox(height: height * 0.02)
                                  : const SizedBox(),

                              /// Document SpecificType
                              SizedBox(height: height * 0.02),

                              SearchDropItemsLocal(
                                controller: newDocumentController
                                    .documentSpecificTypeTextController,
                                model: newDocumentController
                                    .documentsSpecificTypeModel,
                                gotData: newDocumentController
                                    .gotDocumentSpicificTypeData,
                                FunctionToCall: () async {
                                  await newDocumentController
                                      .getDocumentParents();

                                  final data = newDocumentController
                                      .getDocumentParentsModel.value?.Data;
                                  newDocumentController.docId!.value =
                                      '${data?['document_type_id'] ?? '0'}';
                                  newDocumentController.docSubId!.value =
                                      '${data?['document_subtype_id'] ?? '0'}';

                                  print('success my brotheeee');
                                  print(newDocumentController.docId.value);
                                  print(newDocumentController.docSubId!.value);

                                  newDocumentController
                                      .updateDropdownControllers();
                                   await newDocumentController.getDocumentSubType(id: '0'.obs);
                                },
                                id: newDocumentController.docSpecificId,
                                cancleDocumentField: () async {
                                  newDocumentController
                                      .documentSpecificTypeTextController!
                                      .text = '';
                                  newDocumentController.docSpecificId!.value =
                                      '0';
                                  newDocumentController
                                      .documentSubTypeTextController!.text = '';
                                  newDocumentController.selectedDocSubType.value =
                                      '';
                                  newDocumentController.selectedDocType.value =
                                  '';
                                  // إعادة تعيين القيم الأخرى أيضاً
                                  newDocumentController.docId.value = '0';
                                  newDocumentController.docSubId!.value = '0';
                                },
                              ),

                              ///lab and cat tests
                              SizedBox(height: height * 0.02),
                              Obx(
                                () {
                                  if (newDocumentController.gotlabTestsData ==
                                      false) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return newDocumentController.docId.value ==
                                            '1'
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.0),
                                                child: Text(
                                                  "اختر التحاليل المطلوبة",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.blueAccent),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: MultiSelectDialogField<
                                                      LabTestsDataModel>(
                                                    items: newDocumentController
                                                        .labtestsModel!.data!
                                                        .map((test) =>
                                                            MultiSelectItem<
                                                                    LabTestsDataModel>(
                                                                test,
                                                                test.test_name ??
                                                                    'غير معروف'))
                                                        .toList(),
                                                    title: const Text(
                                                        "اختر التحاليل"),
                                                    searchable: true,
                                                    searchHint:
                                                        "ابحث عن تحليل...",
                                                    selectedColor: Colors.blue,
                                                    dialogHeight: 500,
                                                    buttonIcon: const Icon(
                                                        Icons
                                                            .medical_services_outlined,
                                                        color: Colors.blue),
                                                    buttonText: const Text(
                                                      "اختر التحاليل",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    cancelText:
                                                        const Text("إلغاء"),
                                                    confirmText:
                                                        const Text("تم"),
                                                    initialValue:
                                                        newDocumentController
                                                            .selectedLabTests,
                                                    onConfirm:
                                                        (List<LabTestsDataModel>
                                                            selectedValues) {
                                                      print(
                                                          "التحاليل المختارة:");
                                                      newDocumentController
                                                              .selectedLabTests
                                                              .value =
                                                          selectedValues;
                                                      for (var test
                                                          in selectedValues) {
                                                        print(
                                                            "${test.id} - ${test.test_name}");
                                                        // ممكن تهيئ خانة فاضية لكل تحليل
                                                        newDocumentController
                                                                .labTestInputs[
                                                            test.id!] = '';
                                                      }
                                                      newDocumentController
                                                          .gotlabTestsLoadnigData
                                                          .value = true;
                                                    },
                                                    chipDisplay:
                                                        MultiSelectChipDisplay(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white),
                                                      chipColor: Colors.blue,
                                                      onTap: (item) {
                                                        // ممكن تضيف remove لو عندك متغير داخلي
                                                        newDocumentController
                                                            .selectedLabTests
                                                            .remove(item);
                                                        newDocumentController
                                                            .labTestInputs
                                                            .remove(item.id);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container();
                                  }
                                },
                              ),

                              Obx(() {
                                return Column(
                                  children: newDocumentController
                                      .selectedLabTests
                                      .map((test) {
                                    final labels = test.json_labels ??
                                        []; // تحقق آمن من null

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // اسم التحليل
                                          Text(
                                            test.test_name ?? 'غير معروف',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 6),
                                          // حقول الإدخال بناءً على json_labels
                                          Column(
                                            children: labels.map((label) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: TextFormField(
                                                  onChanged: (value) {
                                                    // تخزين القيمة باستخدام مفتاح مميز: testId + label
                                                    // newDocumentController.labTestInputs['${test.id}_$label'] = value;
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: label,
                                                    border:
                                                        const OutlineInputBorder(),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 10.0,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),

                              /// Patient
                              SizedBox(height: height * 0.02),
                              PreferenceUtils.getBoolValue("isDoctor")
                                  ? CommonRequiredText(
                                      width: width, text: "Patient")
                                  : const SizedBox(),

                              SizedBox(height: height * 0.02),

                              /// Patient
                              PreferenceUtils.getBoolValue("isDoctor")
                                  ? SearchableDropdown(
                                      'patients',
                                      newDocumentController
                                          .doctorPatientsDocumentsModel,
                                      'ابحث عن مريض',
                                    )
                                  : const SizedBox(),
                              SizedBox(height: height * 0.02),
                              CommonRequiredText(
                                  width: width, text: StringUtils.attachment),
                              SizedBox(height: height * 0.02),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      newDocumentController.multiple = false;
                                      newDocumentController.pickImage(
                                          index: index);
                                    },
                                    child: DottedBorder(
                                      color: Colors.grey,
                                      radius: const Radius.circular(10),
                                      strokeWidth: 2,
                                      borderType: BorderType.RRect,
                                      dashPattern: const [4],
                                      child: Obx(() {
                                        return Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                              image: !newDocumentController
                                                      .showFiles[index].value
                                                  ? const DecorationImage(
                                                      image: AssetImage(
                                                          "assets/icon/take_photo.png"),
                                                      scale: 4)
                                                  : DecorationImage(
                                                      image: FileImage(File(
                                                          newDocumentController
                                                              .files[index]
                                                              .path)),
                                                    ),
                                            ));
                                      }),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: IconButton(
                                      onPressed: () {
                                        newDocumentController.multiple = false;
                                        newDocumentController.pickImage(
                                            index: index);
                                      },
                                      icon: Icon(
                                        Icons.camera_alt_sharp,
                                        size: 100,
                                        color: ColorConst.blueColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.02),
                              SizedBox(height: height * 0.02),
                              CommonRequiredText(
                                  width: width, text: StringUtils.details),
                              SizedBox(height: height * 0.01),
                              Container(
                                height: 150,
                                width: double.infinity,
                                child: CommonTextField(
                                  // استخدام CommonTextField واحد فقط
                                  maxLine: 5,
                                  validator: (value) {
                                    return null;
                                  },
                                  onchange: (v) {
                                    newDocumentController
                                        .extractedTexts.value[index] = v;
                                  },
                                  controller: newDocumentController
                                          .documentDetailsControllers[
                                      index], // استخدام قائمة controllers
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                              CommonRequiredText(
                                  width: width, text: StringUtils.conclusion),
                              SizedBox(height: height * 0.01),
                              Container(
                                height: 100,
                                width: double.infinity,
                                child: CommonTextField(
                                  // استخدام CommonTextField واحد فقط
                                  maxLine: 3,
                                  validator: (value) {
                                    return null;
                                  },
                                  onchange: (v) {
                                    newDocumentController
                                        .extractedConclusion.value[index] = v;
                                  },
                                  controller: newDocumentController
                                          .conclusionControllers[
                                      index], // استخدام قائمة controllers
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                              CommonRequiredText(
                                  width: width, text: StringUtils.reportDate),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                maxLine: 3,
                                validator: (value) {
                                  return null;
                                },
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2024),
                                    lastDate: DateTime(2028),
                                  );

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(pickedDate);
                                    newDocumentController
                                            .reportDateControllers[index].text =
                                        formattedDate; // استخدام قائمة controllers
                                  }
                                },
                                onchange: (v) {
                                  newDocumentController
                                      .reportDateControllers[index]
                                      .text = v; // استخدام قائمة controllers
                                },
                                suffixIcon: Icon(Icons.date_range),
                                keyBoardType: TextInputType.none,
                                controller:
                                    newDocumentController.reportDateControllers[
                                        index], // استخدام قائمة controllers
                              ),
                              SizedBox(height: height * 0.01),
                              CommonRequiredText(
                                width: width,
                                text: StringUtils.labName,
                                isRequried: false,
                              ),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {
                                  newDocumentController
                                      .labNameControllers[index]
                                      .text = v; // استخدام قائمة controllers
                                },
                                controller:
                                    newDocumentController.labNameControllers[
                                        index], // استخدام قائمة controllers
                              ),
                              SizedBox(height: height * 0.02),
                              CommonRequiredText(
                                width: width,
                                text: StringUtils.note,
                                isRequried: false,
                              ),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                hintText: StringUtils.typeHere,
                                maxLine: 2,
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {
                                  newDocumentController.notesControllers[index]
                                      .text = v; // استخدام قائمة controllers
                                },
                                controller:
                                    newDocumentController.notesControllers[
                                        index], // استخدام قائمة controllers
                              ),
                              SizedBox(height: height * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonButton(
                                    textStyleConst:
                                        TextStyleConst.mediumTextStyle(
                                            ColorConst.whiteColor,
                                            width * 0.05),
                                    onTap: () {
                                      newDocumentController.createDocuments();
                                    },
                                    color: ColorConst.blueColor,
                                    text: StringUtils.save,
                                    width: width / 2.3,
                                    height: 50,
                                  ),
                                  CommonButton(
                                    textStyleConst:
                                        TextStyleConst.mediumTextStyle(
                                            ColorConst.hintGreyColor,
                                            width * 0.05),
                                    onTap: () {
                                      Get.back();
                                    },
                                    color: ColorConst.borderGreyColor,
                                    text: StringUtils.cancel,
                                    width: width / 2.3,
                                    height: 50,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20)
                            ],
                          ),
                        );
                      },
                    ),
                    Positioned(
                      // مؤشر الصفحات
                      bottom: 10.0,
                      child: Obx(() => Text(
                            "${newDocumentController.currentPageIndex.value + 1}/${newDocumentController.files.length == 0 ? 1 : newDocumentController.files.length}", // عرض الصفحة الحالية / العدد الكلي
                            style: TextStyle(color: Colors.grey),
                          )),
                    ),
                  ],
                ),
              );
            }
          }),
          // Obx(() {
          //   if (newDocumentController.gotData.value == false) {
          //     return const Center(child: CircularProgressIndicator());
          //   } else {
          //     return Padding(
          //           padding:
          //               const EdgeInsets.only(left: 15, right: 15, top: 15),
          //           child: SingleChildScrollView(
          //             physics: const BouncingScrollPhysics(),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 CommonRequiredText(
          //                     width: width, text: StringUtils.title),
          //                 SizedBox(height: height * 0.01),
          //                 CommonTextField(
          //                   validator: (value) {
          //                     return null;
          //                   },
          //                   controller: newDocumentController.titleController,
          //                 ),
          //                 SizedBox(height: height * 0.02),
          //                 CommonRequiredText(
          //                     width: width, text: StringUtils.documentType),
          //                 SizedBox(height: height * 0.01),
          //
          //                 /// Document Type
          //                 PreferenceUtils.getBoolValue("isDoctor")
          //                     ? CommonDropDown(
          //                         onChange: (value) {
          //                           newDocumentController.docId = value;
          //                         },
          //                         hintText: "Select Document Type",
          //                         dropdownItems: newDocumentController
          //                             .doctorDocumentsTypeModel!.data!
          //                             .map((items) {
          //                           return DropdownMenuItem(
          //                             value: items.id.toString(),
          //                             child: Text(items.name ?? ""),
          //                           );
          //                         }).toList(),
          //                       )
          //                     : CommonDropDown(
          //                         onChange: (value) {
          //                           newDocumentController.docId = value;
          //                         },
          //                         hintText: "Select Document Type",
          //                         dropdownItems: newDocumentController
          //                             .documentsTypeModel!.data!
          //                             .map((items) {
          //                           return DropdownMenuItem(
          //                             value: items.id.toString(),
          //                             child: Text(items.name ?? ""),
          //                           );
          //                         }).toList(),
          //                       ),
          //                 PreferenceUtils.getBoolValue("isDoctor")
          //                     ? SizedBox(height: height * 0.02)
          //                     : const SizedBox(),
          //                 PreferenceUtils.getBoolValue("isDoctor")
          //                     ? CommonRequiredText(
          //                         width: width, text: "Patient")
          //                     : const SizedBox(),
          //
          //                 SizedBox(height: height * 0.02),
          //
          //                 /// Patient
          //                 PreferenceUtils.getBoolValue("isDoctor")
          //                     ? SearchableDropdown()
          //                     : const SizedBox(),
          //                 SizedBox(height: height * 0.02),
          //                 CommonRequiredText(
          //                     width: width, text: StringUtils.attachment),
          //                 SizedBox(height: height * 0.02),
          //                 Row(
          //                   children: [
          //                     InkWell(
          //                       onTap: () async {
          //                         newDocumentController
          //                             .ReportDateController.text = '';
          //                         newDocumentController
          //                             .DocumentDetailsController.text = '';
          //                         newDocumentController
          //                             .ConclusionController.text = '';
          //                         newDocumentController.dateEntitiees = [];
          //                         newDocumentController.phoneEntitiees = [];
          //                         newDocumentController.multiple = true;
          //                         if (newDocumentController.showFile.value) {
          //                         } else {
          //                           newDocumentController.pickImage();
          //                         }
          //                       },
          //                       child: DottedBorder(
          //                         color: Colors.grey,
          //                         radius: const Radius.circular(10),
          //                         strokeWidth: 2,
          //                         borderType: BorderType.RRect,
          //                         dashPattern: const [4],
          //                         child: Obx(() {
          //                           return Container(
          //                               height: 100,
          //                               width: 100,
          //                               decoration: BoxDecoration(
          //                                 borderRadius:
          //                                     BorderRadius.circular(10),
          //                                 color: Colors.white,
          //                                 image: !newDocumentController
          //                                         .showFile.value
          //                                     ? const DecorationImage(
          //                                         image: AssetImage(
          //                                             "assets/icon/take_photo.png"),
          //                                         scale: 4)
          //                                     : DecorationImage(
          //                                         image: FileImage(File(
          //                                             newDocumentController.file
          //                                                     .value?.path ??
          //                                                 "")),
          //                                       ),
          //                               ));
          //                         }),
          //                       ),
          //                     ),
          //                     Spacer(),
          //                     Container(
          //                       child: IconButton(
          //                         onPressed: () {
          //                           newDocumentController
          //                               .ReportDateController.text = '';
          //                           newDocumentController
          //                               .DocumentDetailsController.text = '';
          //                           newDocumentController
          //                               .ConclusionController.text = '';
          //                           newDocumentController.dateEntitiees = [];
          //                           newDocumentController.phoneEntitiees = [];
          //                           newDocumentController.multiple = false;
          //                           newDocumentController.pickImage();
          //                         },
          //                         icon: Icon(
          //                           Icons.camera_alt_sharp,
          //                           size: 100,
          //                           color: ColorConst.blueColor,
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 SizedBox(height: height * 0.02),
          //                 SizedBox(height: height * 0.02),
          //                 CommonRequiredText(
          //                     width: width, text: StringUtils.details),
          //                 SizedBox(height: height * 0.01),
          //                 Container(
          //                   height: 150,
          //                   width: double.infinity,
          //                   child: ListView.builder(
          //                     scrollDirection: Axis.horizontal,
          //                     itemCount: newDocumentController.extractedTexts.value.length,
          //                     itemBuilder: (context, index) {
          //                       return
          //                       SizedBox(
          //                         width: 350,
          //                         child: CommonTextField(
          //                           maxLine: 5,
          //                           validator: (value) {
          //                             return null;
          //                           },
          //                           onchange: (v) {
          //                             newDocumentController.extractedTexts.value[index] = v;
          //                           },
          //                           controller: TextEditingController(text:newDocumentController.extractedTexts.value[index]),
          //                         ),
          //                       );
          //                   },),
          //                 ),
          //                 SizedBox(height: height * 0.02),
          //                 CommonRequiredText(
          //                     width: width, text: StringUtils.conclusion),
          //                 SizedBox(height: height * 0.01),
          //                 Container(
          //                   height: 100,
          //                   width: double.infinity,
          //                   child: ListView.builder(
          //                     scrollDirection: Axis.horizontal,
          //                     itemCount: newDocumentController.extractedConclusion.value.length,
          //                     itemBuilder: (context, index) {
          //                       return
          //                         SizedBox(
          //                           width: 350,
          //                           child: CommonTextField(
          //                             maxLine: 3,
          //                             validator: (value) {
          //                               return null;
          //                             },
          //                             onchange: (v) {
          //                               newDocumentController.extractedConclusion.value[index] =
          //                                   v;
          //                             },
          //                             controller:TextEditingController(text: newDocumentController.extractedConclusion.value[index]),
          //                           ),
          //                         );
          //                     },),
          //                 ),
          //                 SizedBox(height: height * 0.02),
          //                 CommonRequiredText(
          //                     width: width, text: StringUtils.reportDate),
          //                 SizedBox(height: height * 0.01),
          //                 CommonTextField(
          //                   maxLine: 3,
          //                   validator: (value) {
          //                     return null;
          //                   },
          //                   onTap: () async {
          //                     DateTime? pickedDate = await showDatePicker(
          //                       context: context,
          //                       firstDate: DateTime(2024),
          //                       lastDate: DateTime(2028),
          //                     );
          //
          //                     if (pickedDate != null) {
          //                       String formattedDate =
          //                           DateFormat('dd/MM/yyyy').format(pickedDate);
          //                       newDocumentController
          //                           .ReportDateController.text = formattedDate;
          //                     }
          //                   },
          //                   onchange: (v) {
          //                     newDocumentController.ReportDateController.text =
          //                         v;
          //                   },
          //                   suffixIcon: Icon(Icons.date_range),
          //                   keyBoardType: TextInputType.none,
          //                   controller:
          //                       newDocumentController.ReportDateController,
          //                 ),
          //                 SizedBox(height: height * 0.01),
          //                 CommonRequiredText(
          //                   width: width,
          //                   text: StringUtils.labName,
          //                   isRequried: false,
          //                 ),
          //                 CommonTextField(
          //                   validator: (value) {
          //                     return null;
          //                   },
          //                   onchange: (v) {
          //                     newDocumentController.LabNameController.text = v;
          //                   },
          //                   controller: newDocumentController.LabNameController,
          //                 ),
          //                 SizedBox(height: height * 0.02),
          //                 CommonRequiredText(
          //                   width: width,
          //                   text: StringUtils.note,
          //                   isRequried: false,
          //                 ),
          //                 SizedBox(height: height * 0.01),
          //                 CommonTextField(
          //                   hintText: StringUtils.typeHere,
          //                   maxLine: 2,
          //                   validator: (value) {
          //                     return null;
          //                   },
          //                   onchange: (v) {
          //                     newDocumentController.notesController.text = v;
          //                   },
          //                   controller: newDocumentController.notesController,
          //                 ),
          //                 SizedBox(height: height * 0.02),
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     CommonButton(
          //                       textStyleConst: TextStyleConst.mediumTextStyle(
          //                           ColorConst.whiteColor, width * 0.05),
          //                       onTap: () {
          //                         newDocumentController.createDocuments();
          //                       },
          //                       color: ColorConst.blueColor,
          //                       text: StringUtils.save,
          //                       width: width / 2.3,
          //                       height: 50,
          //                     ),
          //                     CommonButton(
          //                       textStyleConst: TextStyleConst.mediumTextStyle(
          //                           ColorConst.hintGreyColor, width * 0.05),
          //                       onTap: () {
          //                         Get.back();
          //                       },
          //                       color: ColorConst.borderGreyColor,
          //                       text: StringUtils.cancel,
          //                       width: width / 2.3,
          //                       height: 50,
          //                     ),
          //                   ],
          //                 ),
          //                 const SizedBox(height: 20)
          //               ],
          //             ),
          //           ),
          //         );
          //   }
          // }),
        ),
      ),
    );
  }
}
