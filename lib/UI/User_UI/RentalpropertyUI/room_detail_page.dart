import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/ConversationController.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/Conversation.dart';
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/Model/Utility.dart';
import 'package:timtro/UI/User_UI/AccountUI/personal_acount_view.dart';
import 'package:timtro/UI/User_UI/ChatUI/chat_view_tab.dart';
import 'package:timtro/utils/colors.dart';
import 'package:timtro/widgets/room_detail_widget.dart';

import 'package:url_launcher/url_launcher.dart';

 // Import trang cá nhân của chủ trọ

class RoomDetailPage extends StatefulWidget {
  final RentalProperty rentalProperty;

  const RoomDetailPage({super.key, required this.rentalProperty});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  List<Utility> utilities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if(widget.rentalProperty.status==0){
      widget.rentalProperty.numberViewer+=1;
    }
    loadUtility();
    updateRental();
  }
  void updateRental() async {
    print(" So luot xem = ${widget.rentalProperty.numberViewer}");
    await context.read<Rentalpropertycontroller>().updateRental(widget.rentalProperty);
  }
  void loadUtility() async {
    final rentalPropertyController = context.read<Rentalpropertycontroller>();
    utilities = await rentalPropertyController.getUtilitiesByRental(widget.rentalProperty.propertyId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết phòng'),
          backgroundColor: AppColors.mainColor,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoomDetailWidget(rentalProperty: widget.rentalProperty),
                const SizedBox(height: 20),
                const Text(
                  'Mô tả:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.rentalProperty.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                // Hiển thị tên chủ trọ và cho phép nhấn vào để xem trang cá nhân
                GestureDetector(
                  onTap: () {
                   // Chuyển tới trang cá nhân của chủ trọ
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LandlordProfilePage(
                          landlord: widget.rentalProperty.landlord,
                        ),
                      ),
                    );
                   // Navigator.push(context, MaterialPageRoute(builder: (context)=> PersonalAcountView()));
                  },
                  child: Text(
                    'Chủ trọ: ${widget.rentalProperty.landlord.name}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (utilities.isNotEmpty) ...[
                  const Text(
                    'Tiện ích:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: utilities.length,
                    itemBuilder: (context, index) {
                      final utility = utilities[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Text(
                          utility.utilityName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ActionButton(
                      icon: Icons.calendar_today,
                      onPressed: () {},
                    ),
                    ActionButton(
                      icon: Icons.chat,
                      onPressed: () async {
                        final conversationController =
                        Provider.of<Conversationcontroller>(context, listen: false);
                        final userController =
                        Provider.of<Usercontroller>(context, listen: false);
                        Conversation? conversation = conversationController.conversations
                            .firstWhere(
                              (conv) =>
                          conv.user2.id == widget.rentalProperty.landlord.id ||
                              conv.user1.id == widget.rentalProperty.landlord.id,
                          orElse: () => Conversation(
                            conversationId: "",
                            user1: userController.user!,
                            user2: widget.rentalProperty.landlord,
                          ),
                        );

                        if (conversation.conversationId == "") {
                          conversation = await conversationController.newConversation(
                            Conversation(
                              conversationId: "",
                              user1: userController.user!,
                              user2: widget.rentalProperty.landlord,
                            ),
                          );
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              conversation: conversation,
                              conversationController: conversationController,
                            ),
                          ),
                        );
                      },
                    ),
                    ActionButton(
                      icon: Icons.phone,
                      onPressed: () async {
                        final Uri phoneUri = Uri(
                          scheme: 'tel',
                          path: widget.rentalProperty.landlord.sdt,
                        );

                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        } else {
                          print('Could not launch $phoneUri');
                        }
                      },
                    ),
                    ActionButton(
                      icon: Icons.map,
                      onPressed: () async {
                        if (await canLaunchUrl(Uri.parse(widget.rentalProperty.urlmap))) {
                         await launchUrl(Uri.parse(widget.rentalProperty.urlmap));
                        } else {
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Chủ trọ chưa cập nhật vị trí !!!")));
                          });
                        }
                      },
                    ),
                  ],
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
  final IconData icon;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16.0),
      ),
      onPressed: onPressed,
      child: Icon(icon, size: 24),
    );
  }
}
