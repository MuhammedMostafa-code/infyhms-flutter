import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonLoader {
  static void showLoader() {
    if (Platform.isIOS) {
      showIOSLoader();
    } else {
      showAndroidLoader();
    }
  }

  static void showIOSLoader() {
    Get.dialog(
      CupertinoAlertDialog(
        content: Row(
          children: const [
            CupertinoActivityIndicator(),
            SizedBox(width: 10),
            Text("Please wait..."),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void showAndroidLoader() {
    Get.dialog(
      AlertDialog(
        content: Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 10),
            Text("Please wait..."),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
  static void hideLoader() {
    if (Get.isDialogOpen ?? false) {
      Get.back(); // بيقفل الـ Dialog لو مفتوح
    }
  }
}
