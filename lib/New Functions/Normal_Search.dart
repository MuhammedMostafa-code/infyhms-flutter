import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../constant/color_const.dart';
import '../controller/patient/document_controller/new_document_controller.dart';
import '../utils/preference_utils.dart';

class SearchDropItemsLocal extends StatefulWidget {
  final dynamic model;
  final RxBool? gotData;
  final RxString? id;
  final Function? FunctionToCall;
  final Function? cancleDocumentField;
  final TextEditingController? controller;

  const SearchDropItemsLocal({
    Key? key,
    this.model,
    this.gotData,
    this.id,
    this.FunctionToCall,
    this.cancleDocumentField,
    this.controller,
  }) : super(key: key);

  @override
  State<SearchDropItemsLocal> createState() => SearchDropItemsLocalState();
}

String? SelectType;

class SearchDropItemsLocalState extends State<SearchDropItemsLocal> {
  final NewDocumentController newDocumentController =
      Get.put(NewDocumentController());
  final FocusNode _focusNode = FocusNode();
  bool _isOpen = false;
  @override
  void initState() {
    super.initState();
    widget.controller!.addListener(() {
      setState(() {}); // لتحديث الواجهة عند تغيير النص
    });
  }

  void _toggleDropdown() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!widget.gotData!.value) {
        return Shimmer.fromColors(
          baseColor: ColorConst.blueColor!,
          highlightColor: ColorConst.bgGreyColor!,
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }

      final List<MapEntry<String, dynamic>> entries =
          (widget.model.value?.data?.entries.toList() ?? [])
              .cast<MapEntry<String, dynamic>>();

      return TypeAheadFormField<MapEntry<String, dynamic>>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: widget.controller!,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: "Select Document Sub Type",
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon:
                Icon(Icons.description_outlined, color: Colors.blueAccent),
            suffixIcon: widget.controller!.text == ''
                ? Icon(
                    _isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[700],
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.cancleDocumentField!();
                        if (PreferenceUtils.getBoolValue("isDoctor")) {
                          newDocumentController.getDoctorDocumentsType();
                        } else {
                          newDocumentController.getDocumentTypes();
                        }
                        _isOpen = false;
                      });
                    },
                    child: Icon(Icons.clear, color: Colors.grey[600]),
                  ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
            ),
          ),
        ),
        suggestionsCallback: (pattern) {
          return entries.where((entry) =>
              entry.value.toLowerCase().contains(pattern.toLowerCase()));
        },
        itemBuilder: (context, MapEntry<String, dynamic> suggestion) {
          return ListTile(
            leading:
                Icon(Icons.insert_drive_file_outlined, color: Colors.blueGrey),
            title: Text(suggestion.value),
          );
        },
        onSuggestionSelected: (MapEntry<String, dynamic> suggestion) async {
          if (widget.id != null) {
            widget.id!.value = suggestion.key;
            // print("ID تم تغييره إلى: ${widget.id!.value}");
            // print(newDocumentController.docSpecificId);
          }
          // print(newDocumentController.docSubId);
          widget.controller!.text = suggestion.value;
          widget.FunctionToCall!();
          _toggleDropdown();
        },
        noItemsFoundBuilder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "No matching document sub type found.",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    widget.controller!.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
