import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:homework_1/home.dart';
import 'package:homework_1/login-ai.dart';
import 'login.dart';
import 'dart:async';
import 'package:homework_1/components/HideKeyboard.dart';
import 'package:homework_1/page/AppOpenPage.dart';
import 'package:homework_1/stores/AIChatStore.dart';
import 'package:flutter/material.dart';
import 'package:homework_1/utils/Chatgpt.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Dio dio = Dio(); // 创建一个Dio对象实例
void configureDio() {
  dio.options.baseUrl = 'http://localhost:8888';
  dio.options.connectTimeout = Duration(seconds: 15);
  dio.options.receiveTimeout = Duration(seconds: 15);
}

void main() {
  configureDio();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: LoginScreen(),
      home: Home(),
    );
  }
}

// void main() async {
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.black,
//   ));
//   await dotenv.load(fileName: ".env");
//
//   await GetStorage.init();
//   await ChatGPT.initChatGPT();
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => AIChatStore(),
//       child: const MyApp(),
//     ),
//   );
//   configLoading();
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return HideKeyboard(
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           scaffoldBackgroundColor: Colors.white,
//           brightness: Brightness.light,
//         ),
//         home: const SplashPage(),
//         builder: EasyLoading.init(),
//       ),
//     );
//   }
// }
//
// Future<void> configLoading() async {
//   EasyLoading.instance
//     ..maskType = EasyLoadingMaskType.none
//     ..loadingStyle = EasyLoadingStyle.dark
//     ..indicatorSize = 45.0
//     ..radius = 10.0
//     ..displayDuration = const Duration(milliseconds: 1000)
//     ..userInteractions = false;
// }

