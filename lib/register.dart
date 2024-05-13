import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'main.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册新用户'),
      ),
      body: RegisterForm(),
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

  bool _passwordsMatch = true;
  bool _viewPassword = true;
  bool _viewCheckPassword = true;

  //测试
  getUser(int id) async {
    Response response = await dio.get('/user/' + id.toString());
    return response;
  }

  //用户注册
  registerUser(RegistrationData registrationData) async {
    Response response =
        await dio.post('/user/register', data: registrationData.toJson());
    return response;
  }

  void showRegisterSuccess(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('注册成功！'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TextField and Button widgets
          TextField(
            controller: _nameController,
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
            controller: _emailController,
            decoration: InputDecoration(
              labelText: '邮箱',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
              isDense: true,
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: '电话号码',
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
              suffixIcon: IconButton(
                icon: Icon(
                  _viewPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _viewPassword = !_viewPassword;
                  });
                },
              ),
            ),
            obscureText: _viewPassword,
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: '确认密码',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
              isDense: true,
              suffixIcon: IconButton(
                icon: Icon(
                  _viewCheckPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _viewCheckPassword = !_viewCheckPassword;
                  });
                },
              ),
              errorText: _passwordsMatch ? null : '两次输入的密码不匹配',
            ),
            obscureText: _viewCheckPassword,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              if (_passwordController.text != _confirmPasswordController.text) {
                setState(() {
                  _passwordsMatch = false;
                });
              } else {
                setState(() {
                  _passwordsMatch = true;
                });
                print(_nameController.value.toString());
                // 创建注册数据对象
                RegistrationData registrationData = RegistrationData(
                  userName: _nameController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
                  phone: _phoneController.text,
                );
                await registerUser(registrationData);

                showRegisterSuccess(context);
                Navigator.pop(context); // 返回到登录页面
              }
            },
            child: Text('注册'),
          ),
        ],
      ),
    );
  }
}

class RegistrationData {
  String userName;
  String email;
  String password;
  String phone;

  RegistrationData({
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
