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
import '../../../component/common_snackbar.dart';
import '../../../controller/patient/document_controller/document_list_controller.dart';
import '../../../model/patient/documents_model/document-parents/get-document-parents.dart';
import '../../../model/patient/lab_tests/gat_lab_tests.dart';
import 'document_data_extract_screen.dart';

class NewDocumentScreen extends StatefulWidget {
  NewDocumentScreen({Key? key}) : super(key: key);

  @override
  State<NewDocumentScreen> createState() => _NewDocumentScreenState();
}

class _NewDocumentScreenState extends State<NewDocumentScreen> {
  final NewDocumentController newDocumentController =
      Get.put(NewDocumentController());
  final DocumentController documentController = Get.put(DocumentController());
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
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.document_scanner),
                        label: Text('Document Data Extract'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DocumentDataExtractScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView.builder(
                            itemCount: newDocumentController.imageLenght == 0
                                ? 1
                                : newDocumentController.imageLenght
                                    .value, // عدد الصفحات = عدد الصور أو 1 إذا لم توجد صور
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
                                      controller: newDocumentController
                                              .titleControllers[
                                          index], // استخدام قائمة controllers
                                    ),
                                    SizedBox(height: height * 0.02),
                                    CommonRequiredText(
                                        width: width,
                                        text: StringUtils.documentType),
                                    SizedBox(height: height * 0.01),

                                    /// Document Type
                                    PreferenceUtils.getBoolValue("isDoctor")
                                        ? Obx(() => CommonDropDown(
                                              value: newDocumentController
                                                          .selectedDocType[
                                                              index]
                                                          .value ==
                                                      ''
                                                  ? null
                                                  : newDocumentController
                                                      .selectedDocType[index]
                                                      .value,
                                              onChange: (value) async {
                                                newDocumentController
                                                    .docId[index]
                                                    .value = value!;
                                                newDocumentController
                                                    .selectedDocType[index]
                                                    .value = value!;
                                                newDocumentController
                                                    .docSubId[index]
                                                    .value = '0';
                                                newDocumentController
                                                    .docSpecificId[index]
                                                    .value = '0';
                                                newDocumentController
                                                    .documentSubTypeTextController[
                                                        index]
                                                    .text = '';
                                                newDocumentController
                                                    .documentSpecificTypeTextController[
                                                        index]
                                                    .text = '';
                                                newDocumentController
                                                        .gotDocumentSubTypeData
                                                        .value =
                                                    false; // أول حاجة خلي الـ loading true
                                                await newDocumentController
                                                    .getDocumentSubType(
                                                  index: index,
                                                ); // انتظر لحد ما تخلص
                                                if (newDocumentController
                                                        .docId[index].value ==
                                                    '1') {
                                                  newDocumentController
                                                      .getLabTests();
                                                }
                                                print(newDocumentController
                                                    .docId);
                                              },
                                              hintText: "Select Document Type",
                                              onCansle: () {
                                                newDocumentController
                                                    .selectedDocType[index]
                                                    .value = '';
                                                print(
                                                    'sfkjkdafjsafjkahdkasmjjhdbblksahmga,jjjkhf,fh,jfhz,jd,jBjh');
                                              },
                                              dropdownItems:
                                                  newDocumentController
                                                      .doctorDocumentsTypeModel!
                                                      .data!
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
                                                          .selectedDocType[
                                                              index]
                                                          .value ==
                                                      ''
                                                  ? null
                                                  : newDocumentController
                                                      .selectedDocType[index]
                                                      .value,
                                              onChange: (value) async {
                                                newDocumentController
                                                    .docId[index]
                                                    .value = value!;
                                                newDocumentController
                                                    .docSubId[index]
                                                    .value = '0';
                                                newDocumentController
                                                    .docSpecificId[index]
                                                    .value = '0';
                                                newDocumentController
                                                    .documentSubTypeTextController[
                                                        index]
                                                    .text = '';
                                                newDocumentController
                                                    .documentSpecificTypeTextController[
                                                        index]
                                                    .text = '';
                                                newDocumentController
                                                        .gotDocumentSubTypeData
                                                        .value =
                                                    false; // أول حاجة خلي الـ loading true
                                                print(newDocumentController
                                                    .docId);
                                                await newDocumentController
                                                    .getDocumentSubType(
                                                        index:
                                                            index); // انتظر لحد ما تخلص
                                              },
                                              onCansle: () {
                                                newDocumentController
                                                    .selectedDocType[index]
                                                    .value = '';
                                              },
                                              hintText: "Select Document Type",
                                              dropdownItems:
                                                  newDocumentController
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
                                          .documentSubTypeTextController[index],
                                      model: newDocumentController
                                          .documentsSubTypeModel,
                                      gotData: newDocumentController
                                          .gotDocumentSubTypeData,
                                      id: newDocumentController.docSubId[index],
                                      FunctionToCall: () async {
                                        newDocumentController
                                            .gotDocumentSpicificTypeData
                                            .value = false;
                                        await newDocumentController
                                            .getDocumentSpicificType(
                                                index: index);
                                        await newDocumentController
                                            .getDocumentParentsModel();
                                      },
                                      cancleDocumentField: () async {
                                        newDocumentController
                                            .documentSubTypeTextController[
                                                index]
                                            .text = '';
                                        newDocumentController
                                            .documentSpecificTypeTextController[
                                                index]
                                            .text = '';
                                        newDocumentController
                                            .docSubId[index].value = '0';
                                        newDocumentController
                                            .gotDocumentSpicificTypeData
                                            .value = false;
                                        newDocumentController
                                            .getDocumentSpicificType(
                                                index: index);
                                      },
                                    ),

                                    PreferenceUtils.getBoolValue("isDoctor")
                                        ? SizedBox(height: height * 0.02)
                                        : const SizedBox(),

                                    /// Document SpecificType
                                    SizedBox(height: height * 0.02),

                                    SearchDropItemsLocal(
                                      controller: newDocumentController
                                              .documentSpecificTypeTextController[
                                          index],
                                      model: newDocumentController
                                          .documentsSpecificTypeModel,
                                      gotData: newDocumentController
                                          .gotDocumentSpicificTypeData,
                                      FunctionToCall: () async {
                                        try {
                                          await newDocumentController
                                              .getDocumentParents(index: index);

                                          final data = newDocumentController
                                              .getDocumentParentsModel
                                              .value
                                              ?.Data;
                                          newDocumentController
                                                  .docId[index].value =
                                              '${data?['document_type_id'] ?? '0'}';
                                          newDocumentController
                                                  .docSubId[index].value =
                                              '${data?['document_subtype_id'] ?? '0'}';

                                          print('success my brotheeee');
                                          print(newDocumentController
                                              .docId[index].value);
                                          print(newDocumentController
                                              .docSubId[index].value);

                                          newDocumentController
                                              .updateDropdownControllers(
                                                  index: index);
                                        } catch (e) {
                                          print(e.toString());
                                        }
                                      },
                                      id: newDocumentController
                                          .docSpecificId[index],
                                      cancleDocumentField: () async {
                                        newDocumentController
                                            .documentSpecificTypeTextController[
                                                index]
                                            .text = '';
                                        newDocumentController
                                            .docSpecificId[index].value = '0';
                                        newDocumentController
                                            .documentSubTypeTextController[
                                                index]
                                            .text = '';
                                        newDocumentController
                                            .selectedDocSubType[index]
                                            .value = '';
                                        newDocumentController
                                            .selectedDocType[index].value = '';
                                        // إعادة تعيين القيم الأخرى أيضاً
                                        newDocumentController
                                            .docId[index].value = '0';
                                        newDocumentController
                                            .docSubId[index].value = '0';
                                        newDocumentController
                                            .getDocumentSubType(index: index);
                                      },
                                    ),

                                    ///lab and cat tests
                                    SizedBox(height: height * 0.02),
                                    Obx(
                                      () {
                                        if (newDocumentController
                                                .gotlabTestsData ==
                                            false) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return newDocumentController
                                                      .docId[index].value ==
                                                  '1'
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0),
                                                      child: Text(
                                                        "اختر التحاليل المطلوبة",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: Colors
                                                                .blueAccent),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 4,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: MultiSelectDialogField<
                                                            LabTestsDataModel>(
                                                          items: newDocumentController
                                                              .labtestsModel!
                                                              .data!
                                                              .map((test) => MultiSelectItem<
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
                                                          selectedColor:
                                                              Colors.blue,
                                                          dialogHeight: 500,
                                                          buttonIcon: const Icon(
                                                              Icons
                                                                  .medical_services_outlined,
                                                              color:
                                                                  Colors.blue),
                                                          buttonText:
                                                              const Text(
                                                            "اختر التحاليل",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                          cancelText:
                                                              const Text(
                                                                  "إلغاء"),
                                                          confirmText:
                                                              const Text("تم"),
                                                          initialValue:
                                                              newDocumentController
                                                                  .selectedLabTests,
                                                          onConfirm: (List<
                                                                  LabTestsDataModel>
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
                                                                    color: Colors
                                                                        .white),
                                                            chipColor:
                                                                Colors.blue,
                                                            onTap: (item) {
                                                              // ممكن تضيف remove لو عندك متغير داخلي
                                                              newDocumentController
                                                                  .selectedLabTests
                                                                  .remove(item);
                                                              newDocumentController
                                                                  .labTestInputs
                                                                  .remove(
                                                                      item.id);
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 6),
                                                // حقول الإدخال بناءً على json_labels
                                                Column(
                                                  children: labels.map((label) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4.0),
                                                      child: TextFormField(
                                                        onChanged: (value) {
                                                          // تخزين القيمة باستخدام مفتاح مميز: testId + label
                                                          // newDocumentController.labTestInputs['${test.id}_$label'] = value;
                                                        },
                                                        decoration:
                                                            InputDecoration(
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
                                            newDocumentController
                                                .patientController,
                                            index)
                                        : const SizedBox(),
                                    SizedBox(height: height * 0.02),

                                    ///attachment
                                    CommonRequiredText(
                                        width: width,
                                        text: StringUtils.attachment),
                                    SizedBox(height: height * 0.02),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              newDocumentController.multiple =
                                                  true;
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
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white,
                                                      image: !newDocumentController
                                                              .showFiles[index]
                                                              .value
                                                          ? const DecorationImage(
                                                              image: AssetImage(
                                                                  "assets/icon/take_photo.png"),
                                                              scale: 4)
                                                          : DecorationImage(
                                                              image: FileImage(File(
                                                                  newDocumentController
                                                                      .files[
                                                                          index]!
                                                                      .path)),
                                                            ),
                                                    ));
                                              }),
                                            ),
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: IconButton(
                                        //     onPressed: () {
                                        //       newDocumentController.imageLenght.value++;
                                        //       // تهيئة كل الـ Controllers للصفحة الجديدة
                                        //       newDocumentController
                                        //           .initializeControllersForNewImages(
                                        //               newDocumentController
                                        //                   .imageLenght.value);
                                        //       if(newDocumentController.imageLenght.value > 0)
                                        //       // newDocumentController.showFiles[index].value = true;
                                        //
                                        //       // الانتقال للصفحة الجديدة
                                        //       Future.delayed(
                                        //           Duration(milliseconds: 100), () {
                                        //         newDocumentController.pageController
                                        //             .animateToPage(
                                        //           newDocumentController.imageLenght.value -
                                        //               1,
                                        //           duration: Duration(milliseconds: 300),
                                        //           curve: Curves.easeInOut,
                                        //         );
                                        //       });
                                        //     },
                                        //     icon: Icon(Icons.add_a_photo),
                                        //   ),
                                        // ),
                                        Expanded(
                                          child: Container(
                                            child: IconButton(
                                              onPressed: () {
                                                newDocumentController.multiple =
                                                    false;
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
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height * 0.02),
                                    SizedBox(height: height * 0.02),

                                    ///details
                                    CommonRequiredText(
                                        width: width,
                                        text: StringUtils.details),
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

                                    ///conclusion
                                    CommonRequiredText(
                                        width: width,
                                        text: StringUtils.conclusion),
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
                                              .extractedConclusion
                                              .value[index] = v;
                                        },
                                        controller: newDocumentController
                                                .conclusionControllers[
                                            index], // استخدام قائمة controllers
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),

                                    ///report
                                    CommonRequiredText(
                                        width: width,
                                        text: StringUtils.reportDate),
                                    SizedBox(height: height * 0.01),
                                    CommonTextField(
                                      maxLine: 3,
                                      validator: (value) {
                                        return null;
                                      },
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(2024),
                                          lastDate: DateTime(2028),
                                        );

                                        if (pickedDate != null) {
                                          String formattedDate =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(pickedDate);
                                          newDocumentController
                                                  .reportDateControllers[index]
                                                  .text =
                                              formattedDate; // استخدام قائمة controllers
                                        }
                                      },
                                      onchange: (v) {
                                        newDocumentController
                                                .reportDateControllers[index]
                                                .text =
                                            v; // استخدام قائمة controllers
                                      },
                                      suffixIcon: Icon(Icons.date_range),
                                      keyBoardType: TextInputType.none,
                                      controller: newDocumentController
                                              .reportDateControllers[
                                          index], // استخدام قائمة controllers
                                    ),
                                    SizedBox(height: height * 0.01),

                                    ///labName
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
                                                .text =
                                            v; // استخدام قائمة controllers
                                      },
                                      controller: newDocumentController
                                              .labNameControllers[
                                          index], // استخدام قائمة controllers
                                    ),
                                    SizedBox(height: height * 0.02),

                                    ///notes
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
                                        newDocumentController
                                                .notesControllers[index].text =
                                            v; // استخدام قائمة controllers
                                      },
                                      controller: newDocumentController
                                              .notesControllers[
                                          index], // استخدام قائمة controllers
                                    ),
                                    SizedBox(height: height * 0.02),

                                    ///submit and cancle
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CommonButton(
                                          textStyleConst:
                                              TextStyleConst.mediumTextStyle(
                                                  ColorConst.whiteColor,
                                                  width * 0.05),
                                          onTap: () async {
                                            newDocumentController
                                                .createDocuments();
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
                                  "${newDocumentController.currentPageIndex.value + 1}/${newDocumentController.imageLenght.value == 0 ? 1 : newDocumentController.imageLenght.value}", // عرض الصفحة الحالية / العدد الكلي
                                  style: TextStyle(color: Colors.grey),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
