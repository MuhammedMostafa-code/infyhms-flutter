import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../../controller/patient/document_controller/new_document_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

class DocumentDataExtractScreen extends StatefulWidget {
  const DocumentDataExtractScreen({Key? key}) : super(key: key);

  @override
  State<DocumentDataExtractScreen> createState() =>
      _DocumentDataExtractScreenState();
}

class _DocumentDataExtractScreenState extends State<DocumentDataExtractScreen> {
  final ImagePicker _picker = ImagePicker();
  final NewDocumentController _extractController =
      Get.put(NewDocumentController());
  List<XFile> _pickedImages = [];
  List<String> _extractedTexts = [];
  bool _loading = false;

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        _pickedImages = images;
        _extractedTexts = List.filled(images.length, '');
        _loading = true;
      });
      await _extractAllTexts();
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _extractAllTexts() async {
    for (int i = 0; i < _pickedImages.length; i++) {
      await _extractController.textRecognition(_pickedImages[i], index: 0);
      // Use the controller's extractedTexts for the result
      setState(() {
        _extractedTexts[i] = _extractController.extractedTexts.value[0];
      });
    }
  }

  Future<void> _downloadCSV() async {
    List<List<String>> rows = [];
    for (int i = 0; i < _pickedImages.length; i++) {
      rows.add([_pickedImages[i].name, _extractedTexts[i]]);
    }
    String csvData = const ListToCsvConverter().convert(rows);

    if (Platform.isAndroid) {
      // Use external storage directory for Android
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final path = directory.path;
        final file = File('$path/extracted_texts.csv');
        await file.writeAsString(csvData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV saved to $path/extracted_texts.csv')),
        );
      } else {
        // Fallback to app documents directory
        final appDir = await getApplicationDocumentsDirectory();
        final file = File('${appDir.path}/extracted_texts.csv');
        await file.writeAsString(csvData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('CSV saved to ${appDir.path}/extracted_texts.csv')),
        );
      }
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('$path/extracted_texts.csv');
      await file.writeAsString(csvData);
      // Share the file on iOS
      await Share.shareXFiles([XFile(file.path)], text: 'Extracted CSV file');
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save your CSV file',
        fileName: 'extracted_texts.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(csvData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV saved to $outputFile')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Save cancelled')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Data Extract'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _loading ? null : _pickImages,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Pick Images'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: (_pickedImages.isNotEmpty && !_loading)
                      ? _downloadCSV
                      : null,
                  icon: const Icon(Icons.download),
                  label: const Text('Download CSV'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _pickedImages.isEmpty
                        ? const Center(child: Text('No images selected.'))
                        : ListView.builder(
                            itemCount: _pickedImages.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.file(
                                        File(_pickedImages[index].path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            _extractedTexts[index],
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
