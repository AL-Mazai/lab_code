import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:homework_1/register-ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'main.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void showLoginSuccess(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('登录成功！'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showLoginFail(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('登录失败'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  login(LoginData loginData) async {
    try {
      Response response = await dio.post('/user/login', data: loginData.toJson());
      print(response.data['code'] == 200);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.data['code'] == 200) {
        await prefs.setString('userInfo', jsonEncode(response.data['data']));
        showLoginSuccess(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        showLoginFail(context);
      }
    } catch (e) {
      print(e);
      showLoginFail(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
              TextField(
                controller: _usernameController,
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
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  LoginData loginData = LoginData(
                    userName: _usernameController.text,
                    password: _passwordController.text,
                  );
                  await login(loginData);

                  _usernameController.clear();
                  _passwordController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[100], // 背景颜色
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('登陆'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // 忘记密码的操作
                    },
                    child: Text(
                      '忘记密码',
                      style: TextStyle(
                        color: Colors.green,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      // 注册账户的操作
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      '注册账户',
                      style: TextStyle(
                        color: Colors.green,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 登录实体
class LoginData {
  String userName;
  String password;

  LoginData({
    required this.userName,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
    };
  }
}