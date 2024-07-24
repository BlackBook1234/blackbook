import 'dart:io';

import 'package:black_book/bloc/authentication/bloc.dart';
import 'package:black_book/bloc/authentication/event.dart';
import 'package:black_book/bloc/authentication/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/component/utils.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/login_header.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'component/locker.dart';

// import 'component/locker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with BaseStateMixin {
  final _bloc = AuthenticationBloc();
  String deviceType = "";
  String deviceToken = "";
  final _mobileTextController = TextEditingController();
  final _loginButtonLocker = Locker(false);
  final _loginDisabler = Locker(true);
  String? mobileErrorText;

  @override
  void initState() {
    getDeviceType();
    _mobileTextController.addListener(_inputListener);
    _inputListener();
    super.initState();
  }

  @override
  void dispose() {
    _mobileTextController.removeListener(_inputListener);
    _mobileTextController.dispose();
    super.dispose();
  }

  void _inputListener() {
    _loginDisabler.value = !validatePhoneNumber(_mobileTextController.text);
    if (_mobileTextController.text.isNotEmpty) {
      if (validatePhoneNumber(_mobileTextController.text)) {
        mobileErrorText = null;
      } else {
        mobileErrorText = '8 оронтой утасны дугаар оруулна уу.';
      }
    } else {
      mobileErrorText = null;
    }

    setState(() {});
  }

  void onLogin(context) async {
    if (_loginButtonLocker.isLocked) return;
    _loginButtonLocker.lock();

    if (await checkNetworkS()) {
      _bloc.add(UserLoginEvent(
          deviceType, deviceToken, int.parse(_mobileTextController.text)));
    } else {
      _loginButtonLocker.unlock();
      showWarningDialog("Интернет холболтоо шалгана уу");
      // AlertMessage.statusMessage(
      //     context, "Анхаар!", "Интернет холболтоо шалгана уу", true);
    }
  }

  Future<void> getDeviceType() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;

      deviceType = "android";
      deviceToken = info.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;

      deviceType = "ios";
      deviceToken = info.name;
    } else {
      deviceType = "huawei";
      deviceToken = "huawei";
    }
  }

  Future<bool> checkNetworkS() {
    return checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, UserState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is UserLoading) {
                  // Utils.startLoader(context);
                }
                if (state is UserFailure) {
                  // Utils.cancelLoader(context);
                  _loginButtonLocker.unlock();
                  ErrorMessage.attentionMessage(context, state.message);
                }
                if (state is UserSuccess) {
                  _loginButtonLocker.unlock();
                  // Utils.cancelLoader(context);
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => AuthenticationScreen(
                          deviceToken: deviceToken,
                          deviceType: deviceType,
                          phoneNumber: _mobileTextController.text)));
                }
              })
        ],
        child: KeyboardDismissOnTap(
            dismissOnCapturedTaps: false,
            child: Scaffold(
                backgroundColor: Colors.white,
                extendBodyBehindAppBar: true,
                body: SingleChildScrollView(
                    child: Column(children: [
                  Stack(children: [
                    Opacity(
                        opacity: 0.8,
                        child: ClipPath(
                            clipper: Wave1(),
                            child:
                                Container(color: kPrimaryColor, height: 250))),
                    ClipPath(
                        clipper: Wave2(),
                        child: Container(
                            color: kPrimarySecondColor,
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                                child: Image.asset(
                                    'assets/images/logoSecond.png',
                                    width: 300))))
                  ]),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 32),
                      child: ListView(shrinkWrap: true, children: [
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
                        
                        LockerBuilder(
                          locker: _loginButtonLocker,
                          onLocked: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(14.0, 0.0, 14.0, 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    "Утасны дугаар",
                                    style: TextStyle(
                                        color: Colors.black38, fontSize: 12),
                                  ),
                                ),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  alignment: Alignment.topCenter,
                                  child: TextField(
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    controller: _mobileTextController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    autofillHints: const [
                                      AutofillHints.telephoneNumberLocal,
                                      AutofillHints.telephoneNumberNational,
                                    ],
                                    decoration: InputDecoration(
                                      errorText: mobileErrorText,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 24.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          onUnlocked: buildMainSection(),
                        ),
                      ]))
                ])))));
  }

  Widget buildMobileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Утасны дугаар",
            style: TextStyle(color: Colors.black38, fontSize: 12),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: TextField(
            maxLines: 1,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            controller: _mobileTextController,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofillHints: const [
              AutofillHints.telephoneNumberLocal,
              AutofillHints.telephoneNumberNational,
            ],
            decoration: InputDecoration(
              errorText: mobileErrorText,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMainSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14.0, 0.0, 14.0, 0.0),
      child: Column(
        children: [
          buildMobileField(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, top: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _loginDisabler,
                    builder: (context, isDisabled, child) {
                      return BlackBookButton(
                        borderRadius: 20,
                        onPressed: () {
                          onLogin(context);
                        },
                        disabled: isDisabled,
                        child: LockerBuilder(
                          locker: _loginButtonLocker,
                          onLocked: const Center(
                            child: CupertinoActivityIndicator(
                              color: kPrimaryColor,
                            ),
                          ),
                          onUnlocked: const Text("Нэвтрэх"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
