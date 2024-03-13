import 'package:black_book/bloc/authentication/bloc.dart';
import 'package:black_book/bloc/authentication/event.dart';
import 'package:black_book/bloc/authentication/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/screen/login/login_controller.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:black_book/widget/login_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _bloc = AuthenticationBloc();
  final TextEditingController phoneNumber = TextEditingController();
  final ctrl = Get.put(LoginController());

  void onLogin() {
    _bloc.add(UserLoginEvent(
        ctrl.deviceType, ctrl.deviceToken, int.parse(phoneNumber.text)));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, UserState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is UserLoading) {
                  Utils.startLoader(context);
                }
                if (state is UserFailure) {
                  Utils.cancelLoader(context);
                  ErrorMessage.attentionMessage(context, state.message);
                }
                if (state is UserSuccess) {
                  Utils.cancelLoader(context);
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => AuthenticationScreen(
                          deviceToken: ctrl.deviceToken,
                          deviceType: ctrl.deviceType,
                          phoneNumber: phoneNumber.text)));
                }
              })
        ],
        child: Scaffold(
            backgroundColor: kWhite,
            body: SingleChildScrollView(
                child: Column(children: [
              Stack(children: [
                Opacity(
                    opacity: 0.8,
                    child: ClipPath(
                        clipper: Wave1(),
                        child: Container(color: kPrimaryColor, height: 250))),
                ClipPath(
                    clipper: Wave2(),
                    child: Container(
                        color: kPrimarySecondColor,
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Image.asset('assets/images/logoSecond.png',
                                width: 300))))
              ]),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                  child: Column(children: [
                    const Text("ТАВТАЙ МОРИЛНО УУ.",
                        style: TextStyle(
                            fontSize: 22,
                            color: kPrimarySecondColor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const Text("Утасны дугаараа оруулна уу?",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 28),
                    Container(
                        decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(children: [
                          SizedBox(
                              height: 70,
                              child: Center(
                                  child: TextFormField(
                                      controller: phoneNumber,
                                      maxLength: 8,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black12),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black12),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          prefix: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: Text("(+976)",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight
                                                          .bold))))))),
                          const SizedBox(height: 10),
                          Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    kPrimaryColor,
                                    Colors.orange.shade300,
                                    kPrimaryColor
                                  ]),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: kWhite),
                                  onPressed: () {
                                    if (phoneNumber.text.length == 8) {
                                      onLogin();
                                    } else {
                                      ErrorMessage.attentionMessage(context,
                                          "Дугаараа бүрэн оруулна уу!");
                                    }
                                  },
                                  child: const Text("Илгээх",
                                      style: TextStyle(fontSize: 14))))
                        ]))
                  ]))
            ]))));
  }
}
