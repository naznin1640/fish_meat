class UserModel {
  final String id;
  final String username;
  final String email;
  final String? address;
  final String? pincode;
  final String? fcmToken;
  final String vendor;
  final bool isActive;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.address,
    this.pincode,
    this.fcmToken,
    required this.vendor,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"]?.toString() ?? "",
        username: json["username"]?.toString() ?? "",
        email: json["email"]?.toString() ?? "",
        address: json["address"]?.toString(),
        pincode: json["pincode"]?.toString(),
        fcmToken: json["fcmToken"]?.toString(),
        vendor: json["vendor"]?.toString() ?? "false",
        isActive: json["isActive"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "address": address,
        "pincode": pincode,
        "fcmToken": fcmToken,
      };
}

class UserResponse {
  final bool success;
  final String message;
  final UserModel? data;

  UserResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? null : UserModel.fromJson(json["data"]),
      );
}