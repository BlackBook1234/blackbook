import 'package:black_book/constant.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({super.key});

  _launchURL() async {
    Uri uri = Uri.parse("https://apps.apple.com/app/id6605930435");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.asset("assets/images/mainLogo.png",
                              fit: BoxFit.cover)))),
              SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Та аппликейшнаа шинэчилнэ үү!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: kTextMedium),
                    ),
                    const SizedBox(height: 20),
                    BlackBookButton(
                      onPressed: () {
                        _launchURL();
                      },
                      child: const Text("Шинэчилэх"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
