import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/screen/home/navigator.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class BpayAllowPage extends StatefulWidget {
  const BpayAllowPage({Key? key}) : super(key: key);

  @override
  State<BpayAllowPage> createState() => _BpayAllowPageState();
}

class _BpayAllowPageState extends State<BpayAllowPage> with BaseStateMixin {
  bool isChecked = false;
  late String body = "";
  bool isEdit = false;

  @override
  void initState() {
    _getAgreement();
    super.initState();
  }

  Future<void> _getAgreement() async {
    try {
      var res = await api.getAgreement();
      setState(() {
        body = res.data.first.content;
      });
    } on APIError catch (e) {
      showErrorDialog(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: KeyboardDismissOnTap(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (body.isNotEmpty) HtmlWidget(body),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: KeyboardVisibilityBuilder(
          builder: (context, visible) {
            return Padding(
              padding: EdgeInsets.only(right: 10, left: 10, bottom: MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                    child: Row(
                      children: [
                        AnimatedContainer(
                            margin: EdgeInsets.zero,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width: (24),
                            height: (24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: isChecked ? null : Border.all(color: Colors.grey),
                              color: isChecked ? kPrimaryColor : Colors.white,
                            ),
                            child: isChecked
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: (14),
                                  )
                                : null),
                        const SizedBox(width: 10),
                        const Text(
                          "Би үйлчилгээний нөхцөлийг зөвшөөрч байна.",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  BlackBookButton(
                    width: double.infinity,
                    onPressed: () {
                      if (isChecked) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const NavigatorScreen(
                                      screenIndex: 0,
                                    )),
                            (route) => false);
                      }
                    },
                    child: const Text("Үргэлжлүүлэх"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
