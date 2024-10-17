import 'package:timtro/Model/User.dart';

class Appointment {
  String appointmentId;
  String appointmentDate;
  String status;
  String result;
  User customer;
  User landlord;

  Appointment({
    required this.appointmentId,
    required this.appointmentDate,
    required this.status,
    required this.result,
    required this.customer,
    required this.landlord,
  });
}
