import 'dart:io';

import 'package:flutter/material.dart';

// ignore: deprecated_member_use
Size size = WidgetsBinding.instance.window.physicalSize /
    // ignore: deprecated_member_use
    WidgetsBinding.instance.window.devicePixelRatio;

double getSize(double px) {
  var height = getVerticalSize(px);
  var width = getHorizontalSize(px);
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

double getHorizontalSize(double px) {
  return px * 1;
}

double getVerticalSize(double px) {
  return size.height > 844 ? px + 1 : px * 1;
}

double isPhoneType() {
  if (Platform.isIOS) {
    return getSize(size.height / 24);
  } else {
    return getSize(30);
  }
}
