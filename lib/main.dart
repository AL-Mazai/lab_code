import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:homework_1/home.dart';
import 'package:homework_1/login-ai.dart';
import 'login.dart';

Dio dio = Dio(); // 创建一个Dio对象实例
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

void configureDio() {
  dio.options.baseUrl = 'http://localhost:8888';
  dio.options.connectTimeout = Duration(seconds: 15);
  dio.options.receiveTimeout = Duration(seconds: 15);
}