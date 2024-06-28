// import 'dart:convert';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert' as convert;
//
// import 'main.dart';
//
// class UserInfo extends StatefulWidget {
//   @override
//   _UserInfoState createState() => _UserInfoState();
// }
//
// class _UserInfoState extends State<UserInfo> {
//   Map<String, dynamic> userInfo = {};
//
//   @override
//   void initState() {
//     super.initState();
//     loadUserInfo();
//   }
//
//   Future<void> loadUserInfo() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userInfoString = prefs.getString('userInfo');
//     print(userInfoString);
//     if (userInfoString != null) {
//       setState(() {
//         userInfo = jsonDecode(userInfoString);
//       });
//     }
//   }
//
//   void updateUserInfoSuccess(BuildContext context) {
//     final snackBar = SnackBar(
//       content: Text('保存成功！'),
//       duration: Duration(seconds: 1),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   void updateUserInfoFail(BuildContext context) {
//     final snackBar = SnackBar(
//       content: Text('保存失败'),
//       duration: Duration(seconds: 1),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   updateUserInfo() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     EditUserInfo editUserInfo = new EditUserInfo(
//         userId: userInfo['userId'],
//         userName: userInfo['userName'],
//         phone: userInfo['phone'],
//         address: userInfo['address'],
//         email: userInfo['email'],
//         nickName: userInfo['nickName']);
//
//     // print(editUserInfo.toJson());
//     // 尝试将 JSON 字符串解析为 Map
//     Response response =
//         await dio.post('/user/updateUserInfo', data: editUserInfo.toJson());
//     if (response.data['code'] == 200) {
//       prefs.setString("userInfo", jsonEncode(userInfo));
//     }
//   }
//
//   String getSexDisplay(int sex) {
//     return sex == 0 ? "男性" : "女性";
//   }
//
//   void _editUserInfo(String key, String currentValue) async {
//     TextEditingController textEditingController =
//         TextEditingController(text: currentValue);
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("修改$key"),
//           content: TextField(
//             controller: textEditingController,
//             decoration: InputDecoration(
//               labelText: "请输入新的$key",
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("取消"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   userInfo[key] = textEditingController.text; // 更新数据
//                 });
//
//                 updateUserInfo();
//                 Navigator.of(context).pop();
//               },
//               child: Text("保存"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: userInfo.isNotEmpty
//           ? Column(
//               children: <Widget>[
//                 SizedBox(height: 20),
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundImage: AssetImage("images/avatar/1.png"),
//                   // Example placeholder image
//                   backgroundColor: Colors.grey[200],
//                 ),
//                 SizedBox(height: 20),
//                 Expanded(
//                   child: ListView(
//                     children: <Widget>[
//                       UserInfoCard(
//                         title: "用户名",
//                         subtitle: userInfo['userName'] ?? '未设置',
//                         icon: Icons.person,
//                         onEdit: () => _editUserInfo(
//                             'userName', userInfo['userName'] ?? ''),
//                       ),
//                       // UserInfoCard(
//                       //   title: "年龄",
//                       //   subtitle: userInfo['age'].toString() ?? '未设置',
//                       //   icon: Icons.cake,
//                       //   onEdit: () =>
//                       //       _editUserInfo('age', userInfo['age'] ?? ''),
//                       // ),
//                       UserInfoCard(
//                         title: "地址",
//                         subtitle: userInfo['address'] ?? '未设置',
//                         icon: Icons.map,
//                         onEdit: () =>
//                             _editUserInfo('address', userInfo['address'] ?? ''),
//                       ),
//                       UserInfoCard(
//                         title: "电子邮件",
//                         subtitle: userInfo['email'] ?? '未设置',
//                         icon: Icons.email,
//                         onEdit: () =>
//                             _editUserInfo('email', userInfo['email'] ?? ''),
//                       ),
//                       UserInfoCard(
//                         title: "电话",
//                         subtitle: userInfo['phone'] ?? '未设置',
//                         icon: Icons.phone,
//                         onEdit: () =>
//                             _editUserInfo('phone', userInfo['phone'] ?? ''),
//                       ),
//                       // UserInfoCard(
//                       //   title: "性别",
//                       //   subtitle: getSexDisplay(userInfo['sex'] ?? 0),
//                       //   icon: Icons.transgender,
//                       //   onEdit: () =>
//                       //       _editUserInfo('sex', userInfo['sex'] ?? ''),
//                       // ),
//                       UserInfoCard(
//                         title: "昵称",
//                         subtitle: userInfo['nickName'] ?? '未设置',
//                         icon: Icons.badge,
//                         onEdit: () => _editUserInfo(
//                             'nickName', userInfo['nickName'] ?? ''),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           : Center(
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }
//
// class UserInfoCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final VoidCallback onEdit;
//
//   const UserInfoCard({
//     Key? key,
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.onEdit,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: ListTile(
//         title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(subtitle),
//         leading: CircleAvatar(
//           backgroundColor: Colors.blue.shade100,
//           child: Icon(icon, color: Colors.blue.shade800),
//         ),
//         trailing: IconButton(
//           icon: Icon(Icons.edit),
//           onPressed: onEdit,
//         ),
//       ),
//     );
//   }
// }
//
// class EditUserInfo {
//   int userId;
//   String userName;
//   String email;
//   String phone;
//   String address;
//   String nickName;
//
//   EditUserInfo(
//       {required this.userName,
//       required this.phone,
//       required this.address,
//       required this.email,
//       required this.userId,
//       required this.nickName});
//
//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'userName': userName,
//       'email': email,
//       'phone': phone,
//       'address': address,
//       'nickName': nickName
//     };
//   }
// }
//
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoString = prefs.getString('userInfo');
    print(userInfoString);
    if (userInfoString != null) {
      setState(() {
        userInfo = jsonDecode(userInfoString);
      });
    }
  }

  void updateUserInfoSuccess(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('保存成功！'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateUserInfoFail(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('保存失败'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  updateUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    EditUserInfo editUserInfo = EditUserInfo(
        userId: userInfo['userId'],
        userName: userInfo['userName'],
        phone: userInfo['phone'],
        address: userInfo['address'],
        email: userInfo['email'],
        nickName: userInfo['nickName']);

    Response response =
    await dio.post('/user/updateUserInfo', data: editUserInfo.toJson());
    if (response.data['code'] == 200) {
      prefs.setString("userInfo", jsonEncode(userInfo));
    }
  }

  String getSexDisplay(int sex) {
    return sex == 0 ? "男性" : "女性";
  }

  void _editUserInfo(String key, String currentValue) async {
    TextEditingController textEditingController =
    TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("修改$key"),
          content: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              labelText: "请输入新的$key",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("取消"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  userInfo[key] = textEditingController.text; // 更新数据
                });

                updateUserInfo();
                Navigator.of(context).pop();
              },
              child: Text("保存"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userInfo.isNotEmpty
          ? Column(
        children: <Widget>[
          SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage("images/avatar/1.png"),
            backgroundColor: Colors.grey[200],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: <Widget>[
                UserInfoCard(
                  title: "用户名",
                  subtitle: userInfo['userName'] ?? '未设置',
                  icon: Icons.person,
                  onEdit: () => _editUserInfo(
                      'userName', userInfo['userName'] ?? ''),
                ),
                UserInfoCard(
                  title: "地址",
                  subtitle: userInfo['address'] ?? '未设置',
                  icon: Icons.map,
                  onEdit: () =>
                      _editUserInfo('address', userInfo['address'] ?? ''),
                ),
                UserInfoCard(
                  title: "电子邮件",
                  subtitle: userInfo['email'] ?? '未设置',
                  icon: Icons.email,
                  onEdit: () =>
                      _editUserInfo('email', userInfo['email'] ?? ''),
                ),
                UserInfoCard(
                  title: "电话",
                  subtitle: userInfo['phone'] ?? '未设置',
                  icon: Icons.phone,
                  onEdit: () =>
                      _editUserInfo('phone', userInfo['phone'] ?? ''),
                ),
                UserInfoCard(
                  title: "昵称",
                  subtitle: userInfo['nickName'] ?? '未设置',
                  icon: Icons.badge,
                  onEdit: () => _editUserInfo(
                      'nickName', userInfo['nickName'] ?? ''),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 200, // 设置图表高度
                    child: LineChartSample(),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onEdit;

  const UserInfoCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue.shade800),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ),
    );
  }
}

class EditUserInfo {
  int userId;
  String userName;
  String email;
  String phone;
  String address;
  String nickName;

  EditUserInfo({
    required this.userName,
    required this.phone,
    required this.address,
    required this.email,
    required this.userId,
    required this.nickName,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'phone': phone,
      'address': address,
      'nickName': nickName,
    };
  }
}

class LineChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 1),
              FlSpot(1, 3),
              FlSpot(6, 10),
              FlSpot(9, 7),
              FlSpot(13, 12),
            ],
            isCurved: true,
            barWidth: 4,
            color: Colors.blue,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toString(), style: TextStyle(color: Colors.black, fontSize: 10));
              },
              interval: 1,
              reservedSize: 30,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toString(), style: TextStyle(color: Colors.black, fontSize: 10));
              },
              interval: 1,
              reservedSize: 30,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
      ),
    );
  }
}
