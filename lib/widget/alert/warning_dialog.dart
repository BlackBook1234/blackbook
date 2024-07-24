import 'package:black_book/constant.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/component/dialog_entry_animation.dart';
import 'package:black_book/widget/alert/component/utils.dart';
import 'package:flutter/material.dart';
import 'component/dialog_box.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog({Key? key, required this.title, required this.message})
      : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    var bodyStyle = const TextStyle(
      color: kTextMedium,
      fontWeight: FontWeight.normal,
      fontSize: 14,
    );
    return DialogEntryAnimation(
      child: DialogBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Icon(
                Icons.warning,
                color: kDanger,
                size: 48,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: kTextDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                message,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: bodyStyle,
              ),
            ),
            Row(
              children: [
                BlackBookButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  color: kPrimaryColor,
                  contentColor: kWhite,
                  shadow: false,
                  child: const Text(
                    'Хаах',
                  ),
                ),
              ].map((e) => Expanded(child: e)).spaceBetween(12.0),
            ),
          ],
        ),
      ),
    );
  }
}
