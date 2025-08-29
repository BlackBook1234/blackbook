import 'package:black_book/models/user_data/user_data.dart';
import 'package:black_book/provider/user_provider.dart';
import 'package:black_book/screen/login/login.dart';
import 'package:black_book/screen/login/packages.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentExpireDialog extends StatefulWidget {
  const PaymentExpireDialog({super.key});

  @override
  State<PaymentExpireDialog> createState() => _PaymentExpireDialogState();
}

class _PaymentExpireDialogState extends State<PaymentExpireDialog> with BaseStateMixin {
  Future<void> callUserData(BuildContext context) async {
    UserDataModel data = await api.refreshToken();
    if (!DateTime.parse(data.paymentExpireDate ?? "2050-01-01").isBefore(DateTime.now())) {
      Navigator.pop(context);
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
                      Text(
                        Utils.getUserRole() == "BOSS" ? "Хугацаа дууссан байна" : "Агуулахын эрхээр нэвтэрч сунгалтаа хийнэ үү. Хугацаа дууссан байна",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                      SizedBox(height: Utils.getUserRole() == "BOSS" ? 60 : 20),
                      BlackBookButton(
                        width: double.infinity,
                        onPressed: () {
                          if (Utils.getUserRole() == "BOSS") {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => const Packages("/v1/payment/packages", "", true))).then((val) => {callUserData(context)});
                          } else {
                            Provider.of<CommonProvider>(context, listen: false).logout();
                            Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                          }
                        },
                        child: Text(Utils.getUserRole() == "BOSS" ? "Сунгах" : "Гарах"),
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
