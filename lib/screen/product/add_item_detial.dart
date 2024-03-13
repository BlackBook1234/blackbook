import 'dart:async';
import 'package:black_book/constant.dart';
import 'package:black_book/models/default/product.dart';
import 'package:black_book/widget/camera.dart';
import 'package:black_book/widget/dynamic_item.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class AddItemDetialScreen extends StatefulWidget {
  AddItemDetialScreen({super.key, required this.id});
  @override
  State<AddItemDetialScreen> createState() => _AddItemDetialScreenState();
  int id;
}

class _AddItemDetialScreenState extends State<AddItemDetialScreen> {
  final TextEditingController productCode = TextEditingController();
  final TextEditingController productName = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController sellPrice = TextEditingController();
  final TextEditingController productSize = TextEditingController();
  final TextEditingController productCount = TextEditingController();
  List<DynamicItemWidget> dynamicList = [];
  List<ProductDefaultModel> list = [];

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final cameras = await availableCameras();
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraScreen(
                cameras: cameras,
                productName: productName.text,
                productCode: productCode.text,
                id: widget.id,
                list: list)));
  }

  void onCreate() {
    _navigateAndDisplaySelection(context);
  }

  void addDynamic() {
    if (dynamicList.length > 9) {
      return;
    }
    dynamicList.add(DynamicItemWidget(count: dynamicList.length + 1));
    setState(() {});
  }

  // void submitData() {
  //   setState(() {
  //     for (var element in dynamicList) {
  //       ProductDefaultModel otpData = ProductDefaultModel(
  //           cost: int.parse(sellPrice.text),
  //           price: int.parse(price.text),
  //           stock: int.parse(element.countProduct.text),
  //           type: element.razmer.text);
  //       list.add(otpData);
  //       // print(element.description);
  //     }
  //     print(list.map((e) => e.toJson()).toList());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: true,
      resizeToAvoidBottomInset: false,
      drawerEnableOpenDragGesture: false,
      // extendBody: true,
      appBar: AppBar(
          foregroundColor: kWhite,
          title: Image.asset('assets/images/logoSecond.png', width: 160),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.keyboard_arrow_left, size: 30)),
          backgroundColor: kPrimarySecondColor),
      body: Column(children: [
        Expanded(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 10),
                          child: SizedBox(
                              height: 50,
                              child: TextField(
                                  controller: productCode,
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                      labelText: "Барааны код",
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
                                              BorderRadius.circular(10)))))),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                              height: 50,
                              child: TextField(
                                  controller: productName,
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    labelText: "Барааны нэр",
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
                                            BorderRadius.circular(10)),
                                  )))),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                              height: 50,
                              child: TextField(
                                  controller: price,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    labelText: "Ирсэн үнэ",
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
                                            BorderRadius.circular(10)),
                                  )))),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                              height: 50,
                              child: TextField(
                                  controller: sellPrice,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    labelText: "Зарах үнэ",
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
                                            BorderRadius.circular(10)),
                                  )))),
                      Row(children: [
                        Expanded(
                            child: SizedBox(
                                height: 50,
                                child: TextField(
                                    controller: productSize,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      labelText: "Размер",
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
                                              BorderRadius.circular(10)),
                                    )))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: SizedBox(
                                height: 50,
                                child: TextField(
                                    controller: productCount,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        labelText: "Тоо ширхэг",
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
                                                BorderRadius.circular(10))))))
                      ]),
                      SizedBox(
                          height: 67.0 * dynamicList.length,
                          child: NotificationListener<ScrollNotification>(
                              child: ListView.builder(
                                  itemCount: dynamicList.length,
                                  itemBuilder: (_, index) =>
                                      dynamicList[index]))),
                      const SizedBox(height: 10),
                      Container(
                          width: 110,
                          height: 40,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: kPrimaryColor,
                                    blurRadius: 7.0,
                                    spreadRadius: -2)
                              ],
                              color: Colors.transparent,
                              border:
                                  Border.all(width: 1, color: kPrimaryColor),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: Container(
                                  width: 102,
                                  height: 32,
                                  decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: TextButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: kWhite),
                                      onPressed: () {
                                        addDynamic();
                                      },
                                      child: const Text("Багц нэмэх",
                                          style: TextStyle(fontSize: 14))))))
                    ])))),
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
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
                    style: ElevatedButton.styleFrom(foregroundColor: kWhite),
                    onPressed: () {
                      if (productName.text.isEmpty) {
                        ErrorMessage.attentionMessage(
                            context, "Нэр оруулна уу!");
                      } else if (productCode.text.isEmpty) {
                        ErrorMessage.attentionMessage(
                            context, "Код оруулна уу!");
                      } else if (price.text.isEmpty) {
                        ErrorMessage.attentionMessage(
                            context, "Авсан үнэ оруулна уу!");
                      } else if (sellPrice.text.isEmpty) {
                        ErrorMessage.attentionMessage(
                            context, "Зарах үнэ оруулна уу!");
                      } else if (productCount.text.isEmpty) {
                        ErrorMessage.attentionMessage(
                            context, "Тоо ширхэг оруулна уу!");
                      } else if (productSize.text.isEmpty) {
                        ErrorMessage.attentionMessage(
                            context, "Хэмжээ оруулна уу!");
                      } else {
                        onCreate();
                        setState(() {
                          ProductDefaultModel otpData = ProductDefaultModel(
                              cost: int.parse(sellPrice.text),
                              price: int.parse(price.text),
                              stock: int.parse(productCount.text),
                              type: productSize.text);
                          list.add(otpData);
                          for (var element in dynamicList) {
                            ProductDefaultModel otpDataSecond =
                                ProductDefaultModel(
                                    cost: int.parse(sellPrice.text),
                                    price: int.parse(price.text),
                                    stock: int.parse(element.countProduct.text),
                                    type: element.razmer.text);
                            list.add(otpDataSecond);
                            for (ProductDefaultModel data in list) {
                              if (data.price == null ||
                                  data.cost == null ||
                                  data.stock == null ||
                                  data.type == '' ||
                                  data.type == null) {
                                ErrorMessage.attentionMessage(
                                    context, "Утга бүрэн оруулна уу!");
                              } else {
                                // onCreate();
                              }
                            }
                          }
                        });
                      }
                    },
                    child: const Text("Хадгалах",
                        style: TextStyle(fontSize: 14)))))
      ]),
      // items: [
      //   HawkFabMenuItem(
      //       label: 'Багц нэмэх',
      //       ontap: () {
      //         addDynamic();
      //       },
      //       icon: const Icon(Icons.add_circle, color: kPrimaryColor),
      //       color: kWhite,
      //       labelColor: kPrimaryColor),
      //   HawkFabMenuItem(
      //       label: 'Зураг',
      //       ontap: () {
      //         _navigateAndDisplaySelection(context);
      //       },
      //       icon: const Icon(Icons.add_a_photo, color: kPrimaryColor),
      //       color: kWhite,
      //       labelColor: kPrimaryColor)
      // ]
    );
  }
}
