import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel createWebSocketChannel(String url) {
  if (kIsWeb) {
    return HtmlWebSocketChannel.connect(url);
  } else {
    return IOWebSocketChannel.connect(url);
  }
}
