import 'dart:async';

import 'package:black_book/bloc/authentication/bloc.dart';
import 'package:black_book/bloc/authentication/event.dart';
import 'package:black_book/bloc/authentication/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/screen/home/navigator.dart';
import 'package:black_book/util/router.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pinput/pinput.dart';
// import 'package:pinput/pinput.dart';
import 'component/pin_code_text.dart';
import 'packages.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen(
      {super.key,
      required this.deviceToken,
      required this.deviceType,
      required this.phoneNumber});
  @override
  State<AuthenticationScreen> createState() => _LoginScreenState();
  final String deviceType;
  final String deviceToken;
  final String phoneNumber;
}

class _LoginScreenState extends State<AuthenticationScreen>
    with BaseStateMixin {
  int timer = 120;
  String showTimer = '02:00';
  late Timer _timer;
  Timer? loadingTimer;
  final _bloc = AuthenticationBloc();
  bool _isInputValid = false;
  final _otpTxtCtrl = TextEditingController();

  void onLogin() {
    if (!_isInputValid) return;
    String resultString = _otpTxtCtrl.text;
    if (resultString.length == 6) {
      _bloc.add(UserAuthenticationEvent(widget.deviceType, widget.deviceToken,
          int.tryParse(widget.phoneNumber) ?? 0, _otpTxtCtrl.text));
    } else {
      ErrorMessage.attentionMessage(context, "6 оронтой тоо оруулна уу!");
    }
  }

  @override
  void initState() {
    _otpTxtCtrl.addListener(_tanInputListener);
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpTxtCtrl.removeListener(_tanInputListener);
    _otpTxtCtrl.dispose();
    super.dispose();
  }

  void _tanInputListener() {
    setState(() {
      var otp = _otpTxtCtrl.text;
      _isInputValid = RegExp(r'\d{4}').hasMatch(otp);
    });
  }

  String formatTime(int seconds) {
    Duration duration = Duration(seconds: seconds);
    int minutes = duration.inMinutes;
    int remainingSeconds = duration.inSeconds % 60;
    String formattedTime =
        '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  void startTimer() {
    const onesec = Duration(seconds: 1);
    _timer = Timer.periodic(onesec, (Timer time) {
      if (!mounted) {
        time.cancel();
        return;
      }
      setState(() {
        if (timer < 1) {
          time.cancel();
        } else {
          timer--;
          showTimer = formatTime(timer);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, UserState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is UserAuthenticationLoading) {
                Utils.startLoader(context);
              }
              if (state is UserAuthenticationFailure) {
                Utils.cancelLoader(context);
                ErrorMessage.attentionMessage(context, state.message);
              }
              if (state is UserAuthenticationSuccess) {
                Utils.cancelLoader(context);
                if (state.data.type == "WORKER") {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const NavigatorScreen(
                            screenIndex: 0,
                          )));
                } else if (state.data.paymentExpireDate == null) {
                  Navigator.push(
                      context,
                      NoSwipeCupertinoRoute(
                          builder: (context) => const Packages(
                              '/v1/payment/packages', "", false)));
                } else if (DateTime.parse(state.data.paymentExpireDate ?? "")
                    .isAfter(DateTime.now())) {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const NavigatorScreen(
                            screenIndex: 0,
                          )));
                } else {
                  Navigator.push(
                      context,
                      NoSwipeCupertinoRoute(
                          builder: (context) => const Packages(
                              '/v1/payment/packages', "", false)));
                }
              }
            })
      ],
      child: KeyboardDismissOnTap(
        dismissOnCapturedTaps: false,
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: kBackgroundColor,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30))),
          body: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(children: [
                    SizedBox(
                        height: 80,
                        child: Image.asset('assets/images/logo.png')),
                    const SizedBox(height: 10),
                    const Text(
                        "Таны утсан дээр ирсэн 6 оронтой баталгаажуулах тоог оруулна уу.",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold)),
                    // const SizedBox(height: 18),
                    // Container(
                    //     decoration: BoxDecoration(
                    //         color: kBackgroundColor,
                    //         borderRadius: BorderRadius.circular(12)),
                    //     child: Column(children: [
                    //       Row(
                    //           mainAxisAlignment:
                    //               MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             numberInputArea(first: true, index: 0),
                    //             numberInputArea(first: false, index: 1),
                    //             numberInputArea(first: false, index: 2),
                    //             numberInputArea(first: false, index: 3),
                    //             numberInputArea(first: false, index: 4),
                    //             numberInputArea(first: false, index: 5)
                    //           ])
                    //     ])),
                  ])),
              _buildBody(),
              const Spacer(),
              Text(showTimer,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: MediaQuery.of(context).padding.bottom),
                child: BlackBookButton(
                  width: double.infinity,
                  onPressed: () {
                    if (showTimer == "0:00") {
                      showWarningDialog(
                          "Хугацаа дуусхаас өмнө баталгаажуулах тоог оруулна уу");
                    } else {
                      onLogin();
                    }
                  },
                  child: const Text("Баталгаажуулах"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // numberInputArea({required bool first, required int index}) {
  //   return SizedBox(
  //       height: 85,
  //       child: AspectRatio(
  //           aspectRatio: 0.5,
  //           child: TextField(
  //               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //               controller: controllers[index],
  //               onChanged: (value) {
  //                 if (value.length == 1) {
  //                   FocusScope.of(context).nextFocus();
  //                 }
  //                 if (value.isEmpty) {
  //                   FocusScope.of(context).previousFocus();
  //                 }
  //               },
  //               style: Theme.of(context).textTheme.bodyLarge,
  //               showCursor: false,
  //               readOnly: false,
  //               textAlign: TextAlign.center,
  //               keyboardType: TextInputType.number,
  //               maxLength: 1,
  //               decoration:const InputDecoration(
  //                 counter:  Offstage(),
  //               ))));
  // }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: PinTextField(
              autofocus: true,
              controller: _otpTxtCtrl,
              androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsUserConsentApi,
            ),
          ),
        ],
      ),
    );
  }
}
