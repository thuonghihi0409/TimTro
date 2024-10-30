import 'dart:convert';

import 'package:timtro/Model/Message.dart';
import 'package:timtro/utils/dimensions.dart';
import 'package:http/http.dart' as http;
class Messageservice {
  Future<List<Message>> fetchMessage(String conversationId) async {
    final url = Uri.parse('${API.link}/message/conversationId=$conversationId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'}, // Thêm charset vào header
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        // Chuyển đổi từng phần tử trong danh sách JSON thành đối tượng Message
        return data.map((json) => Message.fromJson(json)).toList();
      } else {
        print('Failed to load message');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Hàm gửi dữ liệu đến API
  Future<Message?> sendMessage(Message message) async {
    final url = Uri.parse('${API.link}/message');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'}, // Thêm charset vào header
        body: json.encode(message.toJson()),
      );
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return Message.fromJson(data);
      } else {
        print('Failed to send message');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Message?> lastMessage(String conversationId) async {
    final url = Uri.parse('${API.link}/message/lastmessage/conversationId=$conversationId');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'}, // Thêm charset vào header
      );
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return Message.fromJson(data);
      } else {
        print('Failed to load last message');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}