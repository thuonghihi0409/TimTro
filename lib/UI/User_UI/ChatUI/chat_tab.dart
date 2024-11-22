import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/ConversationController.dart';
import 'package:timtro/Controller/MessageController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/Conversation.dart';
import 'package:timtro/UI/User_UI/ChatUI/chat_view_tab.dart';

import 'package:timtro/utils/colors.dart';

class ConversationsScreen extends StatefulWidget {
  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Conversation> _filteredConversations = [];

  @override
  void initState() {
    super.initState();
    final userController = Provider.of<Usercontroller>(context, listen: false);
    final conversationController =
        Provider.of<Conversationcontroller>(context, listen: false);

    conversationController.loadConversation(userController.user!.id).then((_) {
      setState(() {
        _filteredConversations = conversationController.conversations;
      });
    });

    _searchController.addListener(() {
      _filterConversations();

    });
  }

  void _filterConversations() {
    final userController = Provider.of<Usercontroller>(context, listen: false);
    final query = _searchController.text.toLowerCase();
    final conversationController =
        Provider.of<Conversationcontroller>(context, listen: false);

    setState(() {
      _filteredConversations =
          conversationController.conversations.where((conversation) {
        final otherUser =
            conversation.user1.username == userController.user!.username
                ? conversation.user2
                : conversation.user1;
        return otherUser.name.toLowerCase().contains(query);
      }).toList();

    });
  }

  @override
  Widget build(BuildContext context) {
    final userController = context.watch<Usercontroller>();
    final conversationController1 = context.watch<Conversationcontroller>();




    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100], // Nền tối nhẹ
        appBar: AppBar(
          backgroundColor: Colors.teal[400],
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.teal[300],
                // Màu nền của ô tìm kiếm
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.qr_code, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: _filteredConversations.isEmpty
                ? Center(
                    child: Text(
                      'Không có cuộc trò chuyện nào.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredConversations.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey[800]),
                    itemBuilder: (context, index) {
                      final conversation = _filteredConversations[index];
                      final isUser1 = conversation.user1.username ==
                          userController.user!.username;
                      final otherUser =
                          isUser1 ? conversation.user2 : conversation.user1;
                      final lastMessage = conversation.lastMessage;
                      final messageTime = lastMessage != null
                          ? DateFormat('HH:mm').format(lastMessage.timesend)
                          : "";
                      final imageUrl = ''; // Thay bằng URL hình ảnh nếu có
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : AssetImage('assets/images/anh3.png')
                                  as ImageProvider,
                          backgroundColor: Colors.grey[700],
                        ),
                        title: Text(
                          otherUser.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        subtitle: Text(
                          lastMessage?.content ?? "No messages yet",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          messageTime,
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                conversation: conversation,
                                conversationController: conversationController1,
                              ),
                            ),
                          );
                        },
                        onLongPress: () {
                          _showOptionsDialog(
                              context, conversationController1, index);
                        },
                      );
                    },
                  ),
      ),
    );
  }

  void _showOptionsDialog(
      BuildContext context, Conversationcontroller conversations, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Xóa'),
              onTap: () {
                Navigator.of(context).pop();
                _showDeleteMessageDialog(context, conversations, index);

              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Chỉnh sửa'),
              onTap: () {
                Navigator.of(context).pop();
                // _editConversation(context, conversation);
              },
            ),
            ListTile(
              leading: Icon(Icons.push_pin, color: Colors.orange),
              title: Text('Ghim'),
              onTap: () {
                Navigator.of(context).pop();
                // _pinConversation(index);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.grey),
              title: Text('Hủy'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteMessageDialog(
      BuildContext context, Conversationcontroller conversations, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa tin nhắn'),
          content: Text('Bạn có chắc chắn muốn xóa tin nhắn này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                // Xóa tin nhắn từ danh sách hoặc gọi API để xóa tin nhắn
                await conversations.deleteConversation(
                    _filteredConversations[index].conversationId);
                _filteredConversations.removeAt(index);
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
