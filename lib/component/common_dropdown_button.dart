import 'package:flutter/material.dart';
import 'package:infyhms_flutter/constant/color_const.dart';
import 'package:infyhms_flutter/constant/text_style_const.dart';

class CommonDropDown extends StatelessWidget {
  const CommonDropDown({
    Key? key,
    this.hintText,
    this.dropButtonHeight,
    this.onChange,
    this.errorText,
    this.onTap,
    this.enabled,
    this.color,
    this.value,
    required this.dropdownItems,
    this.onCansle,
  }) : super(key: key);

  final List<DropdownMenuItem<String>> dropdownItems;
  final String? hintText;
  final double? dropButtonHeight;
  final ValueChanged<String?>? onChange;
  final String? errorText;
  final VoidCallback? onTap;
  final Color? color;
  final bool? enabled;
  final String? value;
  final Function? onCansle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color ?? Colors.white,
      ),
      child: DropdownButtonFormField(
        value: value,
        onTap: onTap,
        isExpanded: true,
        // validator: (value) => value == null ? 'Please select any code' : null,
        menuMaxHeight: dropButtonHeight,
        icon: Row(children: [
         const Icon(Icons.keyboard_arrow_down_rounded),
         IconButton(onPressed: (){onCansle!();}, icon: const Icon(Icons.cancel_sharp))
        ],),
        decoration: InputDecoration(
          enabled: enabled ?? true,
          errorText: errorText,
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE8EAF0), width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE8EAF0), width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyleConst.hintTextStyle(ColorConst.hintGreyColor),
          contentPadding: enabled ?? true ? const EdgeInsets.fromLTRB(10, 30, 10, 8) : const EdgeInsets.fromLTRB(10, 20, 10, 20),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE8EAF0), width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE8EAF0), width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        items: dropdownItems,
        onChanged: onChange,
      ),
    );
  }
}
