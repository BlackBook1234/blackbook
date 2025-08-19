import 'package:black_book/provider/user_provider.dart';
import 'package:black_book/screen/login/login.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentExpireDialog extends StatelessWidget {
  const PaymentExpireDialog({super.key});

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
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(height: 40, width: 40, child: ClipRRect(borderRadius: BorderRadius.circular(9), child: Image.asset("assets/images/mainLogo.png", fit: BoxFit.cover)))),
                SizedBox(
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Агуулахын эрхээр нэвтэрч сунгалтаа хийнэ үү. Хугацаа дууссан байна",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      BlackBookButton(
                        width: double.infinity,
                        onPressed: () {
                          Provider.of<CommonProvider>(context, listen: false).logout();
                          Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                        },
                        child: const Text("Гарах"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
