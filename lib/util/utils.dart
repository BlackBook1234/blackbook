import 'package:black_book/global_keys.dart';
import 'package:black_book/provider/loader.dart';
import 'package:black_book/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Utils {
  static void startLoader(BuildContext context) {
    Provider.of<LoaderProvider>(context, listen: false).startLoading(context);
  }

  static void cancelLoader(BuildContext context) {
    Provider.of<LoaderProvider>(context, listen: false).cancelLoading(context);
  }

  static CommonProvider getCommonProvider() {
    return Provider.of<CommonProvider>(GlobalKeys.navigatorKey.currentContext!,
        listen: false);
  }

  static String getToken() {
    return Provider.of<CommonProvider>(GlobalKeys.navigatorKey.currentContext!,
                listen: false)
            .userInfo!
            .accessToken ??
        '';
  }

  static String getRefreshToken() {
    return Provider.of<CommonProvider>(GlobalKeys.navigatorKey.currentContext!,
                listen: false)
            .userInfo!
            .refreshToken ??
        '';
  }

  static String getUserRole() {
    return Provider.of<CommonProvider>(GlobalKeys.navigatorKey.currentContext!,
                listen: false)
            .userInfo!
            .type ??
        '';
  }

  static int getStoreId() {
    return Provider.of<CommonProvider>(GlobalKeys.navigatorKey.currentContext!,
                listen: false)
            .userInfo!
            .storeId ??
        0;
  }

  static int getIpaid() {
    return Provider.of<CommonProvider>(GlobalKeys.navigatorKey.currentContext!,
                listen: false)
            .userInfo!
            .isPaid ??
        0;
  }

  static String getPhone() {
    return Provider.of<CommonProvider>(GlobalKeys.navigatorKey.currentContext!,
                listen: false)
            .userInfo!
            .phone ??
        "";
  }

  static int getUpdate() {
    return Provider.of<CommonProvider>(GlobalKeys.navigatorKey.currentContext!,
                listen: false)
            .userInfo!
            .mustUpdate ??
        0;
  }

  static String getstoreName() {
    return Provider.of<CommonProvider>(GlobalKeys.navigatorKey.currentContext!,
                listen: false)
            .userInfo!
            .storeName ??
        "";
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
