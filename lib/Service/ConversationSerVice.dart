import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timtro/Model/Conversation.dart';
import 'package:timtro/utils/dimensions.dart';

class ConversationService {
  // Hàm đọc dữ liệu từ API
  Future<List<Conversation>> fetchConversation(String userId) async {
    final url = Uri.parse('${API.link}/conversation/userId=$userId');
    try {
      final response = await http.get(url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        // Chuyển đổi từng phần tử trong danh sách JSON thành đối tượng Conversation
        return data.map((json) => Conversation.fromJson(json)).toList();
      } else {
        print('Failed to load conversation');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }


  // Hàm gửi dữ liệu đến API
  Future<Conversation?> sendConversation(Conversation conversation) async {
    final url = Uri.parse('${API.link}/conversation');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(conversation.toJson()),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Chuyển đổi từng phần tử trong danh sách JSON thành đối tượng Conversation
        return Conversation.fromJson(data);
      } else {
        print('Failed to load conversation');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
