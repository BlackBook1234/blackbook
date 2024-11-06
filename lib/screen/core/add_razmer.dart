import 'dart:async';
import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/default/razmer.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/screen/home/widget/banners_carousel.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/dynamic_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductAddSzieScreen extends StatefulWidget {
  final ProductDetialModel model;
  const ProductAddSzieScreen({Key? key, required this.model}) : super(key: key);
  @override
  State<ProductAddSzieScreen> createState() => _ProductAddSzieScreenState();
}

class _ProductAddSzieScreenState extends State<ProductAddSzieScreen>
    with BaseStateMixin {
  final TextEditingController productSize = TextEditingController();
  final TextEditingController productCount = TextEditingController();
  List<DynamicItemWidget> dynamicList = [];
  List<ProductRazmerModel> list = [];

  Future<void> _navigateAndDisplaySelection(context) async {
    try {
      await api
          .addProductSize(list: list)
          .then((value) => {Navigator.pop(context)});
    } on APIError catch (e) {
      showErrorDialog(e.message);
    }
  }

  void onCreate() => _navigateAndDisplaySelection(context);

  void addDynamic() {
    if (dynamicList.length > 9) return;
    dynamicList.add(DynamicItemWidget(count: dynamicList.length + 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            foregroundColor: kWhite,
            title: Image.asset('assets/images/logoSecond.png', width: 160),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.keyboard_arrow_left, size: 30)),
            backgroundColor: kPrimarySecondColor,
            actions: [
              InkWell(
                onTap: () {
                  addDynamic();
                },
                child: const Column(
                  children: [
                    Icon(Icons.add),
                    Text(
                      "Размер нэмэх",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      ListTile(
                          leading: Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: widget.model.photo == null
                                      ? Image.asset(
                                          "assets/images/saleProduct.jpg",
                                          fit: BoxFit.cover)
                                      : Image.network(widget.model.photo!))),
                          title: Text("Барааны нэр: ${widget.model.name}",
                              style: const TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold)),
                          subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Барааны код: ${widget.model.code}",
                                    style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal)),
                                Utils.getUserRole() == "BOSS"
                                    ? Text(
                                        'Авсан үнэ: ${widget.model.sizes!.first.cost}₮',
                                        style: const TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.normal))
                                    : const SizedBox.shrink(),
                                Text(
                                    'Зарах үнэ: ${widget.model.sizes!.first.price}₮',
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.normal))
                              ])),
                      SizedBox(height: getSize(20)),
                      Row(
                        children: [
                          Expanded(
                              child: _buildTextField(productSize, "Размер")),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _buildNumberTextField(
                                  productCount, "Тоо ширхэг")),
                        ],
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dynamicList.length,
                        itemBuilder: (_, index) => dynamicList[index],
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: BlackBookButton(
              onPressed: () => _saveData(context, widget.model),
              child: const Text("Хадгалах"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.next,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black38),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberTextField(
      TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textInputAction: TextInputAction.next,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black38),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  void _saveData(BuildContext context, ProductDetialModel model) {
    if (_validateFields()) {
      try {
        setState(() {
          ProductRazmerModel otpData = ProductRazmerModel(
            size: productSize.text,
            id: int.parse(model.good_id ?? "0"),
            stock: int.parse(productCount.text),
          );
          list.add(otpData);
          // if (dynamicList.isNotEmpty) {
          //   for (var element in dynamicList) {
          //     if (element.razmer.text != "" &&
          //         element.countProduct.text != "") {
          //       ProductDefaultModel otpDataSecond = ProductDefaultModel(
          //         cost: int.parse(price.text),
          //         price: int.parse(sellPrice.text),
          //         stock: int.parse(element.countProduct.text),
          //         type: element.razmer.text,
          //       );
          //       list.add(otpDataSecond);
          //     }
          //   }
          // }
          if (dynamicList.isNotEmpty) {
            for (var element in dynamicList) {
              if (element.razmer.text != "" &&
                  element.countProduct.text != "") {
                ProductRazmerModel otpDataSecond = ProductRazmerModel(
                  size: element.razmer.text,
                  id: int.parse(model.good_id ?? "0"),
                  stock: int.parse(element.countProduct.text),
                );
                list.add(otpDataSecond);
              }
            }
          }
        });
        onCreate();
      } catch (error) {
        showWarningDialog("Утга бүрэн оруулна уу!");
      }
    }
  }

  bool _validateFields() {
    if (productCount.text.isEmpty || productSize.text.isEmpty) {
      showWarningDialog("Бүх талбарыг бөглөнө үү!");
      return false;
    }
    return true;
  }
}
