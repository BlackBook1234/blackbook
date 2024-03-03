import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class DynamicItemWidget extends StatelessWidget {
  TextEditingController razmer = TextEditingController();
  TextEditingController countProduct = TextEditingController();
  int count;

  DynamicItemWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 67,
        child: Column(children: [
          Row(children: [
            const Expanded(child: Divider()),
            Text("  $count  ",
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Expanded(child: Divider())
          ]),
          Row(children: [
            Expanded(
                child: SizedBox(
                    height: 50,
                    child: TextField(
                        controller: razmer,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Размер",
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black38),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(10)),
                        )))),
            const SizedBox(width: 10),
            Expanded(
                child: SizedBox(
                    height: 50,
                    child: TextField(
                        controller: countProduct,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            labelText: "Тоо ширхэг",
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black38),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black26),
                                borderRadius: BorderRadius.circular(10))))))
          ])
        ]));
  }
}
