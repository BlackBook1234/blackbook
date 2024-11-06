// ignore: must_be_immutable
import 'package:black_book/constant.dart';
import 'package:black_book/global_keys.dart';
import 'package:black_book/provider/type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TypeBuilder extends StatelessWidget {
  Function? chooseType;
  Function? chooseStore;
  final String userRole;
  final List<String>? typeStore;
  String chosenValue;
  String chosenType;
  // List<String> typeValue;

  TypeBuilder(
      {super.key,
      required this.chosenValue,
      required this.chosenType,
      this.chooseType,
      this.chooseStore,
      required this.userRole,
      this.typeStore});

  final List<String> typeValue = ["Бүх төрөл", "Өвөл", "Хавар", "Намар", "Зун"];
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(children: [
          userRole == "BOSS"
              ? Expanded(
                  child: Container(
                      width: 80,
                      height: 38,
                      decoration: BoxDecoration(
                          color: kWhite,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 3,
                                offset: const Offset(2, 2))
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: DropdownButton<String>(
                              isExpanded: true,
                              iconEnabledColor: kPrimarySecondColor,
                              value: chosenType,
                              style: const TextStyle(
                                  color: kPrimarySecondColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              items: typeStore!.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                              underline: Container(
                                  height: 0, color: Colors.transparent),
                              onChanged: (value) {
                                chooseStore?.call(value);
                              }))))
              : const SizedBox(width: 0),
          const SizedBox(width: 10),
          Expanded(
              child: Container(
                  width: 80,
                  height: 38,
                  decoration: BoxDecoration(
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 3,
                            offset: const Offset(2, 2))
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: DropdownButton<String>(
                          isExpanded: true,
                          iconEnabledColor: kPrimarySecondColor,
                          value: chosenValue,
                          style: const TextStyle(
                              color: kPrimarySecondColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                          items: Provider.of<TypeProvider>(
                                  GlobalKeys.navigatorKey.currentContext!,
                                  listen: false)
                              .typeList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                          underline:
                              Container(height: 0, color: Colors.transparent),
                          onChanged: (value) {
                            chooseType?.call(value!);
                          }))))
        ]));
  }
}
