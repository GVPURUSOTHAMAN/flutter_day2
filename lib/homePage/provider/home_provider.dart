

import 'package:day2/homePage/models/home.dart';
import 'package:flutter/cupertino.dart';

import '../repository/repository.dart';

class HomeProvider extends ChangeNotifier{
  final Repository repository;
  HomeProvider({
    required this.repository,
});
  Home? homedata;
  bool isLoading = false;
  String? errormsg;
  Future<void> loadhomeurl() async{
    isLoading= true;
    errormsg = null;
    notifyListeners();
    try{
      homedata = await repository.gethomeurl();
    }catch (e){
      errormsg = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}