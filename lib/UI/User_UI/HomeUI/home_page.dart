import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/UI/User_UI/AccountUI/RegisterPage.dart';
import 'package:timtro/UI/User_UI/AccountUI/account_tab.dart';
import 'package:timtro/UI/User_UI/ChatUI/chat_tab.dart';
import 'package:timtro/UI/User_UI/HomeUI/home_tab.dart';
import 'package:timtro/UI/User_UI/RentalpropertyUI/find_tab.dart';
import 'package:timtro/UI/admin/AcceptPost.dart';
import 'package:timtro/UI/admin/ChartTab.dart';
import 'package:timtro/UI/admin/UserManager.dart';

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
  @override
  void initState() {
    super.initState();
    final usercontroller = context.read<Usercontroller>();
    usercontroller
        .loadState(); // Gọi loadState một lần khi widget được khởi tạo
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usercontroler = context.watch<Usercontroller>();
    return usercontroler.state == 0
        ? CustomerPage()
        : usercontroler.user?.vaitro == "customer" ||
                usercontroler.user?.vaitro == "landlork"
            ? UserPage()
            : AdminPage();
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final CupertinoTabController controller = CupertinoTabController();
  final List<Widget> _tabs = [
    UserManager(),
    AcceptPost(),
    ChartTab(),
    AccountTab2(),
  ];

  @override
  void initState() {
    super.initState();
    final usercontroller = context.read<Usercontroller>();
    usercontroller
        .loadState(); // Gọi loadState một lần khi widget được khởi tạo
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CupertinoTabScaffold(
      controller: controller,
      tabBar: CupertinoTabBar(
        activeColor: AppColors.mainColor,
        inactiveColor: Colors.grey,
        // backgroundColor: Colors.amberAccent,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Quản lý người dùng"),
          BottomNavigationBarItem(
              icon: Icon(Icons.find_in_page_outlined), label: "Duyệt bài"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Thống kê"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tài khoản"),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        // if (index == 0) {
        //   return HomeTab(tabController: controller);
        // }
        return _tabs[index];
      },
    ));
  }
}

class UserPage extends StatefulWidget {
  UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final CupertinoTabController controller = CupertinoTabController();

  void initState() {
    super.initState();
    final usercontroller = context.read<Usercontroller>();
    usercontroller
        .loadState(); // Gọi loadState một lần khi widget được khởi tạo
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatTab = ConversationsScreen();
    final accountTab = AccountTab2();
    final List<Widget> _usertabs = [
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
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Trò Chuyện"),
          BottomNavigationBarItem(
              icon: Icon(Icons.find_in_page_outlined), label: "Tìm Trọ"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tài Khoản"),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return HomeTab(tabController: controller);
        }
        return _usertabs[index];
      },
    ));
  }
}

class CustomerPage extends StatefulWidget {
  CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final CupertinoTabController controller = CupertinoTabController();

  void initState() {
    super.initState();
    final usercontroller = context.read<Usercontroller>();
    usercontroller
        .loadState(); // Gọi loadState một lần khi widget được khởi tạo
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatTab = RegisterPage();
    final accountTab = AccountTab1();
    final List<Widget> _usertabs = [
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
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Trò Chuyện"),
          BottomNavigationBarItem(
              icon: Icon(Icons.find_in_page_outlined), label: "Tìm Trọ"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tài Khoản"),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return HomeTab(tabController: controller);
        }
        return _usertabs[index];
      },
    ));
  }
}
