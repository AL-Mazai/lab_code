// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
//
// import 'main.dart';
//
// // 模拟从后端获取数据的服务类
// class ChatService {
//   Future<List<ChatMessage>> fetchChatHistory() async {
//     // 模拟从后端获取的数据
//     await Future.delayed(Duration(seconds: 1)); // 模拟网络延迟
//
//     // 伪造一些测试数据，包括知识问答和科普类的对话
//     List<ChatMessage> messages = [
//       ChatMessage(
//         sender: 'User',
//         message: '你好，我想了解一下黑洞的形成过程。',
//         timestamp: DateTime.now().subtract(Duration(minutes: 5)),
//       ),
//       ChatMessage(
//         sender: 'AI',
//         message: '好的！黑洞的形成过程主要与恒星的演化有关。',
//         timestamp: DateTime.now().subtract(Duration(minutes: 4)),
//       ),
//       ChatMessage(
//         sender: 'User',
//         message: '恒星是如何形成的？',
//         timestamp: DateTime.now().subtract(Duration(minutes: 2)),
//       ),
//       ChatMessage(
//         sender: 'AI',
//         message: '恒星形成于星际云中的气体和尘埃凝聚。',
//         timestamp: DateTime.now().subtract(Duration(minutes: 1)),
//       ),
//       ChatMessage(
//         sender: 'User',
//         message: '地球上的日食是如何产生的？',
//         timestamp: DateTime.now().subtract(Duration(hours: 3)),
//       ),
//       ChatMessage(
//         sender: 'AI',
//         message: '日食是地球、月球和太阳的相对位置造成的现象。',
//         timestamp: DateTime.now().subtract(Duration(hours: 2)),
//       ),
//       ChatMessage(
//         sender: 'User',
//         message: '请问行星的形成过程是怎样的？',
//         timestamp: DateTime.now().subtract(Duration(days: 1)),
//       ),
//       ChatMessage(
//         sender: 'AI',
//         message: '行星形成于原行星盘中的物质聚集。',
//         timestamp: DateTime.now().subtract(Duration(days: 1, hours: 1)),
//       ),
//       ChatMessage(
//         sender: 'User',
//         message: '什么是量子力学？',
//         timestamp: DateTime.now().subtract(Duration(days: 7)),
//       ),
//       ChatMessage(
//         sender: 'AI',
//         message: '量子力学是描述微观世界中粒子行为的物理理论。',
//         timestamp: DateTime.now().subtract(Duration(days: 6)),
//       ),
//     ];
//
//     return messages;
//   }
// }
//
// // 历史对话记录的消息模型
// class ChatMessage {
//   final String sender;
//   final String message;
//   final DateTime timestamp;
//
//   ChatMessage({
//     required this.sender,
//     required this.message,
//     required this.timestamp,
//   });
// }
//
// // HomePage Widget
// class History extends StatelessWidget {
//   final ChatService chatService = ChatService();
//
//   final int userId = 1;
//
//   void getHistoryList(String userMessage) async {
//     try {
//       Response response = await dio.post(
//         '/record',
//         data: FormData.fromMap({'userId': userId}), // 将用户消息发送到服务器
//       );
//       String aiResponse = response.data['data'];
//       print(aiResponse);
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   // 根据日期分组消息
//   Map<String, List<ChatMessage>> groupMessagesByDate(List<ChatMessage> messages) {
//     Map<String, List<ChatMessage>> groupedMessages = {};
//
//     messages.forEach((message) {
//       // 使用 yyyy-MM-dd 格式化日期作为键
//       String dateKey = '${message.timestamp.year}-${message.timestamp.month}-${message.timestamp.day}';
//       if (groupedMessages.containsKey(dateKey)) {
//         groupedMessages[dateKey]!.add(message);
//       } else {
//         groupedMessages[dateKey] = [message];
//       }
//     });
//
//     return groupedMessages;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('历史会话'),
//       ),
//       body: FutureBuilder<List<ChatMessage>>(
//         future: chatService.fetchChatHistory(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('加载失败: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('没有历史记录'));
//           } else {
//             // 分组消息
//             Map<String, List<ChatMessage>> groupedMessages = groupMessagesByDate(snapshot.data!);
//
//             // 获取日期键排序的列表
//             List<String> sortedKeys = groupedMessages.keys.toList()
//               ..sort((a, b) => b.compareTo(a)); // 倒序排序，最新的日期在前
//
//             return ListView.builder(
//               itemCount: sortedKeys.length,
//               itemBuilder: (context, index) {
//                 String dateKey = sortedKeys[index];
//                 List<ChatMessage> messages = groupedMessages[dateKey]!;
//
//                 // 构建每个日期的列表
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       child: Text(
//                         dateKey,
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: messages.length,
//                       itemBuilder: (context, index) {
//                         final message = messages[index];
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           child: Card(
//                             elevation: 2,
//                             child: ExpansionTile(
//                               title: Text(
//                                 message.message,
//                                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               children: <Widget>[
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                                     children: <Widget>[
//                                       Text(
//                                         '发送者: ${message.sender}',
//                                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                                       ),
//                                       SizedBox(height: 8),
//                                       Text(
//                                         '时间: ${message.timestamp}',
//                                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                                       ),
//                                       SizedBox(height: 8),
//                                       Text(
//                                         '完整对话:',
//                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                                       ),
//                                       SizedBox(height: 4),
//                                       // 显示所有该条对话记录的消息
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                                         children: messages
//                                             .map((msg) => Text(
//                                           '${msg.sender}: ${msg.message}',
//                                           style: TextStyle(fontSize: 14),
//                                         ))
//                                             .toList(),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'main.dart';

// 模拟从后端获取数据的服务类
class ChatService {
  Future<List<ChatMessage>> fetchChatHistory(int userId) async {
    try {
      Response response = await dio.get(
        '/record',
        queryParameters: {'userId': userId},
      );

      print(response.data);

      List<dynamic> data = response.data;

      List<ChatMessage> messages = data.map((item) {
        return ChatMessage(
          sender: item['type'] == '问题' ? 'User' : 'AI',
          message: item['chatContent'],
          timestamp: DateTime.parse(item['createdTime']),
        );
      }).toList();

      return messages;
    } catch (e) {
      print('Error fetching chat history: $e');
      throw Exception('Failed to load chat history');
    }
  }
}

// 历史对话记录的消息模型
// 历史对话记录的消息模型
class ChatMessage {
  final String sender;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
  });
}

// HomePage Widget
class History extends StatelessWidget {
  final ChatService chatService = ChatService();
  final int userId = 1;

  // 根据日期分组消息
  Map<String, List<ChatMessage>> groupMessagesByDate(List<ChatMessage> messages) {
    Map<String, List<ChatMessage>> groupedMessages = {};

    messages.forEach((message) {
      // 使用 yyyy-MM-dd 格式化日期作为键
      String dateKey = '${message.timestamp.year}-${message.timestamp.month}-${message.timestamp.day}';
      if (groupedMessages.containsKey(dateKey)) {
        groupedMessages[dateKey]!.add(message);
      } else {
        groupedMessages[dateKey] = [message];
      }
    });

    return groupedMessages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('历史会话'),
      ),
      body: FutureBuilder<List<ChatMessage>>(
        future: chatService.fetchChatHistory(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('加载失败: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('没有历史记录'));
          } else {
            // 分组消息
            Map<String, List<ChatMessage>> groupedMessages = groupMessagesByDate(snapshot.data!);

            // 获取日期键排序的列表
            List<String> sortedKeys = groupedMessages.keys.toList()
              ..sort((a, b) => b.compareTo(a)); // 倒序排序，最新的日期在前

            return ListView.builder(
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                String dateKey = sortedKeys[index];
                List<ChatMessage> messages = groupedMessages[dateKey]!;

                // 构建每个日期的列表
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        dateKey,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Card(
                            elevation: 2,
                            child: ExpansionTile(
                              title: Text(
                                message.message,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(
                                        '发送者: ${message.sender}',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '时间: ${message.timestamp}',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '完整对话:',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      // 显示所有该条对话记录的消息
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: messages
                                            .map((msg) => Text(
                                          '${msg.sender}: ${msg.message}',
                                          style: TextStyle(fontSize: 14),
                                        ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}