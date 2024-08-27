import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timtro/UI/account_tab.dart';
import 'package:timtro/UI/chat_tab.dart';
import 'package:timtro/UI/find_tab.dart';
import 'package:timtro/UI/home_tab.dart';

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

  final List<Widget> _tabs= [
    HomeTab(),
    ChatTab(),
    FindTab(),
    AccountTab(),

  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            backgroundColor: Colors.amberAccent,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat), label: "Chat"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.find_in_page_outlined), label: "Find"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),

            ],
          ),
          tabBuilder: (BuildContext context, int index) {
            return _tabs[index];
          },
        )
    );
  }


}

