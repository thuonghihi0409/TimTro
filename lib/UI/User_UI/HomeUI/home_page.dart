import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/UI/User_UI/AccountUI/RegisterPage.dart';
import 'package:timtro/UI/User_UI/AccountUI/account_tab.dart';
import 'package:timtro/UI/User_UI/ChatUI/chat_tab.dart';
import 'package:timtro/UI/User_UI/HomeUI/home_tab.dart';
import 'package:timtro/UI/User_UI/RentalpropertyUI/find_tab.dart';

import 'package:timtro/utils/colors.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }


}

class HomePage extends StatefulWidget {
   HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CupertinoTabController controller = CupertinoTabController();

  @override
  void initState() {
    super.initState();
    final usercontroller = context.read<Usercontroller>();
    usercontroller.loadState(); // Gọi loadState một lần khi widget được khởi tạo
  }
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final usercontroler = context.watch<Usercontroller>();
    final chatTab = usercontroler.state == 0 ? RegisterPage() : ConversationsScreen();
    final accountTab = usercontroler.state == 0 ? AccountTab1() : AccountTab2();
    final List<Widget> _tabs = [
      HomeTab(tabController: controller),
      chatTab,
      FindTab(),
      accountTab,
    ];

    return SafeArea(
        child: CupertinoTabScaffold(
          controller: controller,
          tabBar: CupertinoTabBar(
            activeColor: AppColors.mainColor,
            inactiveColor: Colors.grey,
            // backgroundColor: Colors.amberAccent,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang Chủ"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat), label: "Trò Chuyện"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.find_in_page_outlined), label: "Tìm Trọ"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tài Khoản"),

            ],
          ),
          tabBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return HomeTab(tabController: controller);
            }
            return _tabs[index];
          },
        )
    );
  }


}

