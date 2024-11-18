import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/ConversationController.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/Conversation.dart';
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/Model/Utility.dart';
import 'package:timtro/UI/RentalpropertyUI/MapScreen.dart';
import 'package:timtro/UI/ChatUI/chat_view_tab.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/colors.dart';
import '../../widgets/room_detail_widget.dart';

class RoomDetailPage extends StatefulWidget {
  final RentalProperty rentalProperty;

  const RoomDetailPage({super.key, required this.rentalProperty});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  List<Utility> list=[];
  bool isloading =true;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    loadUtility();

  }
  void loadUtility() async {
    final rentalpropertycontroller = context.read<Rentalpropertycontroller>();
    list= await rentalpropertycontroller.getUtilitiesByRental(widget.rentalProperty.propertyId);
    setState(() {
      isloading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isloading) return const Center(child: CircularProgressIndicator());
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
                RoomDetailWidget(rentalProperty: widget.rentalProperty),
                SizedBox(height: 20),
                Text(
                  'Mô tả:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  widget.rentalProperty.description,
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
                        icon: Icons.calendar_today,
                        onPressed: () {},
                      ),
                      ActionButton(
                        icon: Icons.chat,
                        onPressed: () async {
                          final conversationController =
                              Provider.of<Conversationcontroller>(context,
                                  listen: false);
                          final userController = Provider.of<Usercontroller>(
                              context,
                              listen: false);

                          Conversation? conversation =
                              conversationController.conversations.firstWhere(
                                  (conv) =>
                                      conv.user2.id ==
                                          widget.rentalProperty.landlord.id ||
                                      conv.user1.id ==
                                          widget.rentalProperty.landlord.id,
                                  orElse: () => Conversation(
                                      conversationId: "",
                                      user1: userController.user!,
                                      user2: widget.rentalProperty.landlord));

                          if (conversation.conversationId == "") {
                            conversation = await conversationController
                                .newConversation(Conversation(
                                    conversationId: "",
                                    user1: userController.user!,
                                    user2: widget.rentalProperty.landlord));
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
                              scheme: 'tel', path: widget.rentalProperty.landlord.sdt);

                          if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri);
                          } else {
                            print('Could not launch $phoneUri');
                          }
                        },
                      ),
                      // Nút mở Google Maps
                      ActionButton(
                        icon: Icons.map,
                        onPressed: () async {
                          // final Uri mapUri = Uri(
                          //   scheme: 'https',
                          //   host: 'www.google.com',
                          //   path: 'maps/search/?api=1&query=${rentalProperty.rentPrice},${rentalProperty.area}',
                          // );
                          //
                          // if (await canLaunchUrl(mapUri)) {
                          //   await launchUrl(mapUri);
                          // } else {
                          //   print('Could not launch $mapUri');
                          //}
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RentalMapScreen()));
                        },
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
      ),
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
