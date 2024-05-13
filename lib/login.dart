import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'main.dart';
import 'register.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: LoginForm(),
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

  //用户登录
  login(LoginData loginData) async {
    Response response = await dio.post('/user/login', data: loginData.toJson());
    // print(response.data['data']);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (response.data['code'] == 200) {
      await prefs.setString('userInfo', jsonEncode(response.data['data']));
      showLoginSuccess(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      showLoginFail(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: '用户名',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
              isDense: true,
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: '密码',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
              isDense: true,
            ),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              // 创建注册数据对象
              LoginData loginData = LoginData(
                userName: _usernameController.text,
                password: _passwordController.text,
              );
              // 调用注册函数
              await login(loginData);

              _usernameController.clear();
              _passwordController.clear();
            },
            child: Text('登录'),
          ),
          TextButton(
            onPressed: () {
              // 跳转到注册页面
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            },
            child: Text('注册新用户'),
          ),
        ],
      ),
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
