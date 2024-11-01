import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/ConversationController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/Conversation.dart';
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/UI/chat_view_tab.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/colors.dart';
import '../widgets/room_detail_widget.dart';

class RoomDetailPage extends StatelessWidget {
  final RentalProperty rentalProperty;

  const RoomDetailPage({super.key, required this.rentalProperty});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chi tiết phòng'),
          backgroundColor: AppColors.mainColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sử dụng thông tin từ `rentalProperty`
                RoomDetailWidget(rentalProperty: rentalProperty),
                SizedBox(height: 20),
                // Các thông tin chi tiết
                Text(
                  'Mô tả:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  rentalProperty.description, // Giả sử bạn đã thêm mô tả trong model
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                // Các nút hành động
                Container(
                  margin: EdgeInsets.only(top: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ActionButton(
                        label: 'Đặt lịch\nxem phòng',
                        onPressed: () {},
                        icon: Icons.calendar_today,
                      ),
                      ActionButton(
                        label: 'Chat\nngay',
                        onPressed: () async {
                          final conversationController =
                          Provider.of<Conversationcontroller>(context, listen: false);
                          final userController =
                          Provider.of<Usercontroller>(context, listen: false);

                          // Kiểm tra xem đã có hội thoại chưa, nếu chưa thì tạo mới
                          Conversation? conversation = conversationController.conversations.firstWhere(
                                  (conv) =>
                              conv.user2.id == rentalProperty.landlord.id ||
                                  conv.user1.id == rentalProperty.landlord.id,
                              orElse: () => Conversation(
                                  conversationId: "",
                                  user1: userController.user!,
                                  user2: rentalProperty.landlord));

                          // Nếu không tồn tại conversationId, tạo mới
                          if (conversation.conversationId == "") {
                            conversation = await conversationController.newConversation(
                                Conversation(
                                    conversationId: "",
                                    user1: userController.user!,
                                    user2: rentalProperty.landlord));
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(conversation: conversation),
                            ),
                          );
                        },
                        icon: Icons.chat,
                      ),
                      ActionButton(
                        label: 'Gọi điện',
                        onPressed: () async {
                          final Uri phoneUri = Uri(scheme: 'tel', path: rentalProperty.landlord.sdt);

                          if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri);
                          } else {
                            print('Could not launch $phoneUri');
                          }
                        },
                        icon: Icons.phone,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
