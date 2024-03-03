import 'dart:convert';

import 'package:black_book/models/user_data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonProvider extends ChangeNotifier {
  UserDataModel? userInfo;

  CommonProvider() {
    initState();
  }

  void initState() async {
    final prefs = await SharedPreferences.getInstance();
    var user = prefs.getString("userInfo");
    if (user != null) {
      final Map<String, dynamic> data = json.decode(user);
      userInfo = UserDataModel.fromJson(data);
      notifyListeners();
    }
  }

  bool get isLogged => userInfo != null;
  void setUserInfo(UserDataModel value) {
    userInfo = value;
    notifyListeners();
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userInfo");
  }
}
