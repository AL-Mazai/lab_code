import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'create_websocket.dart';

class WebSocketChatPage extends StatefulWidget {
  @override
  _WebSocketChatPageState createState() => _WebSocketChatPageState();
}

class _WebSocketChatPageState extends State<WebSocketChatPage> {
  final TextEditingController _controller = TextEditingController();
  final WebSocketChannel _channel = createWebSocketChannel('ws://localhost:8888/gpt-stream');
  List<String> _messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPT WebSocket Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '请输入问题...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ),
              onSubmitted: (text) => _sendMessage(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: StreamBuilder(
                  stream: _channel.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _messages.add(snapshot.data);
                    }
                    return ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_messages[index]),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
