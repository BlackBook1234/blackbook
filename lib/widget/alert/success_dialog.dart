import 'package:black_book/constant.dart';
import 'package:black_book/widget/alert/component/utils.dart';
import 'package:flutter/material.dart';

import 'component/buttons.dart';

class KSuccessDialog extends StatelessWidget {
  const KSuccessDialog(
      {Key? key,
      required this.title,
      required this.message,
      this.button = false})
      : super(key: key);

  final String title;
  final String message;
  final bool button;

  @override
  Widget build(BuildContext context) {
    var titleStyle = const TextStyle(
      color: Color(0xff0F093B),
      fontWeight: FontWeight.w700,
      fontSize: 18,
    );
    var bodyStyle = const TextStyle(
      color: kTextMedium,
      fontWeight: FontWeight.normal,
      fontSize: 14,
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
              minHeight: 200, minWidth: 300, maxWidth: 300),
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Icon(
                      Icons.task_alt_outlined,
                      color: kSuccess,
                      size: 48,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: titleStyle,
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
                  button
                      ? Row(
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
                          ].map((e) => Expanded(child: e)).spaceBetween(16.0),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
