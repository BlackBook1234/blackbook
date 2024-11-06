import 'dart:io';
import 'package:black_book/models/default/device_model.dart';
import 'package:device_info_plus/device_info_plus.dart';

class UDevice {
  static final UDevice _instance = UDevice._internal();
  factory UDevice() => _instance;
  UDevice._internal();
  String deviceType = "";
  String deviceToken = "";

  Future<DeviceModel> getDeviceUUID() async {
    DeviceModel model;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      deviceType = "android";
      deviceToken = info.model;
      model = DeviceModel(deviceInfo: "android", deviceToken: info.model);
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      deviceType = "ios";
      deviceToken = info.name;
      model = DeviceModel(deviceInfo: "ios", deviceToken: info.model);
    } else {
      deviceType = "huawei";
      deviceToken = "huawei";
      model = DeviceModel(deviceInfo: "huawei", deviceToken: "huawei");
    }
    return model;
  }
}
