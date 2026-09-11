
import 'package:day2/category/respository/category_respository.dart';
import 'package:day2/homePage/models/home.dart';
import 'package:flutter/cupertino.dart';


class CategoryProvider extends ChangeNotifier{
  final CategoryRepository repository;
  CategoryProvider({
    required this.repository,
  });
  Home? homeurl;
  bool isLoading = false;
  String? errormsg;
  Future<void> loadhomeurl() async{
    isLoading= true;
    errormsg = null;
    notifyListeners();
    try{
      homeurl = await repository.gethomeurl();
    }catch (e){
      errormsg = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }


}