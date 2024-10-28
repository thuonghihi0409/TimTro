import 'package:timtro/Model/Message.dart';
import 'package:timtro/Model/User.dart';

class Conversation {
  String conversationId;
  User user1;
  User user2;
  Message? lastMessage ;
  // Constructor
  Conversation({
    required this.conversationId,
    required this.user1,
    required this.user2,
  });

  // From JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationId: json['conversationId'],
      user1: User.fromJson(json['user1']),
      user2: User.fromJson(json['user2']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'user1Id': user1.id,
      'user2Id': user2.id,
    };
  }
}
