import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../constant/color_const.dart';
import '../constant/text_style_const.dart';
import '../controller/patient/document_controller/document_list_controller.dart';
import '../screens/patient/document/edit_document_screen.dart';
import '../utils/image_utils.dart';
import '../utils/preference_utils.dart';
import '../utils/string_utils.dart';

class DocumentSearch extends SearchDelegate {
  DocumentController documentController = Get.put(DocumentController());
  List Names = [
   'muhammed',
   'ahmed',
   'mahmoud',
   'mostafa',
   'ghada',
   'shereen',
  ];

  List filterList = [];
  dynamic documentList ;
  @override

  List<Widget>? buildActions(BuildContext context) {
          return[
          IconButton(
              onPressed: (){
                query = '';
              },
              icon: Icon(Icons.close,)
          )
          ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return
      IconButton(
          onPressed: (){
            close(context, null);
          },
          icon: Icon(Icons.arrow_back,color: ColorConst.blueColor,)
      );
  }

  @override
  Widget buildResults(BuildContext context) {
  return Text('');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
   if(query == ''){
     if (PreferenceUtils.getBoolValue("isDoctor"))
     {return Padding(
         padding: const EdgeInsets.all(25.0),
         child:
         ListView.builder(
           itemCount: documentController.doctorDocumentsModel!.data!.length,
           physics: const BouncingScrollPhysics(),
           itemBuilder: (context, index) {
             return Column(
               children: [
                 Slidable(
                   startActionPane: ActionPane(
                     extentRatio: 0.25,
                     motion: const ScrollMotion(),
                     children: [
                       SlidableAction(
                         onPressed: (contextAction) async {
                           final message = await Get.to(
                                   () => EditDocumentScreen(documentId: documentController.doctorDocumentsModel?.data?[index].id ?? 0),
                               transition: Transition.leftToRight,
                               arguments: {
                                 "title": documentController.doctorDocumentsModel?.data?[index].title,
                                 "docType": documentController.doctorDocumentsModel?.data?[index].document_type_id,
                                 "attachment": documentController.doctorDocumentsModel?.data?[index].document_url,
                                 "note": documentController.doctorDocumentsModel?.data?[index].notes,
                               });
                           if (message == "Call API") {
                             documentController.getDocuments();
                           }
                         },
                         backgroundColor: ColorConst.orangeColor.withOpacity(0.15),
                         label: StringUtils.edit,
                         foregroundColor: ColorConst.orangeColor,
                         // lableColor: ColorConst.orangeColor,
                       ),
                     ],
                   ),
                   endActionPane: ActionPane(
                     extentRatio: 0.25,
                     motion: const ScrollMotion(),
                     children: [
                       SlidableAction(
                         onPressed: (contextAction) {
                           documentController.showDeleteDialog(context, height, width, index);
                         },
                         backgroundColor: const Color(0xFFFCE5E5),
                         label: StringUtils.delete,
                         foregroundColor: ColorConst.redColor,
                         // lableColor: Colors.red,
                       ),
                     ],
                   ),
                   child: ListTile(
                       onTap: () {},
                       contentPadding: EdgeInsets.only(top: index == 0 ? 15 : 0, right: 15, left: 15),
                       title: Text(
                         documentController.doctorDocumentsModel?.data?[index].title ?? "",
                         style: TextStyleConst.mediumTextStyle(
                           ColorConst.blackColor,
                           width * 0.045,
                         ),
                       ),
                       subtitle: Text(
                         documentController.doctorDocumentsModel?.data?[index].notes ?? "",
                         style: TextStyleConst.mediumTextStyle(
                           ColorConst.hintGreyColor,
                           width * 0.037,
                         ),
                       ),
                       leading: Container(
                         height: 35,
                         width: 35,
                         decoration: const BoxDecoration(
                           image: DecorationImage(
                             fit: BoxFit.contain,
                             // image: NetworkImage(controller.documentsModel?.data?[index].document_url ?? ""),
                             image: AssetImage("assets/icon/imageIcon.png"),
                           ),
                         ),
                       ),
                       trailing: Obx(
                             () => documentController.isCurrentDownloading[index].value
                             ? const CircularProgressIndicator(color: ColorConst.primaryColor)
                             : InkWell(
                           onTap: () {
                             documentController.downloadDocument(context, index);
                           },
                           child: Container(
                             margin: const EdgeInsets.only(right: 10),
                             width: 25,
                             height: 25,
                             decoration: const BoxDecoration(
                               image: DecorationImage(
                                 image: AssetImage(ImageUtils.downloadIcon),
                               ),
                             ),
                           ),
                         ),
                       )),
                 ),
               ],
             );
           },
         )
       // ListView.builder(
       //   itemCount: Names.length,
       //   itemBuilder: (context, index) =>
       //       Card(child: Padding(
       //         padding: const EdgeInsets.all(10.0),
       //         child: Text('${Names[index]}',style: TextStyle(fontSize: 16),),
       //       )),
       //
       // )
     );}else
     {
       return Padding(
           padding: const EdgeInsets.all(25.0),
           child:
           ListView.builder(
             itemCount: documentController.documentsModel!.data!.length,
             physics: const BouncingScrollPhysics(),
             itemBuilder: (context, index) {
               return Column(
                 children: [
                   Slidable(
                     startActionPane: ActionPane(
                       extentRatio: 0.25,
                       motion: const ScrollMotion(),
                       children: [
                         SlidableAction(
                           onPressed: (contextAction) async {
                             final message = await Get.to(
                                     () => EditDocumentScreen(documentId: documentController.documentsModel?.data?[index].id ?? 0),
                                 transition: Transition.leftToRight,
                                 arguments: {
                                   "title": documentController.documentsModel?.data?[index].title,
                                   "docType": documentController.documentsModel?.data?[index].document_type_id,
                                   "attachment": documentController.documentsModel?.data?[index].document_url,
                                   "note": documentController.documentsModel?.data?[index].notes,
                                 });
                             if (message == "Call API") {
                               documentController.getDocuments();
                             }
                           },
                           backgroundColor: ColorConst.orangeColor.withOpacity(0.15),
                           label: StringUtils.edit,
                           foregroundColor: ColorConst.orangeColor,
                           // lableColor: ColorConst.orangeColor,
                         ),
                       ],
                     ),
                     endActionPane: ActionPane(
                       extentRatio: 0.25,
                       motion: const ScrollMotion(),
                       children: [
                         SlidableAction(
                           onPressed: (contextAction) {
                             documentController.showDeleteDialog(context, height, width, index);
                           },
                           backgroundColor: const Color(0xFFFCE5E5),
                           label: StringUtils.delete,
                           foregroundColor: ColorConst.redColor,
                           // lableColor: Colors.red,
                         ),
                       ],
                     ),
                     child: ListTile(
                         onTap: () {},
                         contentPadding: EdgeInsets.only(top: index == 0 ? 15 : 0, right: 15, left: 15),
                         title: Text(
                           documentController.documentsModel?.data?[index].title ?? "",
                           style: TextStyleConst.mediumTextStyle(
                             ColorConst.blackColor,
                             width * 0.045,
                           ),
                         ),
                         subtitle: Text(
                           documentController.documentsModel?.data?[index].notes ?? "",
                           style: TextStyleConst.mediumTextStyle(
                             ColorConst.hintGreyColor,
                             width * 0.037,
                           ),
                         ),
                         leading: Container(
                           height: 35,
                           width: 35,
                           decoration: const BoxDecoration(
                             image: DecorationImage(
                               fit: BoxFit.contain,
                               // image: NetworkImage(controller.documentsModel?.data?[index].document_url ?? ""),
                               image: AssetImage("assets/icon/imageIcon.png"),
                             ),
                           ),
                         ),
                         trailing: Obx(
                               () => documentController.isCurrentDownloading[index].value
                               ? const CircularProgressIndicator(color: ColorConst.primaryColor)
                               : InkWell(
                             onTap: () {
                               documentController.downloadDocument(context, index);
                             },
                             child: Container(
                               margin: const EdgeInsets.only(right: 10),
                               width: 25,
                               height: 25,
                               decoration: const BoxDecoration(
                                 image: DecorationImage(
                                   image: AssetImage(ImageUtils.downloadIcon),
                                 ),
                               ),
                             ),
                           ),
                         )),
                   ),
                 ],
               );
             },
           )
         // ListView.builder(
         //   itemCount: Names.length,
         //   itemBuilder: (context, index) =>
         //       Card(child: Padding(
         //         padding: const EdgeInsets.all(10.0),
         //         child: Text('${Names[index]}',style: TextStyle(fontSize: 16),),
         //       )),
         //
         // )
       );
     }

   }else{
     // filterList = Names.where((element) => element.contains(query)).toList();

     if (PreferenceUtils.getBoolValue("isDoctor"))
     {
       documentList = documentController.doctorDocumentsModel!.data!.where((element) => element.title!.contains(query)).toList();
       return Padding(
       padding: const EdgeInsets.all(25.0),
       child: ListView.builder(
         itemCount: documentList.length,
         physics: const BouncingScrollPhysics(),
         itemBuilder: (context, index) {
           return Column(
             children: [
               Slidable(
                 startActionPane: ActionPane(
                   extentRatio: 0.25,
                   motion: const ScrollMotion(),
                   children: [
                     SlidableAction(
                       onPressed: (contextAction) async {
                         final message = await Get.to(
                                 () => EditDocumentScreen(documentId: documentList[index].id ?? 0),
                             transition: Transition.leftToRight,
                             arguments: {
                               "title": documentList[index].title,
                               "docType": documentList[index].document_type_id,
                               "attachment": documentList[index].document_url,
                               "note": documentList[index].notes,
                             });
                         if (message == "Call API") {
                           documentController.getDocuments();
                         }
                       },
                       backgroundColor: ColorConst.orangeColor.withOpacity(0.15),
                       label: StringUtils.edit,
                       foregroundColor: ColorConst.orangeColor,
                       // lableColor: ColorConst.orangeColor,
                     ),
                   ],
                 ),
                 endActionPane: ActionPane(
                   extentRatio: 0.25,
                   motion: const ScrollMotion(),
                   children: [
                     SlidableAction(
                       onPressed: (contextAction) {
                         documentController.showDeleteDialog(context, height, width, index);
                       },
                       backgroundColor: const Color(0xFFFCE5E5),
                       label: StringUtils.delete,
                       foregroundColor: ColorConst.redColor,
                       // lableColor: Colors.red,
                     ),
                   ],
                 ),
                 child: ListTile(
                     onTap: () {},
                     contentPadding: EdgeInsets.only(top: index == 0 ? 15 : 0, right: 15, left: 15),
                     title: Text(
                       documentList[index].title ?? "",
                       style: TextStyleConst.mediumTextStyle(
                         ColorConst.blackColor,
                         width * 0.045,
                       ),
                     ),
                     subtitle: Text(
                       documentList[index].notes ?? "",
                       style: TextStyleConst.mediumTextStyle(
                         ColorConst.hintGreyColor,
                         width * 0.037,
                       ),
                     ),
                     leading: Container(
                       height: 35,
                       width: 35,
                       decoration: const BoxDecoration(
                         image: DecorationImage(
                           fit: BoxFit.contain,
                           // image: NetworkImage(controller.documentsModel?.data?[index].document_url ?? ""),
                           image: AssetImage("assets/icon/imageIcon.png"),
                         ),
                       ),
                     ),
                     trailing: Obx(
                           () => documentController.isCurrentDownloading[index].value
                           ? const CircularProgressIndicator(color: ColorConst.primaryColor)
                           : InkWell(
                         onTap: () {
                           documentController.downloadDocument(context, index);
                         },
                         child: Container(
                           margin: const EdgeInsets.only(right: 10),
                           width: 25,
                           height: 25,
                           decoration: const BoxDecoration(
                             image: DecorationImage(
                               image: AssetImage(ImageUtils.downloadIcon),
                             ),
                           ),
                         ),
                       ),
                     )),
               ),
             ],
           );
         },
       ),
       // ListView.builder(
       //   itemCount: filterList.length,
       //   itemBuilder: (context, index) =>
       //       Card(child: Padding(
       //         padding: const EdgeInsets.all(10.0),
       //         child: Text('${filterList[index]}',style: TextStyle(fontSize: 16),),
       //       )),
       //
       // ),
     );}else
     {
       documentList = documentController.documentsModel!.data!.where((element) => element.title!.contains(query)).toList();
       return Padding(
         padding: const EdgeInsets.all(25.0),
         child: ListView.builder(
           itemCount: documentList.length,
           physics: const BouncingScrollPhysics(),
           itemBuilder: (context, index) {
             return Column(
               children: [
                 Slidable(
                   startActionPane: ActionPane(
                     extentRatio: 0.25,
                     motion: const ScrollMotion(),
                     children: [
                       SlidableAction(
                         onPressed: (contextAction) async {
                           final message = await Get.to(
                                   () => EditDocumentScreen(documentId: documentList[index].id ?? 0),
                               transition: Transition.leftToRight,
                               arguments: {
                                 "title": documentList[index].title,
                                 "docType": documentList[index].document_type_id,
                                 "attachment": documentList[index].document_url,
                                 "note": documentList[index].notes,
                               });
                           if (message == "Call API") {
                             documentController.getDocuments();
                           }
                         },
                         backgroundColor: ColorConst.orangeColor.withOpacity(0.15),
                         label: StringUtils.edit,
                         foregroundColor: ColorConst.orangeColor,
                         // lableColor: ColorConst.orangeColor,
                       ),
                     ],
                   ),
                   endActionPane: ActionPane(
                     extentRatio: 0.25,
                     motion: const ScrollMotion(),
                     children: [
                       SlidableAction(
                         onPressed: (contextAction) {
                           documentController.showDeleteDialog(context, height, width, index);
                         },
                         backgroundColor: const Color(0xFFFCE5E5),
                         label: StringUtils.delete,
                         foregroundColor: ColorConst.redColor,
                         // lableColor: Colors.red,
                       ),
                     ],
                   ),
                   child: ListTile(
                       onTap: () {},
                       contentPadding: EdgeInsets.only(top: index == 0 ? 15 : 0, right: 15, left: 15),
                       title: Text(
                         documentList[index].title ?? "",
                         style: TextStyleConst.mediumTextStyle(
                           ColorConst.blackColor,
                           width * 0.045,
                         ),
                       ),
                       subtitle: Text(
                         documentList[index].notes ?? "",
                         style: TextStyleConst.mediumTextStyle(
                           ColorConst.hintGreyColor,
                           width * 0.037,
                         ),
                       ),
                       leading: Container(
                         height: 35,
                         width: 35,
                         decoration: const BoxDecoration(
                           image: DecorationImage(
                             fit: BoxFit.contain,
                             // image: NetworkImage(controller.documentsModel?.data?[index].document_url ?? ""),
                             image: AssetImage("assets/icon/imageIcon.png"),
                           ),
                         ),
                       ),
                       trailing: Obx(
                             () => documentController.isCurrentDownloading[index].value
                             ? const CircularProgressIndicator(color: ColorConst.primaryColor)
                             : InkWell(
                           onTap: () {
                             documentController.downloadDocument(context, index);
                           },
                           child: Container(
                             margin: const EdgeInsets.only(right: 10),
                             width: 25,
                             height: 25,
                             decoration: const BoxDecoration(
                               image: DecorationImage(
                                 image: AssetImage(ImageUtils.downloadIcon),
                               ),
                             ),
                           ),
                         ),
                       )),
                 ),
               ],
             );
           },
         ),
         // ListView.builder(
         //   itemCount: filterList.length,
         //   itemBuilder: (context, index) =>
         //       Card(child: Padding(
         //         padding: const EdgeInsets.all(10.0),
         //         child: Text('${filterList[index]}',style: TextStyle(fontSize: 16),),
         //       )),
         //
         // ),
       );
     }

   }
  }

}
