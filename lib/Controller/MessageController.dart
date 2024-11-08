import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:timtro/Model/Message.dart';
import 'package:timtro/Service/MessageService.dart';

class Messagecontroller with ChangeNotifier {
  List<Message> messages =[];
  Messageservice messageservice= Messageservice();
  void updateUI(){
    notifyListeners();
  }
  Future<void> loadMessage (String conversationId) async {
    messages = await messageservice.fetchMessage(conversationId);

    messages.sort((a, b) => b.timesend.compareTo(a.timesend));
    updateUI();
  }
  Future<void> newMessage (Message message) async {
    Message? mess=await messageservice.sendMessage(message);
    if(mess!=null)  messages.insert(0,mess!);
   updateUI();
  }

}