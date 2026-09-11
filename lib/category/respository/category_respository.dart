import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api constants/api_constant.dart';
import '../../homePage/models/home.dart';

class CategoryRepository{
  Future<Home> gethomeurl() async{
    final response = await http.post(Uri.parse(ApiConstant.homeurl));
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