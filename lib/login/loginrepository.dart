import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/api constants/api_constant.dart';
import '../homePage/models/loginmodel.dart';

class LoginRepository {
  Future<LoginResponse> login(String mobile, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstant.userlogin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobile': mobile, 'password': password}),
    );
    final data = jsonDecode(response.body);
    return LoginResponse.fromJson(data);
  }
}
