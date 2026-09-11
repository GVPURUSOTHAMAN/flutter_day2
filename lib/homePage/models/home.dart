
import 'package:day2/homePage/models/banner.dart';
import 'package:day2/homePage/models/category.dart';
import 'package:day2/homePage/models/product.dart';

class Home {
  final List<Banner>Bannerhome;
  final List<Categories> categoryhome;
  final List<Product> producthome;

  Home({
   required this.Bannerhome,
   required this.categoryhome,
   required this.producthome
});
  factory Home.fromJson(Map<String, dynamic> json){
    final resultdata = json["ResultData"] ?? {};
    return Home(
        Bannerhome: (resultdata["Banner"] as List? ?? []).map((e) => Banner.fromJson(e)).toList(),
        categoryhome: (resultdata["Catlist"] as List? ?? []).map((e) => Categories.fromJson(e)).toList(),
        producthome: (resultdata["f_stock"] as List? ?? []).map((e) => Product.fromJson(e)).toList()
    );
  }
}