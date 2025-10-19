class UserModel {
  final String accessToken;
  final String userName;
  final String email;
  final String phoneNumber;
  final String address;

  UserModel({
    required this.accessToken,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json['accessToken'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}
