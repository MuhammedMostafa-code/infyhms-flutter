import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:infyhms_flutter/firebase_options.dart';
import 'package:infyhms_flutter/screens/patient/auth/reset_password_screen.dart';
import 'package:infyhms_flutter/screens/patient/welcome/splash_screen.dart';
import 'package:infyhms_flutter/utils/preference_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة التفضيلات
  PreferenceUtils.init();

  // تهيئة Flutter Downloader
  await FlutterDownloader.initialize(
    debug: true, // لتفعيل طباعة السجلات إلى وحدة التحكم
    ignoreSsl: true, // للسماح بالعمل مع الروابط غير الآمنة (HTTP)
  );

  // تهيئة Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // إنشاء مثيل لـ Firebase Analytics
  FirebaseAnalytics.instance;

  // تعيين الاتجاه الرأسي فقط
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
        (_) {
      runApp(const MyApp());
    },
  );
}

// تعريف الكلاس MyApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // إخفاء شريط الوضع التجريبي
      title: 'InfyHMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // شاشة البداية
    );
  }
}





// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:infyhms_flutter/firebase_options.dart';
// import 'package:infyhms_flutter/screens/patient/auth/reset_password_screen.dart';
// import 'package:infyhms_flutter/screens/patient/welcome/splash_screen.dart';
// import 'package:infyhms_flutter/utils/preference_utils.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   PreferenceUtils.init();
//   await FlutterDownloader.initialize(
//       debug: true, // optional: set to false to disable printing logs to console (default: true)
//       ignoreSsl: true // option: set to false to disable working with http links (default: false)
//   );
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   FirebaseAnalytics.instance;
//   // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
//         (_) {
//       runApp(const MyApp());
//     },
//   );
//
//
//   //   debugShowCheckedModeBanner: false,
//   //   home: const SplashScreen(),
//   // );
// }