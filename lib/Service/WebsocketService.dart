import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:timtro/Model/Message.dart';
import 'package:timtro/utils/dimensions.dart';

class WebSocketService {
  StompClient? stompClient;
  final _messageStreamController = StreamController<Message>.broadcast();

  Stream<Message> get messageStream => _messageStreamController.stream;

  void connect(String userId) {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: '${API.link}/ws',
        onConnect: (frame) => onConnect(frame, userId),
        onWebSocketError: (error) => print('WebSocket error: $error'),
      ),
    );
    stompClient!.activate();
  }

  void onConnect(StompFrame frame, String userId) {
    stompClient!.subscribe(
      destination: '/topic/user/${userId}',
      callback: (frame) {
        if (frame.body != null) {
          // Chuyển frame.body từ JSON sang Message
          final messageData = frame.body;
          print("Received message: " + messageData! + " for receiver: " + userId);
          final message = Message.fromJson(jsonDecode(messageData));
          _messageStreamController.sink.add(message); // Thêm vào stream
        }
      },
    );
  }

  void sendMessage(Message message, String userId) {
    stompClient!.send(
      destination: '/app/chat.sendMessage/${userId}',
      body: jsonEncode(message.toJson()), // Chuyển sang JSON để gửi
    );
  }

  void dispose() {
    _messageStreamController.close();
    stompClient?.deactivate();
  }
}
