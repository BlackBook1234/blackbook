import 'package:black_book/api/api.dart';
import 'package:black_book/api/component/error_mapper.dart';
import 'package:black_book/widget/alert/custom_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'error_dialog.dart';
import 'success_dialog.dart';
import 'warning_dialog.dart';

mixin BaseStateMixin<T extends StatefulWidget> on State<T> {
  API get api => API();
  Future<S?> showErrorDialog<S>(String message, {String? title}) {
    if (mounted) {
      return showDialog<S>(
        context: context,
        builder: (ctx) => ErrorDialog(
          title: 'Алдаа',
          message: message,
        ),
      );
    }
    return Future.value(null);
  }

  Future<S?> showSuccessDialog<S>(String title, bool popup, String message) {
    if (mounted) {
      return showDialog<S>(
        useSafeArea: popup,
        context: context,
        builder: (ctx) => KSuccessDialog(
          title: title,
          message: message,
        ),
      );
    }
    return Future.value(null);
  }

Future<S?> showSuccessPopDialog<S>(String title, bool popup,bool close, String message) {
    if (mounted) {
      return showDialog<S>(
        useSafeArea: popup,
        context: context,
        builder: (ctx) => KSuccessDialog(
          button: close,
          title: title,
          message: message,
        ),
      );
    }
    return Future.value(null);
  }

  Future<S?> showWarningDialog<S>(String message) {
    if (mounted) {
      return showDialog<S>(
        context: context,
        builder: (ctx) => WarningDialog(
          title: 'Анхаар',
          message: message,
        ),
      );
    }
    return Future.value(null);
  }

  Future<S?> showCustomDialog<S>(
      BuildContext context, int type, String message) {
    if (mounted) {
      return showDialog<S>(
        context: context,
        builder: (ctx) =>
            CustomDialog(title: 'Анхаар', desc: message, type: type),
      );
    }
    return Future.value(null);
  }

  Future<void> tryWithDialog(
    AsyncCallback function, [
    AsyncCallback? onError,
  ]) async {
    try {
      await function.call();
    } catch (e) {
      final error = errorMapper(e);

      await onError?.call();

      showErrorDialog(error.description, title: error.error);
    }
  }
}
