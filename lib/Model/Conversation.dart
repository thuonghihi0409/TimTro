import 'package:timtro/Model/User.dart';

class Conversation {
  String conversationId;
  User user1;
  User user2;

  // Constructor
  Conversation({
    required this.conversationId,
    required this.user1,
    required this.user2,
  });

  // Phương thức để xóa cuộc trò chuyện
  void deleteConversation() {
    // Logic để xóa cuộc trò chuyện
    print("Conversation with ID: $conversationId has been deleted.");
  }

  // Phương thức để tạo cuộc trò chuyện
  void createConversation() {
    // Logic để tạo cuộc trò chuyện
    print("Conversation created between: ${user1.username} and ${user2.username}");
  }

  @override
  String toString() {
    return 'Conversation{conversationId: $conversationId, user1: ${user1.username}, user2: ${user2.username}}';
  }
}


