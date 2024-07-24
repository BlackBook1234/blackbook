import 'package:black_book/widget/alert/component/utils.dart';
import 'package:flutter/material.dart';

class LockerBuilder extends StatelessWidget {
  const LockerBuilder({
    Key? key,
    required this.locker,
    required this.onUnlocked,
    required this.onLocked,
    this.debugSwitch = false,
  }) : super(key: key);
  final Widget onLocked;
  final Widget onUnlocked;
  final Locker locker;
  final bool debugSwitch;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: locker,
      builder: (ctx, isLocked, _) {
        if (isLocked ^ debugSwitch) {
          return onLocked;
        } else {
          return onUnlocked;
        }
      },
    );
  }
}
