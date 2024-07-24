import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double pi = math.pi;

double lerp(double a, double b, double t) {
  return a + (b - a) * t;
}

// Transform 0..1 to 0..1-1..0
double reversed(double value) {
  if (value < 0.5) {
    return value * 2;
  }
  return (1 - value) * 2;
}

extension ToColorExtension on String {
  Color? toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }

    return null;
  }
}

/// Утасны дугаар зөв эсэхийг шалгах. 6,7,8 аар эхэлдэг 8 урттай text.
bool validatePhoneNumber(String phoneNumber) {
  return RegExp(r'^[8976]\d{7}$').hasMatch(phoneNumber);
}

bool validatePassword(String password) {
  return RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(password);
  // check for special characters! (?=.*?[A-Z]) Big capitals letters are not allowed
  // return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
  // .hasMatch(password);
}

class Locker extends ValueNotifier<bool> {
  Locker(bool value) : super(value);
  bool get isLocked => value;
  void lock() => value = true;
  void unlock() => value = false;
}

String formatPoint(num input, {String separator = '\''}) {
  return input
      .toString()
      .replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), separator);
}

String numberPrettier(String x) {
  return x.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ",");
}

String timestampToDateString(int timestampUs) {
  DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(timestampUs);
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

  return formattedDate;
}

extension ToDateExtension on int {
  DateTime toDate() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }
}

extension SpaceBetweenWidgets on Iterable<Widget> {
  List<Widget> spaceBetween([
    double horizontalWidth = 0.0,
    double verticalHeight = 0.0,
  ]) {
    List<Widget> spacedElements = [];

    for (int i = 0; i < length; i++) {
      if (i > 0) {
        spacedElements.add(
          SizedBox(
            width: horizontalWidth,
            height: verticalHeight,
          ),
        );
      }
      spacedElements.add(elementAt(i));
    }

    return spacedElements;
  }

  List<Widget> addWidget(Widget widget) {
    List<Widget> spacedElements = [];

    for (int i = 0; i < length; i++) {
      if (i > 0) {
        spacedElements.add(widget);
      }
      spacedElements.add(elementAt(i));
    }

    return spacedElements;
  }
}
