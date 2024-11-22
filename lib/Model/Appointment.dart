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
  // Chuyển đổi đối tượng Appointment thành JSON
  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'appointmentDate': appointmentDate,
      'status': status,
      'result': result,
      'customerId': customer.toJson(), // Giả sử User cũng có phương thức toJson()
      'landlordId': landlord.toJson(), // Giả sử User cũng có phương thức toJson()
    };
  }

  // Chuyển đổi từ JSON thành đối tượng Appointment
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointmentId'],
      appointmentDate: json['appointmentDate'],
      status: json['status'],
      result: json['result'],
      customer: User.fromJson(json['customer']), // Giả sử User có phương thức fromJson()
      landlord: User.fromJson(json['landlord']), // Giả sử User có phương thức fromJson()
    );
  }
}
