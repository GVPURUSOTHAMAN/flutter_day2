import 'package:flutter/cupertino.dart';

import '../homePage/models/loginmodel.dart';
import 'loginrepository.dart';


class LoginProvider extends ChangeNotifier {
  final LoginRepository _repository = LoginRepository();

  bool isLoading = false;
  UserModel? user;
  bool addressExist = false;
  String? errorMessage;

  Future<bool> login(String mobile, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.login(mobile, password);
      user = response.userlogin;
      addressExist = response.addressExist;
      isLoading = false;
      notifyListeners();

      if (user != null) {
        return true;
      }
      errorMessage = 'Invalid email/mobile or password';
      return false;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Something went wrong';
      notifyListeners();
      return false;
    }
  }
}
