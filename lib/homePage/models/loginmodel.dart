class LoginResponse {
  final UserModel? userlogin;
  final bool addressExist;

  LoginResponse({this.userlogin, required this.addressExist});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userlogin: json['UserLogin'] != null
          ? UserModel.fromJson(Map<String, dynamic>.from(json['UserLogin']))
          : null,
      addressExist: json['AddressExist'] == true,
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String wallet;
  final String userLoyaltyPoints;

  UserModel(
      this.id,
      this.name,
      this.mobile,
      this.email,
      this.wallet,
      this.userLoyaltyPoints,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['id']?.toString() ?? '',
      json['name']?.toString() ?? '',
      json['mobile']?.toString() ?? '',
      json['email']?.toString() ?? '',
      json['wallet']?.toString() ?? '0',
      json['userloyaltypoints']?.toString() ?? '0',
    );
  }
}
