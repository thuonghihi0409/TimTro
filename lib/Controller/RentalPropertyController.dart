import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/Service/RentalpropertyService.dart';
import 'package:flutter/foundation.dart';

class Rentalpropertycontroller with ChangeNotifier{
  List listRental =[];
  Rentalpropertyservice rentalPropertyservice= Rentalpropertyservice();
   void setRental () async {
    listRental= await rentalPropertyservice.fetchRentalProperties() as List;
    notifyListeners();
  }

}