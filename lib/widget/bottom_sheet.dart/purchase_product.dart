import "package:black_book/bloc/product/bloc.dart";
import "package:black_book/bloc/product/event.dart";
import "package:black_book/bloc/product/state.dart";
import "package:black_book/constant.dart";
import "package:black_book/models/default/product_add.dart";
import "package:black_book/models/product/product_detial.dart";
import "package:black_book/models/product/product_inlist.dart";
import "package:black_book/util/utils.dart";
import "package:black_book/widget/alert/component/buttons.dart";
import "package:black_book/widget/alert/mixin_dialog.dart";
import "package:black_book/widget/dynamic_item.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";

class PurchaseProductBottom extends StatefulWidget {
  const PurchaseProductBottom({
    super.key,
    required this.data,
    required this.title,
  });
  @override
  State<PurchaseProductBottom> createState() => _BottomSheetsWidgetState();
  final String title;
  final ProductDetialModel data;
}

class _BottomSheetsWidgetState extends State<PurchaseProductBottom> with BaseStateMixin {
  final _bloc = ProductBloc();
  List<ProductAddSizeModel> listData = [];
  final TextEditingController productSize = TextEditingController();
  final TextEditingController productCount = TextEditingController();
  List<DynamicItemWidget> dynamicList = [];
  String warningText = "";
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    _controllers = widget.data.sizes!.map((size) {
      return TextEditingController(text: size.ware_stock.toString());
    }).toList();
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addDynamic() {
    if (dynamicList.length > 20) return;
    dynamicList.add(DynamicItemWidget(count: dynamicList.length + 1));
    setState(() {});
  }

  void changeOrderQty(ProductInDetialModel data, int type, int index) {
    if (type == 1) {
      if (data.ware_stock < 999) {
        setState(() {
          data.ware_stock++;
        });
      } else {
        setState(() {
          data.ware_stock = 999;
        });
      }
    } else if (type == 0) {
      if (data.ware_stock > 0) {
        setState(() {
          data.ware_stock--;
        });
      }
    }
    _controllers[index].text = data.ware_stock.toString();
  }

