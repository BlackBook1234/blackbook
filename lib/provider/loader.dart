import 'package:black_book/constant.dart';
import 'package:flutter/material.dart';

class LoaderProvider extends ChangeNotifier {
  bool _isLoading = false;

  void startLoading(BuildContext contexts) {
    if (!_isLoading) {
      _isLoading = true;
      showDialog(
          barrierColor: Colors.transparent,
          context: contexts,
          builder: (contexts) => Container(
              color: Colors.transparent,
              child: const Center(
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child:
                          CircularProgressIndicator(color: kPrimaryColor)))));
    }
  }

  void cancelLoading(BuildContext contexts) {
    if (_isLoading) {
      _isLoading = false;
      Navigator.pop(contexts);
    }
  }
}
