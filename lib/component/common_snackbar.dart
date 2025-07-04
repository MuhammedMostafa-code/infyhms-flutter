import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infyhms_flutter/constant/text_style_const.dart';

import '../constant/color_const.dart';


class DisplaySnackBar {
  static displaySnackBar(String content, [int? sec, Color? bgColor]) {
    Get.rawSnackbar(
      backgroundColor: bgColor ??  ColorConst.blackColor,
      messageText: Text(
        content,
        style: TextStyleConst.mediumTextStyle(Colors.white, 15),
      ),
      borderRadius: 5,
      duration: Duration(seconds: sec ?? 2),
      margin: const EdgeInsets.all(10),
      dismissDirection: DismissDirection.horizontal,
    );
  }
}

