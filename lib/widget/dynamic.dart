import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DynamicWidget extends StatelessWidget {
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  DynamicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: 70,
            child: TextField(
                textInputAction: TextInputAction.next,
                onChanged: (value) {},
                maxLength: 100,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    labelText: "Барааны ангилал нэрлэнэ үү",
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black38),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black26),
                        borderRadius: BorderRadius.circular(10)))));
  }
}
