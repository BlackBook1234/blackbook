import 'dart:async';

import 'package:black_book/bloc/authentication/bloc.dart';
import 'package:black_book/bloc/authentication/event.dart';
import 'package:black_book/bloc/authentication/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/screen/home/navigator.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'packages.dart';

// ignore: must_be_immutable
class AuthenticationScreen extends StatefulWidget {
  AuthenticationScreen(
      {super.key,
      required this.deviceToken,
      required this.deviceType,
      required this.phoneNumber});
  @override
  State<AuthenticationScreen> createState() => _LoginScreenState();
  String deviceType;
  String deviceToken;
  String phoneNumber;
}

class _LoginScreenState extends State<AuthenticationScreen> {
  int timer = 120;
  String showTimer = '02:00';
  late Timer _timer;
  Timer? loadingTimer;
  final _bloc = AuthenticationBloc();

  final List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());

  void onLogin() {
    List<String> otpStrings =
        controllers.map((controller) => controller.text).toList();
    String resultString = otpStrings.join();
    if (resultString.length == 6) {
      _bloc.add(UserAuthenticationEvent(widget.deviceType, widget.deviceToken,
          int.tryParse(widget.phoneNumber) ?? 0, resultString.toString()));
    } else {
      ErrorMessage.attentionMessage(context, "6 оронтой тоо оруулна уу!");
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                  if (state.data.isPaid == 1) {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => NavigatorScreen()));
                  } else {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => const Packages()));
                  }
                }
              })
        ],
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: kBackgroundColor,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.keyboard_arrow_left, size: 30))),
            body: Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Padding(
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
                            const SizedBox(height: 18),
                            Container(
                                decoration: BoxDecoration(
                                    color: kBackgroundColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        numberInputArea(first: true, index: 0),
                                        numberInputArea(first: false, index: 1),
                                        numberInputArea(first: false, index: 2),
                                        numberInputArea(first: false, index: 3),
                                        numberInputArea(first: false, index: 4),
                                        numberInputArea(first: false, index: 5)
                                      ])
                                ])),
                            Text(showTimer,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold))
                          ])))),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
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
                          style:
                              ElevatedButton.styleFrom(foregroundColor: kWhite),
                          onPressed: () {
                            if (showTimer == "0:00") {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                        icon: Icon(Icons.info,
                                            size: 30, color: kPrimaryColor),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        scrollable: true,
                                        title: Text("Амжилтгүй",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center),
                                        contentPadding: EdgeInsets.only(
                                            right: 20,
                                            left: 20,
                                            bottom: 20,
                                            top: 10),
                                        content: Column(children: [
                                          Text(
                                              "Хугацаа дуусхаас өмнө баталгаажуулах тоог оруулна уу",
                                              textAlign: TextAlign.center),
                                          SizedBox(height: 20)
                                        ]));
                                  });
                            } else {
                              onLogin();
                            }
                          },
                          child: const Text("Баталгаажуулах",
                              style: TextStyle(fontSize: 14)))))
            ])));
  }

  numberInputArea({required bool first, required int index}) {
    return SizedBox(
        height: 85,
        child: AspectRatio(
            aspectRatio: 0.5,
            child: TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: controllers[index],
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.isEmpty) {
                    FocusScope.of(context).previousFocus();
                  }
                },
                style: Theme.of(context).textTheme.titleLarge,
                showCursor: false,
                readOnly: false,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: InputDecoration(
                    counter: const Offstage(),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.black12),
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(12))))));
  }
}
