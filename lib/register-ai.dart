import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login-ai.dart';
import 'main.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void showRegisterSuccess(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('注册成功！'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showRegisterFail(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('注册失败'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  register(RegisterData registerData) async {
    try {
      Response response =
          await dio.post('/user/register', data: registerData.toJson());

      if (response.data['code'] == 200) {
        showRegisterSuccess(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        showRegisterFail(context);
      }
    } catch (e) {
      print(e);
      showRegisterFail(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Text(
            'AI Chat',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
          SizedBox(height: 20),
          Image.network(
            'http://qny.cai142857.cn/ai.png', // 在这里替换为实际的图片链接
            height: 150,
            width: 300,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 60),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF4754C5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '用户名',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: '邮箱',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '密码',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '确认密码',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      showRegisterFail(context);
                      return;
                    }
                    RegisterData registerData = RegisterData(
                      userName: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      phone: _phoneController.text,
                    );
                    await register(registerData);

                    _nameController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[100], // 背景颜色
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('注册'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 注册实体
class RegisterData {
  String userName;
  String email;
  String password;
  String phone;

  RegisterData({
    required this.userName,
    required this.email,
    required this.password,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'phone': phone
    };
  }
}
