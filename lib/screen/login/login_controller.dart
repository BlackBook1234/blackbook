import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  String deviceType = "";
  String deviceToken = "";
  final RxInt currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getDeviceType();
  }

  updatePage(int count) {
    currentPage.value = count;
  }

  Future<void> getDeviceType() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;

      deviceType = "android";
      deviceToken = info.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;

      deviceType = "iOS";
      deviceToken = info.name;
    } else {
      deviceType = "huawei";
      deviceToken = "huawei";
    }
  }
}
