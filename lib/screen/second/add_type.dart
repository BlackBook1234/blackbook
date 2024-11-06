import 'dart:async';

import 'package:black_book/bloc/category/bloc.dart';
import 'package:black_book/bloc/category/event.dart';
import 'package:black_book/bloc/category/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/screen/home/navigator.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/dynamic.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class AddTypeSecondScreen extends StatefulWidget {
  AddTypeSecondScreen({super.key, required this.itemType});
  @override
  State<AddTypeSecondScreen> createState() => _AddTypeSecondScreenState();
  String itemType;
}

class _AddTypeSecondScreenState extends State<AddTypeSecondScreen>
    with BaseStateMixin {
  List<DynamicWidget> dynamicList = [];
  final _bloc = CategoryBloc();
  final TextEditingController name = TextEditingController();
  final TextEditingController parent = TextEditingController();

  void addDynamic() {
    if (dynamicList.length > 10) {
      return;
    }
    dynamicList.add(DynamicWidget());
    setState(() {});
  }

  void onSubmit() {
    if (widget.itemType == "Өвөл") {
      setState(() {
        parent.text = "WINTER";
      });
    } else if (widget.itemType == "Зун") {
      setState(() {
        parent.text = "SUMMER";
      });
    } else if (widget.itemType == "Хавар") {
      setState(() {
        parent.text = "SPRING";
      });
    } else {
      setState(() {
        parent.text = "AUTUMN";
      });
    }
    _bloc.add(CreateCategoryEvent(name.text, parent.text));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<CategoryBloc, CategoryState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is CategoryLoading) {
                  Utils.startLoader(context);
                }
                if (state is CategoryFailure) {
                  if (state.message == "Token") {
                    _bloc.add(CreateCategoryEvent(name.text, parent.text));
                  } else {
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                  }
                }
                if (state is CategorySuccess) {
                  Utils.cancelLoader(context);
                  showSuccessDialog(
                      "Мэдээлэл", false, "Ангилал амжилттай хадгалагдлаа");
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const NavigatorScreen(screenIndex: 0,)),
                        (route) => false);
                  });
                }
              })
        ],
        child: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.keyboard_arrow_left, size: 30)),
                foregroundColor: kWhite,
                title: Image.asset('assets/images/logoSecond.png', width: 160),
                backgroundColor: kPrimarySecondColor),
            body: Column(children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 3,
                                          offset: const Offset(2, 2))
                                    ],
                                    borderRadius: BorderRadius.circular(10)),
                                child: InkWell(
                                    child: SizedBox(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(children: [
                                              Expanded(
                                                  child: Text(widget.itemType,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14))),
                                              // InkWell(
                                              //     onTap: () {
                                              //       addDynamic();
                                              //     },
                                              //     child: const Icon(Icons.add))
                                            ])))))),
                        SizedBox(
                            height: 50,
                            child: TextField(
                                textInputAction: TextInputAction.next,
                                controller: name,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    labelText: "Барааны ангилал нэрлэнэ үү",
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black38),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black12),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black26),
                                        borderRadius:
                                            BorderRadius.circular(10))))),
                        Expanded(
                            child: ListView.builder(
                                itemCount: dynamicList.length,
                                itemBuilder: (_, index) => dynamicList[index]))
                      ]))),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      width: double.infinity,
                      height: 50,
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
                            if (name.text.isEmpty) {
                              ErrorMessage.attentionMessage(
                                  context, "Нэр оруулна уу!");
                            } else {
                              onSubmit();
                            }
                          },
                          child: const Text("Хадгалах",
                              style: TextStyle(fontSize: 14)))))
            ])));
  }
}
