import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infyhms_flutter/constant/color_const.dart';
import 'package:infyhms_flutter/utils/string_utils.dart';

import '../../component/common_app_bar.dart';
import '../../component/common_button.dart';
import '../../component/common_required_text.dart';
import '../../component/common_text_field.dart';
import '../../constant/text_style_const.dart';
import '../../controller/patient/AddPatient/AddPatientController.dart';

class AddPatientScreen extends StatefulWidget {
  AddPatientScreen({Key? key}) : super(key: key);

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final Addpatientcontroller addpatientcontroller = Get.put(Addpatientcontroller());
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key:_key ,
      child: Scaffold(
        resizeToAvoidBottomInset: true, // تمكين التفاعل مع لوحة المفاتيح
        body: Obx(() {
          return addpatientcontroller.gotData.value == false
              ? const Center(child: CircularProgressIndicator(),)
              : SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // التعامل مع لوحة المفاتيح
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Data Section
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ExpansionTile(
                      title: Text(
                        'Basic Data',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.05,),
                      ),
                      children: [
                        Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonRequiredText(width: width, text: 'first_name'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.first_name,
                              ),
                              CommonRequiredText(width: width, text: 'last_name'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.last_name,
                              ),
                              CommonRequiredText(width: width, text: 'email'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.email,
                              ),
                              CommonRequiredText(width: width, text: 'password'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                suffixIcon: Obx(() => IconButton(
                                  onPressed: () async {
                                    addpatientcontroller.visability();
                                  },
                                  icon: Icon(addpatientcontroller.visabilityIcon.value),
                                )),
                                obscureText: addpatientcontroller.obscureText.value,
                                maxLine: 1,
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.password,
                              ),

                              CommonRequiredText(width: width, text: 'confirm password'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                suffixIcon: Obx(() => IconButton(
                                  onPressed: () async {
                                    addpatientcontroller.visabilityConfirm();
                                  },
                                  icon: Icon(addpatientcontroller.visabilityIconConfirm.value),
                                )),
                                obscureText: addpatientcontroller.obscureTextConfirm.value,
                                maxLine: 1,
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.confirmPassword,
                              ),

                              CommonRequiredText(width: width, text: 'designation'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.designation,
                              ),
                              CommonRequiredText(width: width, text: 'phone'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.phone,
                              ),
                            ],
                          );
                        }),
                        // Gender Section
                        Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonRequiredText(width: width, text: 'gender'),
                              SizedBox(height: height * 0.01),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: addpatientcontroller.genderChoose.value == 'Male',
                                          onChanged: (value) {
                                            if (value == true) {
                                              addpatientcontroller.genderChoose.value = 'Male';
                                            } else {
                                              addpatientcontroller.genderChoose.value = '';
                                            }
                                          },
                                        ),
                                        Text('Male'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: addpatientcontroller.genderChoose.value == 'Female',
                                          onChanged: (value) {
                                            if (value == true) {
                                              addpatientcontroller.genderChoose.value = 'Female';
                                            } else {
                                              addpatientcontroller.genderChoose.value = '';
                                            }
                                          },
                                        ),
                                        Text('Female'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                        Obx(() {
                          return
                            addpatientcontroller.gotData.value == false
                                ? const Center(child: CircularProgressIndicator(),)
                                :Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonRequiredText(width: width, text: 'qualification'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.qualification,
                              ),
                              CommonRequiredText(width: width, text: 'date of birth'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.dob,
                              ),
                              CommonRequiredText(width: width, text: 'username'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.username,
                              ),
                              SizedBox(height: height * 0.01),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),

                  // Address Section
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ExpansionTile(
                      title: Text(
                        'Address',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.05),
                      ),
                      children: [
                        Obx(() {
                          return addpatientcontroller.gotData.value == false
                              ? const Center(child: CircularProgressIndicator(),)
                              :Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonRequiredText(width: width, text: 'city'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.city,
                              ),
                              CommonRequiredText(width: width, text: 'address_id'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.address_id,
                              ),
                              CommonRequiredText(width: width, text: 'region_code'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.region_code,
                              ),
                              CommonRequiredText(width: width, text: 'hospital_name'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.hospital_name,
                              ),
                              SizedBox(height: height * 0.01),
                            ],
                          );
                        }),

                      ],
                    ),
                  ),

                  // Social Media Section
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ExpansionTile(
                      title: Text(
                        'Social Media',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.05),
                      ),
                      children: [
                        Obx(() {
                          return addpatientcontroller.gotData.value == false
                              ? const Center(child: CircularProgressIndicator(),)
                              :Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonRequiredText(width: width, text: 'facebook_url'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.facebook_url,
                              ),
                              CommonRequiredText(width: width, text: 'twitter_url'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.twitter_url,
                              ),
                              CommonRequiredText(width: width, text: 'instagram_url'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.instagram_url,
                              ),
                              CommonRequiredText(width: width, text: 'linkedIn_url'),
                              SizedBox(height: height * 0.01),
                              CommonTextField(
                                validator: (value) {
                                  return null;
                                },
                                onchange: (v) {},
                                controller: addpatientcontroller.linkedIn_url,
                              ),
                              SizedBox(height: height * 0.01),
                            ],
                          );
                        }),

                      ],
                    ),
                  ),

                  // Submit Button
                  SizedBox(height: height * 0.03),
                  Center(
                    child: CommonButton(
                      textStyleConst: TextStyleConst.mediumTextStyle(
                        ColorConst.whiteColor,
                        width * 0.05,
                      ),
                      onTap: () {},
                      color: ColorConst.blueColor,
                      text: 'Submit',
                      width: width / 2.5,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
          );
        },)
      ),
    );
  }
}




