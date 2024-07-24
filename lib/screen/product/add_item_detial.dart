import 'dart:async';
import 'package:black_book/constant.dart';
import 'package:black_book/models/default/product.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/camera.dart';
import 'package:black_book/widget/dynamic_item.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddItemDetialScreen extends StatefulWidget {
  final int id;
  const AddItemDetialScreen({Key? key, required this.id}) : super(key: key);
  @override
  State<AddItemDetialScreen> createState() => _AddItemDetialScreenState();
}

class _AddItemDetialScreenState extends State<AddItemDetialScreen>
    with BaseStateMixin {
  final TextEditingController productCode = TextEditingController();
  final TextEditingController productName = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController sellPrice = TextEditingController();
  final TextEditingController productSize = TextEditingController();
  final TextEditingController productCount = TextEditingController();
  List<DynamicItemWidget> dynamicList = [];
  List<ProductDefaultModel> list = [];

  Future<void> _navigateAndDisplaySelection(context) async {
    await availableCameras().then((value) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CameraScreen(
                  cameras: value,
                  productName: productName.text,
                  productCode: productCode.text,
                  id: widget.id,
                  list: list,
                ))));
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
                      _buildTextField(productCode, "Барааны код"),
                      _buildTextField(productName, "Барааны нэр"),
                      _buildNumberTextField(price, "Ирсэн үнэ"),
                      _buildNumberTextField(sellPrice, "Зарах үнэ"),
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
              onPressed: () => _saveData(context),
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

//TODO baraa shineer uusgeh aldaatai bsn
  void _saveData(BuildContext context) {
    list.clear();
    if (_validateFields()) {
      try {
        setState(() {
          ProductDefaultModel otpData = ProductDefaultModel(
            cost: int.parse(price.text),
            price: int.parse(sellPrice.text),
            stock: int.parse(productCount.text),
            type: productSize.text,
          );
          list.add(otpData);
          if (dynamicList.isNotEmpty) {
            for (var element in dynamicList) {
              ProductDefaultModel otpDataSecond = ProductDefaultModel(
                cost: int.parse(price.text),
                price: int.parse(sellPrice.text),
                stock: int.parse(element.countProduct.text),
                type: element.razmer.text,
              );
              for (ProductDefaultModel data in list) {
                if (data.price == null ||
                    data.cost == null ||
                    data.stock == null ||
                    data.type == '' ||
                    data.type == null) {
                  showWarningDialog("Утга бүрэн оруулна уу!");
                  return;
                }
              }
              list.add(otpDataSecond);
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
    if (productName.text.isEmpty ||
        productCode.text.isEmpty ||
        price.text.isEmpty ||
        sellPrice.text.isEmpty ||
        productCount.text.isEmpty ||
        productSize.text.isEmpty) {
      showWarningDialog("Бүх талбарыг бөглөнө үү!");
      return false;
    }
    return true;
  }
}
