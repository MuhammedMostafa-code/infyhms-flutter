import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Addpatientcontroller extends GetxController {
  RxBool gotData = false.obs;
  var genderChoose = ''.obs;
  TextEditingController department_id = TextEditingController();
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController qualification = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController blood_group = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController address_id = TextEditingController();
  TextEditingController region_code = TextEditingController();
  TextEditingController hospital_name = TextEditingController();
  TextEditingController facebook_url = TextEditingController();
  TextEditingController twitter_url = TextEditingController();
  TextEditingController instagram_url = TextEditingController();
  TextEditingController linkedIn_url = TextEditingController();

  Future Data()async{
     gotData = true.obs;
     password.text = '123456';
     confirmPassword.text = '123456';
  }
  var obscureText = true.obs;
  var obscureTextConfirm = true.obs;
  var visabilityIcon = Icons.visibility_off.obs;
  var visabilityIconConfirm = Icons.visibility_off.obs;
  Future visability() async {
    obscureText.toggle(); // تغيير القيمة تلقائيًا
    visabilityIcon.value =
    obscureText.value ? Icons.visibility_off : Icons.visibility;
  }

  Future visabilityConfirm() async {
    obscureTextConfirm.toggle(); // تغيير القيمة تلقائيًا
    visabilityIconConfirm.value =
    obscureTextConfirm.value ? Icons.visibility_off : Icons.visibility;
  }

  @override
  void onInit() {
    // TODO: implement onInit
   Data();
  }
}
