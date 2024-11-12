
class Utility {
  String utilityId;
  String utilityName;

  Utility({required this.utilityId, required this.utilityName});

  // Phương thức khởi tạo từ JSON (dùng khi nhận dữ liệu từ API)
  factory Utility.fromJson(Map<String, dynamic> json) {
    return Utility(
      utilityId: json['utilityId'] ?? '',
      utilityName: json['utilityName'] ?? '',
    );
  }

  // Phương thức chuyển đổi đối tượng thành JSON (dùng khi gửi dữ liệu lên API)
  Map<String, dynamic> toJson() {
    return {
      'utilityId': utilityId,
      'utilityName': utilityName,
    };
  }
}