  addDataInDraft(List<ProductInDetialModel> data) {
    setState(() {
      listData.clear();
      warningText = "";
    });
    for (ProductInDetialModel otpList in data) {
      if (otpList.ware_stock != 0) {
        ProductAddSizeModel inData = ProductAddSizeModel(
          size: otpList.type,
          stock: otpList.ware_stock,
        );
        listData.add(inData);
      }
    }
    if (productCount.text.isNotEmpty && productSize.text.isNotEmpty) {
      ProductAddSizeModel otpData = ProductAddSizeModel(
        size: productSize.text,
        stock: int.parse(productCount.text),
      );
      listData.add(otpData);
    } else if ((productCount.text.isNotEmpty && productSize.text.isEmpty) || (productCount.text.isEmpty && productSize.text.isNotEmpty)) {
      setState(() {
        warningText = "Утга бүрэн оруулна уу!";
      });
    }
    if (dynamicList.isNotEmpty) {
      for (var element in dynamicList) {
        if (element.razmer.text != "" && element.countProduct.text != "") {
          ProductAddSizeModel otpDataSecond = ProductAddSizeModel(
            size: element.razmer.text,
            stock: int.parse(element.countProduct.text),
          );
          listData.add(otpDataSecond);
        } else if ((element.razmer.text.isNotEmpty && element.countProduct.text.isEmpty) || (element.razmer.text.isEmpty && element.countProduct.text.isNotEmpty)) {
          setState(() {
            warningText = "Утга бүрэн оруулна уу!";
          });
        }
      }
    }

    if (warningText != "") {
      showWarningDialog(warningText);
    } else if (listData.isEmpty && warningText == "") {
      showWarningDialog("Бараа оруулна уу");
    } else {
      _bloc.add(PurchaseProduct(listData, widget.data.good_id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductBloc, ProductState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is PurchaseProductLoading) {
                Utils.startLoader(context);
              }
              if (state is ProductFailure) {
                if (state.message == "Token") {
                  _bloc.add(PurchaseProduct(listData, widget.data.good_id!));
                } else {
                  Utils.cancelLoader(context);
                  showErrorDialog(state.message);
                }
              }
              if (state is PurchaseProductSuccess) {
                Utils.cancelLoader(context);
                listData.clear();
                showSuccessDialog("Мэдээлэл", false, "Амжилттай хадгаллаа");
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              }
            }),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            KeyboardDismissOnTap(
              dismissOnCapturedTaps: false,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  clipBehavior: Clip.hardEdge,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Column(
                      children: [
                        Column(children: [
                          Text(widget.title, style: const TextStyle(color: kPrimarySecondColor, fontSize: 16, fontWeight: FontWeight.bold)),
                          const Divider(),
                          Stack(children: [
                            ListTile(
                                leading: Container(
                                    height: 80.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                                    child: ClipRRect(borderRadius: BorderRadius.circular(9), child: widget.data.photo == null ? Image.asset("assets/images/saleProduct.jpg", fit: BoxFit.cover) : Image.network(widget.data.photo!))),
                                title: Text("Барааны нэр: ${widget.data.name}", style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
                                subtitle: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text("Барааны код: ${widget.data.code}", style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal)),
                                  Utils.getUserRole() == "BOSS" ? Text('Авсан үнэ: ${widget.data.sizes!.first.cost}₮', style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal)) : const SizedBox.shrink(),
                                  Text('Зарах үнэ: ${widget.data.sizes!.first.price}₮', style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal))
                                ])),
                            Positioned(
                              top: 20,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  addDynamic();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: kWhite, border: Border.all(color: kPrimaryColor), boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 3, offset: const Offset(2, 2))], borderRadius: BorderRadius.circular(10)),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.add, color: kPrimaryColor),
                                      SizedBox(width: 2),
                                      Text(
                                        "Размер\n нэмэх",
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ])
                        ]),
                        SizedBox(
                          height: widget.data.sizes!.length * 55,
                          child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 250),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.data.sizes!.length,
                              itemBuilder: (context, index) {
                                return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text('Үлдэгдэл: ${widget.data.sizes![index].stock}ш', style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal)),
                                    Text('Хэмжээ: ${widget.data.sizes![index].type}', style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal)),
                                  ]),
                                  Row(children: [
                                    MaterialButton(
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topLeft: Radius.circular(10))),
                                        height: 20,
                                        minWidth: 20.0,
                                        color: kPrimaryColor,
                                        textColor: Colors.white,
                                        child: const Text("-", style: TextStyle(fontSize: 10)),
                                        onPressed: () => {changeOrderQty(widget.data.sizes![index], 0, index)}),
                                    SizedBox(
                                        width: 35,
                                        height: 50,
                                        child: TextField(
                                            controller: _controllers[index],
                                            autofocus: true,
                                            style: const TextStyle(fontSize: 12),
                                            textAlign: TextAlign.center,
                                            onChanged: (value) {
                                              changeCount(widget.data.sizes![index], int.tryParse(value) ?? 0, index);
                                            },
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            keyboardType: TextInputType.number,
                                            textInputAction: TextInputAction.done,
                                            decoration: const InputDecoration(fillColor: kBackgroundColor, border: InputBorder.none, focusedBorder: InputBorder.none, enabledBorder: InputBorder.none, contentPadding: EdgeInsets.zero))),
                                    MaterialButton(
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10))),
                                        height: 20,
                                        minWidth: 20.0,
                                        color: kPrimaryColor,
                                        textColor: Colors.white,
                                        child: const Text("+", style: TextStyle(fontSize: 10)),
                                        onPressed: () => {changeOrderQty(widget.data.sizes![index], 1, index)})
                                  ])
                                ]);
                              }),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _buildTextField(productSize, "Размер")),
                            const SizedBox(width: 10),
                            Expanded(child: _buildNumberTextField(productCount, "Тоо ширхэг")),
                          ],
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dynamicList.length,
                          itemBuilder: (_, index) => dynamicList[index],
                        ),
                        const SizedBox(height: 20),
                        isKeyboardVisible
                            ? Column(
                                children: [
                                  BlackBookButton(
                                    height: 38,
                                    onPressed: () {
                                      addDynamic();
                                    },
                                    width: MediaQuery.of(context).size.width,
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add, color: kWhite),
                                        SizedBox(width: 2),
                                        Text(
                                          "Размер нэмэх",
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: BlackBookButton(
                                          height: 40,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Буцах"),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: BlackBookButton(
                                          height: 40,
                                          onPressed: () {
                                            addDataInDraft(widget.data.sizes!);
                                          },
                                          child: const Text("Хадгалах"),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 400)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            !isKeyboardVisible
                ? Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20, left: 20, bottom: MediaQuery.of(context).padding.bottom),
                      child: Column(
                        children: [
                          BlackBookButton(
                            height: 40,
                            onPressed: () {
                              addDynamic();
                            },
                            width: MediaQuery.of(context).size.width,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: kWhite),
                                SizedBox(width: 2),
                                Text(
                                  "Размер нэмэх",
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: BlackBookButton(
                                  height: 40,
                                  width: 140,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Буцах"),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: BlackBookButton(
                                  height: 40,
                                  width: 140,
                                  onPressed: () {
                                    addDataInDraft(widget.data.sizes!);
                                  },
                                  child: const Text("Хадгалах"),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
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
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black38),
            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberTextField(TextEditingController controller, String labelText) {
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
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black38),
            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  void changeCount(ProductInDetialModel data, int value, int index) {
    if (value >= 0) {
      if (value < 1000) {
        setState(() {
          data.ware_stock = value;
        });
      } else {
        setState(() {
          data.ware_stock = 999;
        });
      }
    }
    _controllers[index].text = data.ware_stock.toString();
  }
}
