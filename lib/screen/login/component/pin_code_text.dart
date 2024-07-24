import 'package:black_book/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class PinTextField extends StatelessWidget {
  const PinTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.height = 60.0,
    this.width = 48.0,
    this.autofocus = false,
    this.androidSmsAutofillMethod = AndroidSmsAutofillMethod.none,
    this.obscureText = false,
    this.senderPhoneNumber,
  }) : super(key: key);
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final double? height;
  final double? width;
  final bool autofocus;
  final bool obscureText;
  final String? senderPhoneNumber;
  final AndroidSmsAutofillMethod androidSmsAutofillMethod;

  @override
  Widget build(BuildContext context) {
    return Pinput(
      autofocus: autofocus,
      focusNode: focusNode,
      controller: controller,
      length: 6,
      androidSmsAutofillMethod: androidSmsAutofillMethod,
      senderPhoneNumber: senderPhoneNumber,
      obscureText: obscureText,
      listenForMultipleSmsOnAndroid: true,
      onSubmitted: (value) {},
      closeKeyboardWhenCompleted: false,
      // obscuringWidget: ,
      defaultPinTheme: PinTheme(
        height: height,
        width: width,
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: kTextDark,
        ),
      ),
      followingPinTheme: PinTheme(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xffF8F7FC),
          border: Border.all(width: 1, color: const Color(0xffECEAF5)),
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: kTextDark,
        ),
      ),
      focusedPinTheme: PinTheme(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: kPrimaryColor),
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: kTextDark,
        ),
      ),
      submittedPinTheme: PinTheme(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: kPrimaryColor.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: kTextDark,
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      autofillHints: const [AutofillHints.oneTimeCode],
    );
  }
}
