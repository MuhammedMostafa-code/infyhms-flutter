import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infyhms_flutter/component/common_error.dart';
import 'package:infyhms_flutter/component/common_loader.dart';
import 'package:infyhms_flutter/component/common_snackbar.dart';
import 'package:infyhms_flutter/component/common_socket_exception.dart';
import 'package:infyhms_flutter/model/patient/auth_model/login_model.dart';
import 'package:infyhms_flutter/screens/home_screen.dart';
import 'package:infyhms_flutter/utils/preference_utils.dart';
import 'package:infyhms_flutter/utils/string_utils.dart';

class LogInController extends GetxController {
  LoginModel? loginModel;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isCheck = false.obs;
  RxBool showPassword = false.obs;

  void hideAndShowPassword() {
    showPassword.value = !showPassword.value;
  }

  void loginPatient(BuildContext context) {
    if (emailController.text.isEmpty) {
      DisplaySnackBar.displaySnackBar("Please enter email address");
    } else if (emailController.text.isEmpty) {
      DisplaySnackBar.displaySnackBar("Please enter password");
    } else {
      CommonLoader.showLoader();
      StringUtils.client.loginPatient({
        "email": emailController.text,
        "password": passwordController.text,
      })
        ..then((value) {
          loginModel = value;
          if (loginModel!.success == true) {
            PreferenceUtils.setStringValue("token", "Bearer ${loginModel!.data!.token!}");
            PreferenceUtils.setStringValue("first_name", loginModel!.data!.user!.first_name!);
            PreferenceUtils.setStringValue("last_name", loginModel!.data!.user!.last_name!);
            PreferenceUtils.setStringValue("email", loginModel!.data!.user!.email!);
            PreferenceUtils.setStringValue("phone_number", loginModel!.data!.user!.phone_number!);
            PreferenceUtils.setStringValue("image_url", loginModel!.data!.user!.image_url!);
            PreferenceUtils.setStringValue("password", passwordController.text);
            PreferenceUtils.setStringValue("patientId", "${loginModel!.data!.user!.id}");
            PreferenceUtils.setBoolValue("isDoctor", loginModel!.data!.is_doctor!);
            Get.to(() => const HomeScreen());
            print('${loginModel!.data!.token!}==================================================================================================');
          } else {
            CommonError().showMaterialBanner(context, "${value.message}");
          }
        })
        ..onError((DioError error, stackTrace) {
          Get.back();
          CheckSocketException.checkSocketException(error);
          return LoginModel();
        });
    }
  }
}
