import 'package:flutter/material.dart';
import 'package:infyhms_flutter/constant/color_const.dart';
import 'package:infyhms_flutter/constant/text_style_const.dart';

class CommonRequiredText extends StatelessWidget {
  const CommonRequiredText({
    Key? key,
    required this.width,
    required this.text,
    this.isRequried = true,
  }) : super(key: key);

  final double width;
  final String text;
  final bool isRequried;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyleConst.boldTextStyle(
          ColorConst.blackColor,
          width * 0.045,
        ),
        children: [
          TextSpan(
            text: isRequried == true ? "*" : "",
            style: TextStyleConst.mediumTextStyle(
              ColorConst.redColor,
              width * 0.045,
            ),
          ),
        ],
      ),
    );
  }
}
