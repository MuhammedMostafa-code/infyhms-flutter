import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controller/patient/document_controller/new_document_controller.dart';

class DocumentImage extends StatefulWidget {
  const DocumentImage({super.key});

  @override
  State<DocumentImage> createState() => _DocumentImageState();
}

class _DocumentImageState extends State<DocumentImage> {
  final NewDocumentController newDocumentController = Get.find<NewDocumentController>(); // Use Get.find to get the existing controller

  @override
  Widget build(BuildContext context) {
    return Center( // Removed extra Center from SafeArea's child for cleaner code
      child: InkWell( // Make the DottedBorder clickable to trigger image picking
        onTap: () {
          newDocumentController.pickImage(); // Trigger image picking on tap
        },
        child: DottedBorder(
          color: Colors.grey,
          radius: const Radius.circular(10),
          strokeWidth: 2,
          borderType: BorderType.RRect,
          dashPattern: const [4],
          child: Obx(() {
            // Check if there are any files in the list and if showFiles is true for the first file (or any file)
            bool hasFile = newDocumentController.files.isNotEmpty;
            bool showImage = hasFile && newDocumentController.showFiles.isNotEmpty && newDocumentController.showFiles[0].value;

            return Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                image: !showImage // Use the boolean to determine which image to show
                    ? const DecorationImage(image: AssetImage("assets/icon/take_photo.png"), scale: 4)
                    : DecorationImage(
                  image: FileImage(
                      newDocumentController.files[0] // Access the first file in the list
                  ),
                  fit: BoxFit.cover, // Added BoxFit.cover to make image fit within the container
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}