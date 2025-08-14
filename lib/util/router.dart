import 'package:flutter/cupertino.dart';

class NoSwipeCupertinoRoute<T> extends CupertinoPageRoute<T> {
  NoSwipeCupertinoRoute({required WidgetBuilder builder})
      : super(builder: builder);

  @override
  bool get enableSwipeBackGesture => false;

  @override
  bool get canPop => false;
}
