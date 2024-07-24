import 'package:black_book/models/user_data/user_data.dart';
import 'package:flutter/cupertino.dart';

class UAuth with ChangeNotifier {
  static final UAuth _instance = UAuth._internal();
  factory UAuth() => _instance;
  UAuth._internal();

  String? mobile;
  String? password;

  /// LOGIN or REGISTRATION
  String flow = 'LOGIN';
  String? cardNumber;

  UserDataModel? get token => authNotifier.value;
  ValueNotifier<UserDataModel?> authNotifier = ValueNotifier(null);
  bool get isLoggedIn => token != null;

  // Future<AuthenticationResponseModel> addFriendRequest(String phone) async {
  //   return 
  // }
}
