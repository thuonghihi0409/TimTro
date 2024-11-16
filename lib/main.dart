import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/ConversationController.dart';
import 'package:timtro/Controller/MessageController.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/UI/HomeUI/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAppCheck.instance.activate();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Usercontroller()),
          ChangeNotifierProvider(create: (_) => Rentalpropertycontroller()),
          ChangeNotifierProvider(create: (_) => Conversationcontroller()),
          ChangeNotifierProvider(create: (_) => Messagecontroller()),
        ],
          child: MyApp()
      )
  );
}


