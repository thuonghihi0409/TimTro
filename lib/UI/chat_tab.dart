
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/ConversationController.dart';
import 'package:timtro/Controller/MessageController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/UI/chat_view_tab.dart';
import 'package:timtro/utils/colors.dart';

class ChatTab extends StatefulWidget {
  @override
  _ChatTab createState() => _ChatTab();
}

class _ChatTab extends State<ChatTab> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;
  String? _name;
  String? _phoneNumber;
  bool _isStudent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin của bạn'),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText:
                'Tên của bạn'),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên của bạn';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Số điện thoại'),
                onChanged: (value) {
                  setState(() {
                    _phoneNumber = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Radio(
                    value: 'Nam',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value as String;
                      });
                    },
                    activeColor: AppColors.mainColor,
                  ),
                  Text('Nam'),
                  Radio(
                    value: 'Nữ',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value as String;
                      });
                    },
                    activeColor: AppColors.mainColor
                  ),
                  Text('Nữ'),
                  Radio(
                    value: 'Khác',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value as String;
                      });
                    },
                    activeColor: AppColors.mainColor
                  ),
                  Text('Khác'),
                ],
              ),
              SwitchListTile(
                title: Text('Bạn là sinh viên'),
                value: _isStudent,
                onChanged: (value) {
                  setState(() {
                    _isStudent = value;
                  });

                },
                activeTrackColor: AppColors.mainColor,
              ),
              InkWell(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor, // Màu nền
                    foregroundColor: Colors.white, // Màu chữ
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Xử lý khi người dùng nhấn nút "Vào chat ngay"
                      // Ví dụ: gửi dữ liệu lên server
                      print('Tên: $_name');
                      print('Số điện thoại: $_phoneNumber');
                      print('Giới tính: $_gender');
                      print('Sinh viên: $_isStudent');
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                    }

                  },
                  child: Text('Vào chat ngay',
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                ),
                // onTap: (){
                //   Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                // },
              ),
            ],

          ),
        ),
      ),

    );
  }
}

class ConversationsScreen extends StatefulWidget {
  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    final userController = Provider.of<Usercontroller>(context, listen: false);
    final conversationController = Provider.of<Conversationcontroller>(context, listen: false);
    conversationController.loadConversation(userController.user!.id);
  }

  @override
  Widget build(BuildContext context) {
    final userController = context.watch<Usercontroller>();
    final conversationController = context.watch<Conversationcontroller>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations'),
      ),
      body: ListView.builder(
        itemCount: conversationController.conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversationController.conversations[index];
          final isUser1 = conversation.user1.username == userController.user!.username;
          final otherUser = isUser1 ? conversation.user2 : conversation.user1;
          final lastMessage = conversation.lastMessage;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/anh3.png'),
              // Nếu có URL ảnh mạng, bật dòng này:
              // backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : AssetImage('assets/images/anh3.png'),
            ),
            title: Text(
              otherUser.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(lastMessage?.content ?? "No messages yet"),
            trailing: Text(lastMessage != null ? lastMessage.timesend.toString() : "No time"),
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => ChatScreen(conversation: conversation,)));
            },
          );
        },
      ),
    );
  }
}
