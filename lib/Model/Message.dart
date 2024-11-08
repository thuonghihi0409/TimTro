import 'package:timtro/Model/Conversation.dart';
import 'package:timtro/Model/User.dart';

class Message {
  String messageId;
  String content;
  String messageStatus;
  DateTime timesend;
  Conversation conversation;
  User user;

  Message({
    required this.messageId,
    required this.content,
    required this.messageStatus,
    required this.timesend,
    required this.conversation,
    required this.user,
  });

  // Phương thức chuyển đổi đối tượng Message thành JSON
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'content': content,
      'messageStatus': messageStatus,
      'timesend': timesend.toIso8601String(),
      'conversationId': conversation.conversationId,
      'userId': user.id,
    };
  }

  // Phương thức tạo đối tượng Message từ JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    print("9999999999999999999999999999999999999999999999999" + DateTime.parse(json['timesend']).toUtc().toString());
    return Message(
      messageId: json['messageId'],
      content: json['content'],
      messageStatus: json['messageStatus'],
      timesend: DateTime.parse(json['timesend']).toUtc(),
      conversation: Conversation.fromJson(json['conversation']),
      user: User.fromJson(json['user']),
    );
  }
}
