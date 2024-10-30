import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:intl/intl.dart"; // Nhập thư viện intl để định dạng thời gian
import 'package:timtro/Model/Conversation.dart';
import 'package:timtro/Model/Message.dart';
import 'package:timtro/Model/User.dart';
import 'package:timtro/Controller/MessageController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Service/WebsocketService.dart';

class ChatScreen extends StatefulWidget {
  final Conversation? conversation;

  ChatScreen({super.key, required this.conversation});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final WebSocketService _webSocketService = WebSocketService();
@override
void initState() {
  super.initState();
  final messcontroller = Provider.of<Messagecontroller>(context, listen: false);
  final usercontroller = Provider.of<Usercontroller>(context, listen: false);
  messcontroller.loadMessage(widget.conversation!.conversationId).then((_) {
    _scrollToBottom();
  });
  _webSocketService.connect(usercontroller.user!.id);
  // Lắng nghe tin nhắn mới từ WebSocket
  _webSocketService.messageStream.listen((Message message) {
    messcontroller.messages.add(message);
    messcontroller.updateUI();// Thêm tin nhắn vào danh sách
    _scrollToBottom();
  });
}

  void _sendMessage(Messagecontroller mess) {
    if (_controller.text.isNotEmpty) {
      final usercontroller = Provider.of<Usercontroller>(context, listen: false);
      // Tạo một tin nhắn mới
      Message newMessage = Message(
        messageId: DateTime.now().toString(), // ID tin nhắn duy nhất
        content: _controller.text,
        messageStatus: 'sent', // Hoặc trạng thái phù hợp
        timesend: DateTime.now(),
        conversation: widget.conversation!,
        user: usercontroller.user!,
      );
      String receiveID= widget.conversation!.user1.id==usercontroller.user!.id ? widget.conversation!.user2.id :widget.conversation!.user1.id;
      print ("$receiveID");
      mess.newMessage(newMessage);
      print("=============================================================================${newMessage.toJson()}");
      _webSocketService.sendMessage(newMessage, receiveID);
      // Xóa nội dung hộp nhập sau khi gửi
      _controller.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usercontroller = Provider.of<Usercontroller>(context, listen: false);
    final mescontroler = context.watch<Messagecontroller>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.conversation!.user1.username == usercontroller.user!.username
                  ? widget.conversation!.user2.name
                  : widget.conversation!.user1.name,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: ListView.builder(
                controller: _scrollController,
                itemCount: mescontroler.messages.length,
                itemBuilder: (context, index) {
                  final message = mescontroler.messages[index];
                  bool isMyMessage = message.user.username == usercontroller.user!.username; // Kiểm tra tin nhắn của người dùng hiện tại

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: isMyMessage ? Colors.teal[100] : Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.content,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              DateFormat.Hm().format(message.timesend.toLocal()), // Hiển thị giờ (HH:mm)
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Tin nhắn...',
                      border: InputBorder.none,
                    ),
                    onTap: () {
                      _focusNode.requestFocus();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal[300]),
                  onPressed: () {
                    _sendMessage(mescontroler);
                    _focusNode.unfocus();

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
