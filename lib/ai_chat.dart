import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'main.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> _messages = []; // 用于存储消息的列表
  final TextEditingController _controller = TextEditingController(); // 用于控制输入框的控制器

  // 处理用户提交消息的方法
  void _handleSubmitted(String text) {
    _controller.clear(); // 清空输入框
    Message message = Message(
      text: text,
      isUserMessage: true, // 标记为用户消息
    );
    setState(() {
      _messages.insert(0, message); // 将用户消息插入到消息列表的顶部
    });
    _getResponse(text); // 调用方法获取AI的响应
  }

  // 获取AI响应的方法
  void _getResponse(String userMessage) async {
    try {
      Response response = await dio.post(
        '/gpt/zhipu',
        data: userMessage, // 将用户消息发送到服务器
      );
      String aiResponse = response.data['data']; // 假设响应数据格式为 { "data": "AI response" }
      Message message = Message(
        text: aiResponse,
        isUserMessage: false, // 标记为AI消息
      );
      setState(() {
        _messages.insert(0, message); // 将AI消息插入到消息列表的顶部
      });
    } catch (e) {
      print('Error: $e'); // 捕捉并打印错误
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Chat'), // 应用栏标题
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true, // 反转列表，使最新消息显示在顶部
              itemBuilder: (_, int index) => _messages[index], // 构建消息项
              itemCount: _messages.length, // 消息项数量
            ),
          ),
          Divider(height: 1.0), // 分割线
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // 背景色
            ),
            child: _buildTextComposer(), // 构建消息输入框
          ),
        ],
      ),
    );
  }

  // 构建消息输入框
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary), // 图标主题颜色
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _controller,
                onSubmitted: _handleSubmitted, // 提交消息时调用的方法
                decoration: InputDecoration.collapsed(hintText: '有什么问题尽管问我'), // 输入框提示
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send), // 发送按钮图标
                onPressed: () => _handleSubmitted(_controller.text), // 按下按钮时提交消息
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 消息类，用于构建消息项
class Message extends StatelessWidget {
  final String text; // 消息文本
  final bool isUserMessage; // 是否是用户消息

  Message({required this.text, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
        isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start, // 根据消息类型调整对齐方式
        children: <Widget>[
          if (!isUserMessage)
            CircleAvatar(
              child: Text('AI'), // AI头像
            ),
          Container(
            margin: isUserMessage
                ? EdgeInsets.only(left: 8.0)
                : EdgeInsets.only(right: 8.0),
            child: Column(
              crossAxisAlignment: isUserMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start, // 根据消息类型调整对齐方式
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(fontSize: 16.0), // 消息文本样式
                ),
              ],
            ),
          ),
          if (isUserMessage)
            CircleAvatar(
              child: Text('User'), // 用户头像
            ),
        ],
      ),
    );
  }
}
