import 'package:flutter/material.dart';
import 'package:homework_1/todolist.dart';
import 'home_page.dart'; // 引入HomePage
import 'map.dart';
import 'user_info.dart'; // 引入ProfilePage

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomePage(),
    // LocationView(),
    ToDoListPage(),
    UserInfo(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('主界面'),
      // ),
      body: _children[_currentIndex],
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: '首页',
            ),
            // BottomNavigationBarItem(
            //   icon: new Icon(Icons.location_city),
            //   label: '地图',
            // ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.work),
              label: '待办',
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              label: '个人中心',
            ),
          ],
        ),
      ),
    );
  }
}
