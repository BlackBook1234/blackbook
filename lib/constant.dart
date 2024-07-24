import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

const kBackgroundColor = Color(0xFFF5F5F5);
const kWhite = Color(0xFFFFFFFF);
const kPrimarySecondColor = Color(0xFF232F3F);
const kPrimaryColor = Color(0xFFFF6600);
const kBlack = Color(0xFF000000);
const kNotification = Color(0xFFF1F1F1);
const kTextSecondaryColor = Color(0xFFF5F5F5);

Color kDivider = const Color(0xffECEAF5);
Color kBackgroundLight = const Color(0xffF7F6FE);


const Color kTextDark = Color(0xff0E0938);
const Color kPrimarySmooth = Color(0xffF3F2FD);
const Color kTextMedium = Colors.black38;
const Color kDanger = Color(0xffFF3D71);
const Color kSuccess = Color(0xff00D68F);
const Color kSmoothBg = Color(0xffF3F2FD);
const Color kContainer = Color(0xffF6F5FF);
const Color kBrandRed = Color(0xffE76C5C);
const Color kContainerBg = Color(0xffE2E2E2);
const Color kDisable = Color(0xffF3F3F7);
const Color kDisabledText = Color(0xff9691B5);



Future<bool> checkNetwork() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}
