import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:infyhms_flutter/constant/color_const.dart';
import 'dart:convert';

import '../controller/patient/document_controller/new_document_controller.dart';
import '../model/patient/auth_model/login_model.dart';
import '../utils/preference_utils.dart';

class SearchableDropdown extends StatefulWidget {
  String? endPoint;
  String? label;
  dynamic Model;
  SearchableDropdown(this.endPoint, this.Model, this.label);
  @override
  _SearchableDropdownState createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  final TextEditingController _controller = TextEditingController();
  final SuggestionsBoxController _suggestionsBoxController =
      SuggestionsBoxController();
  LoginModel? loginModel;
  final NewDocumentController newDocumentController =
      Get.put(NewDocumentController());
  bool isSearched = false;
  bool isOpend = false;
  String baseUrl = 'https://local.mdiprove.com/api';

  Future<List<dynamic>> fetchSuggestions(String query) async {
    final String? endPoint = widget.endPoint;

    if (endPoint == null || endPoint.isEmpty) {
      print("Error in fetchSuggestions: Endpoint is null or empty.");
      return []; // أرجع قائمة فارغة إذا لم يتم توفير endpoint
    }

    try {
      // 1. أصلح بنية الـ URL وأضف ترميز الاستعلام

      final encodedQuery = Uri.encodeComponent(query);
      final URL = '${baseUrl}/${endPoint}/search/$encodedQuery';
      print(URL);
      final url = Uri.parse(
        '${URL}',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${PreferenceUtils.getStringValue("token")}',
          'Accept': 'application/json',
          'Content-Type': 'application/json', // 2. أضف هذا الـ Header
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // 3. استخرج البيانات من الحقل "data"
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> items = responseData['data'] ?? [];
        isSearched = true;
        return items;
      } else {
        throw Exception('فشل في جلب البيانات: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('حدث خطأ: $e');
    }
  }

  List getLocalData() {
    dynamic model = widget.Model;

    return model.data!.map((items) {
      print(items.patient_name);
      print(items.id);
      return {
        'id': items.id.toString(),
        'name': items.patient_name ?? "Unknown Patient",
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.label,
            floatingLabelStyle: TextStyle(
              color: ColorConst.primaryColor,
            ), // لون عند التركيز
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              // حدود عند عدم التركيز
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              // حدود عند التركيز
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ColorConst.primaryColor, width: 2),
            ),
            filled: true, // خلفية مملوءة
            fillColor: Colors.grey.shade50, // لون الخلفية
            suffixIcon: AnimatedSwitcher(
              // رسوم متحركة للأيقونة
              duration: Duration(milliseconds: 300),
              child: _controller.text.isEmpty
                  ? Icon(Icons.search,
                      color: Colors.grey.shade500) // أيقونة بحث عند الفراغ
                  : IconButton(
                      icon: Icon(Icons.close, color: Colors.grey.shade600),
                      onPressed: () {
                        _controller.text = '';
                        isSearched = false;
                      }, // زر مسح عند وجود نص
                    ),
            ),
            prefixIcon: Padding(
              // إضافة أيقونة دائمة
              padding: EdgeInsets.only(left: 12),
              child: Icon(Icons.person_search, color: ColorConst.primaryColor),
            ),
            contentPadding: EdgeInsets.symmetric(
                vertical: 16, horizontal: 20), // مسافات داخلية
          ),
          style: TextStyle(
            // نمط النص المدخل
            color: Colors.grey.shade800,
            fontSize: 16,
          ),
          cursorColor: ColorConst.primaryColor, // لون المؤشر
          onChanged: (value) {
            setState(() {
              isSearched = value.isNotEmpty;
            });
          },
          onTap: () {
            if (isOpend) {
              _suggestionsBoxController.close();
            } else {
              _suggestionsBoxController.open();
            }
            setState(() => isOpend = !isOpend);
          },
        ),
        suggestionsCallback: (pattern) async {
          if (pattern.isEmpty) {
            return getLocalData();
          } else {
            if (pattern.length < 3) {
              return [
                {
                  'isMessage': true,
                  'message': 'الرجاء إدخال ثلاثة أحرف على الأقل للبحث',
                }
              ];
            } else {
              final results = await fetchSuggestions(pattern);
              if (results.isEmpty) {
                return [
                  {
                    'isMessage': true,
                    'message':
                        'لم نعثر على نتائج لبحثك', // رسالة عدم وجود نتائج
                    'type': 'error',
                  }
                ];
              }
              print('Result Of Search $results');
              return results;
            }
          }
        },
        itemBuilder: (context, dynamic suggestion) {
          if (suggestion['isMessage'] == true) {
            return ListTile(
              title: Text(
                suggestion['message'],
                style: TextStyle(
                  color: suggestion['message'] == 'لم نعثر على نتائج لبحثك'
                      ? ColorConst.redColor
                      : ColorConst.redColor, // لون أعمق
                  fontSize: 16, // حجم أكبر قليلاً
                  fontWeight: FontWeight.w500, // سماكة متوسطة
                  fontStyle: FontStyle.italic, // نص مائل
                ),
              ),
              enabled: false,
              tileColor: Colors.blueGrey.shade50, // خلفية فاتحة
              shape: RoundedRectangleBorder(
                // حواف مدورة
                borderRadius: BorderRadius.circular(8),
              ),
            );
          } else {
            if (suggestion['text'] == null && isSearched == true) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListTile(
                title: Text(
                  isSearched ? suggestion['text'] : suggestion['name'],
                  style: TextStyle(
                    color: ColorConst.primaryColor, // لون داكن أنيق
                    fontWeight: FontWeight.bold, // نص عريض
                  ),
                ),
                subtitle: Text(
                  suggestion['id']?.toString() ?? 'بدون معرف',
                  style: TextStyle(
                    color: ColorConst.primaryColor, // لون فرعي أغمق
                    fontSize: 12,
                  ),
                ),
                leading: Icon(
                  // إضافة أيقونة
                  Icons.person_outline,
                  color: ColorConst.primaryColor,
                ),
                trailing: Icon(
                  // أيقونة جانبية
                  Icons.chevron_right,
                  color: ColorConst.primaryColor,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16), // تعديل المسافات
                visualDensity: VisualDensity.comfortable, // مسافات داخلية أكبر
                shape: RoundedRectangleBorder(
                  // نفس الحواف المدورة
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }
          }
        },
        onSuggestionSelected: (dynamic suggestion) {
          dynamic idType ;
          if (isSearched) {
            _controller.text = suggestion['text'];
              idType = suggestion['id'].toString();
              print(idType);
              newDocumentController.patientId = idType;
          } else {
            _controller.text = suggestion['name'];
              idType = suggestion['id'].toString();
              print(idType);
            newDocumentController.patientId = idType;
          }
        },
        suggestionsBoxController: _suggestionsBoxController,
      ),
    );
  }
}
