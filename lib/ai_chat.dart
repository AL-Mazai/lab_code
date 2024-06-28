import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'create_websocket.dart';
import 'main.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> _messages = []; // 存储消息的列表
  final List<Message> _messages_two = []; // 多模型输出

  final int userId = 1;

  final TextEditingController _controller =
      TextEditingController(); // 控制输入框的控制器
  WebSocketChannel? _channel;

  bool _isMultiModelOut = false; //用于控制多模型输出
  bool _isStreaming = false; // 用于控制传输模式的开关
  String _modelType = '智普'; // 选择大模型种类

  @override
  void initState() {
    super.initState();
    _initializeTongYiWebSocket();
  }
  // 通义：WebSocket实现流式传输
  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      _channel?.sink.add(message);
    }
  }
  @override
  void dispose() {
    _channel?.sink.close();
    _controller.dispose();
    super.dispose();
  }
  //通义
  void _initializeTongYiWebSocket() {
    _channel = createWebSocketChannel('ws://localhost:8888/gpt-stream');
    _channel?.stream.listen((message) {
      print("Received: $message"); // 调试输出
      Message aiMessage = Message(
        text: message,
        isUserMessage: false,
      );
      setState(() {
        _messages.insert(0, aiMessage);
      });
    }, onError: (error) {
      print("WebSocket Error: $error"); // 调试输出
    }, onDone: () {
      print("WebSocket closed"); // 调试输出
    });
  }

  // 智普
  void _getZhiPuResponse(String userMessage) async {
    try {
      Response response = await dio.post(
        '/gpt/zhipu',
          data: FormData.fromMap({'message': userMessage, 'userId': userId}), // 将用户消息发送到服务器
      );
      String aiResponse = response.data['data'];
      Message message = Message(
        text: aiResponse,
        isUserMessage: false, // 标记为AI消息
      );
      setState(() {
        _messages.insert(0, message); // 将AI消息插入到消息列表的顶部
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // 通义
  void _getTongYiResponse(String userMessage) async {
    try {
      Response response = await dio.post(
        '/gpt/tongyi',
          data: FormData.fromMap({'message': userMessage, 'userId': userId}), // 将用户消息发送到服务器
      );
      String aiResponse = response.data['data'];
      Message message = Message(
        text: aiResponse,
        isUserMessage: false, // 标记为AI消息
      );
      setState(() {
        _messages.insert(0, message); // 将AI消息插入到消息列表的顶部
      });
    } catch (e) {
      print('Error: $e');
    }
  }


  /**
   * 多模型
   */
  void _getOne(String userMessage) async {
    try {
      Response response = await dio.post(
        '/gpt/tongyi',
        data: FormData.fromMap({'message': userMessage, 'userId': userId}), // 将用户消息发送到服务器
      );
      String aiResponse = response.data['data'];
      Message message = Message(
        text: aiResponse,
        isUserMessage: false, // 标记为AI消息
      );
      setState(() {
        _messages.insert(0, message); // 将AI消息插入到消息列表的顶部
      });
    } catch (e) {
      print('Error: $e');
    }
  }
  void _getTwo(String userMessage) async {
    try {
      Response response = await dio.post(
        '/gpt/zhipu',
          data: FormData.fromMap({'message': userMessage, 'userId': userId}), // 将用户消息发送到服务器
      );
      String aiResponse = response.data['data'];
      Message message = Message(
        text: aiResponse,
        isUserMessage: false, // 标记为AI消息
      );
      setState(() {
        _messages_two.insert(0, message); // 将AI消息插入到消息列表的顶部
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // 处理用户提交的消息
  void _handleSubmitted(String text) {
    _controller.clear(); // 清空输入框
    Message message = Message(
      text: text,
      isUserMessage: true, // 标记为用户消息
    );

    if(!_isMultiModelOut){
      setState(() {
        _messages.insert(0, message); // 将用户消息插入到消息列表的顶部
      });
      if (_isStreaming) {
        _sendMessage(text);
      } else {
        if (_modelType == "智普") {
          _getZhiPuResponse(text);
        } else if (_modelType == "通义千问") {
          _getTongYiResponse(text);
        }
      }
    }else{
      setState(() {
        _messages.insert(0, message); // 将用户消息插入到消息列表的顶部
      });
      setState(() {
        _messages_two.insert(0, message); // 将用户消息插入到消息列表的顶部
      });
      _getOne(text);
      _getTwo(text);
    }

  }

  //VIP功能
  void _VIPFunction() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('VIP选项'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _isMultiModelOut,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isMultiModelOut = newValue!;
                          });
                        },
                      ),
                      Text('多模型输出'),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('关闭'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Chat'),
        actions: [
          // 添加下拉选择框
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.blue),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _modelType, // 当前选中的值
                icon: Icon(Icons.arrow_downward, color: Colors.blue, size: 16), // 调整图标大小
                onChanged: (String? newValue) {
                  setState(() {
                    // 当选中的值改变时更新_selectedModel
                    _modelType = newValue!;
                    // 根据选中的模型进行相应操作，例如重新初始化WebSocket
                    _initializeTongYiWebSocket();
                  });
                },
                items: <String>['通义千问', '智普'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: _modelType == value ? Colors.blue[100] : Colors.white,
                      ),
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }).toList(),
                isDense: true, // 调整下拉菜单高度
                dropdownColor: Colors.white, // 下拉菜单背景色
                selectedItemBuilder: (BuildContext context) {
                  return <String>['通义千问', '智普'].map<Widget>((String value) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
          // 流式选择
          Switch(
            value: _isStreaming,
            onChanged: (value) {
              setState(() {
                _isStreaming = value;
              });
            },
            activeColor: Colors.green,
            inactiveThumbColor: Colors.red,
            inactiveTrackColor: Colors.red[200],
          ),
          Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: Center(
              child: Text(_isStreaming ? 'Streaming' : 'One-Time'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _VIPFunction,
          ),
        ],
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
          Divider(height: 1.0),
          if (_isMultiModelOut) // 如果启用多模型输出，则添加一个新的列表视图
            Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: true, // 反转列表，使最新消息显示在顶部
                  itemBuilder: (_, int index) => _messages_two[index], // 构建消息项
                  itemCount: _messages_two.length, // 消息项数量
                ),
              ),
          Divider(height: 1.0), // 分割线
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // 背景色
            ),
            child: _buildTextComposer(), // 消息输入框
          ),
        ],
      ),
    );
  }

  // 构建消息输入框
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(
          color: Theme.of(context).colorScheme.secondary), // 图标主题颜色
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _controller,
                onSubmitted: _handleSubmitted, // 提交消息时调用的方法
                decoration:
                    InputDecoration.collapsed(hintText: '有什么问题尽管问我'), // 输入框提示
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send), // 发送按钮图标
                onPressed: () =>
                    _handleSubmitted(_controller.text), // 按下按钮时提交消息
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
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        // 根据消息类型调整对齐方式
        children: <Widget>[
          if (!isUserMessage)
            CircleAvatar(
              child: Text('AI'), // AI头像
            ),
          if (!isUserMessage) SizedBox(width: 4.0), // 增加间距
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:
                  MediaQuery.of(context).size.width * 0.7, // 限制最大宽度为屏幕宽度的70%
            ),
            child: Container(
              margin: isUserMessage
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
              padding: EdgeInsets.all(10.0), // 添加内边距
              decoration: BoxDecoration(
                color: isUserMessage ? Colors.blue[100] : Colors.green[100],
                // 根据消息类型设置背景色
                borderRadius: BorderRadius.circular(10.0), // 设置圆角
              ),
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
          ),
          if (isUserMessage) SizedBox(width: 4.0), // 增加间距
          if (isUserMessage)
            CircleAvatar(
              child: Text('User'), // 用户头像
            ),
        ],
      ),
    );
  }
}
