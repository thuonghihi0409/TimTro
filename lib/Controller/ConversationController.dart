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

    // Sử dụng vòng lặp for để cập nhật lastMessage
    for (var toElement in conversations) {
      toElement.lastMessage = await messageservice.lastMessage(toElement.conversationId);
    }

    notifyListeners();
  }

  Future<Conversation?> newConversation (Conversation con) async {
    Conversation? conversation = await conversationService.sendConversation(con);
    notifyListeners();
    return conversation;

  }
}