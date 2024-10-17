// import 'package:flutter/material.dart';
//
// class ChatTab extends StatelessWidget {
//   const ChatTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text("Chat tab"),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
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


//=============================
class Conversation {
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;

  Conversation({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
  });
}

//======================================
List<Conversation> conversations = [
  Conversation(
    name: "Alice",
    lastMessage: "See you tomorrow!",
    time: "10:30 AM",
    avatarUrl: "https://example.com/avatar1.png",
  ),
  Conversation(
    name: "Bob",
    lastMessage: "Let's meet at the park.",
    time: "9:15 AM",
    avatarUrl: "https://example.com/avatar2.png",
  ),
  Conversation(
    name: "Charlie",
    lastMessage: "What’s up?",
    time: "8:00 AM",
    avatarUrl: "https://example.com/avatar3.png",
  ),
];

class ConversationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations'),
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(conversation.avatarUrl),
            ),
            title: Text(
              conversation.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(conversation.lastMessage),
            trailing: Text(conversation.time),
            onTap: () {
              // Chuyển đến màn hình chat với người này
            },
          );
        },
      ),
    );
  }
}