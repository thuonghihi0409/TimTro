import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/Service/RentalpropertyService.dart';
import 'package:flutter/foundation.dart';

class Rentalpropertycontroller with ChangeNotifier{
  List listRental =[];
  Rentalpropertyservice rentalPropertyservice= Rentalpropertyservice();
  void uploadUI (){
    notifyListeners();
  }
   void setRental () async {
    listRental= await rentalPropertyservice.fetchRentalProperties() as List;
    uploadUI();
  }
  void  postRental (RentalProperty rental){
     rentalPropertyservice.postRentalProperty(rental);
     notifyListeners();
  }

  Future<List<RentalProperty>> getRentalByLandLord (String id) async{
    return await rentalPropertyservice.getRentalByLandLord(id);
  }
}