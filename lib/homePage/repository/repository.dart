
import 'dart:convert';

import 'package:day2/core/api%20constants/api_constant.dart';
import 'package:day2/homePage/models/home.dart';
import 'package:http/http.dart' as http;

class Repository{
  Future<Home> gethomeurl() async{
    final response = await http.get(Uri.parse(ApiConstant.homeurl));
    if(response.statusCode != 200) {
      throw Exception("server error: ${response.statusCode}");
    }
      final Map<String, dynamic>data = jsonDecode(response.body);
      if(data["ResponseCode"]?.toString() !="200"){
        throw Exception(data["ResponseMsg"]?.toString() ?? "Home Data not Get Successfully!");
    }
      print("ResponseCode: ${response.body}");
      print("ResponseMsg: ${response.statusCode}");
      return Home.fromJson(data);
  }
}
