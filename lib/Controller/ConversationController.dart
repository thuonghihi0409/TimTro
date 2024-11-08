import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timtro/Controller/MessageController.dart';
import 'package:timtro/Model/Conversation.dart';
import 'package:timtro/Model/Message.dart';
import 'package:timtro/Service/ConversationSerVice.dart';
import 'package:timtro/Service/MessageService.dart';

class Conversationcontroller with ChangeNotifier {
  List<Conversation> conversations = [];
  ConversationService conversationService = ConversationService();
  Messageservice messageservice = Messageservice();

  Future<void> loadConversation(String userId) async {
    conversations = await conversationService.fetchConversation(userId);

    // Cập nhật lastMessage cho từng Conversation
    for (int i = 0; i < conversations.length; i++) {
      conversations[i].lastMessage = await messageservice.lastMessage(conversations[i].conversationId);
    }

    // Sắp xếp conversations theo timesend của lastMessage (gần nhất đến xa nhất)
    sortConversationsByLastMessage();

    notifyListeners();
  }

  void sortConversationsByLastMessage() {
    conversations.sort((a, b) {
      DateTime? timeA = a.lastMessage?.timesend;
      DateTime? timeB = b.lastMessage?.timesend;
      if (timeA == null && timeB == null) return 0;
      if (timeA == null) return 1;
      if (timeB == null) return -1;
      return timeB.compareTo(timeA); // Sắp xếp mới nhất lên đầu
    });
    notifyListeners();
  }
  void updateLastMessage(String conversationId, Message lastMessage) {
    // Tìm cuộc trò chuyện và cập nhật lastMessage
    for (var conversation in conversations) {
      if (conversation.conversationId == conversationId) {
        conversation.lastMessage = lastMessage;
        break;
      }
    }
    // Sắp xếp lại danh sách
    sortConversationsByLastMessage();
  }
  Future<Conversation?> newConversation (Conversation con) async {
    Conversation? conversation = await conversationService.sendConversation(con);
    notifyListeners();
    return conversation;

  }
}
