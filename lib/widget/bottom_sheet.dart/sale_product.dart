import 'package:black_book/bloc/sale/bloc.dart';
import 'package:black_book/bloc/sale/event.dart';
import 'package:black_book/bloc/sale/state.dart';
import "package:black_book/constant.dart";
import "package:black_book/models/product/product_detial.dart";
import "package:black_book/models/product/product_inlist.dart";
import "package:black_book/util/utils.dart";
import "package:black_book/widget/alert/mixin_dialog.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";

class SellProductBottomSheetsWidget extends StatefulWidget {
  const SellProductBottomSheetsWidget({
    super.key,
    required this.data,
    required this.title,
  });
  @override
  State<SellProductBottomSheetsWidget> createState() => _BottomSheetsWidgetState();
  final String title;
  final ProductDetialModel data;
}

class _BottomSheetsWidgetState extends State<SellProductBottomSheetsWidget> with BaseStateMixin {
  final _bloc = SaleBloc();
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  String cashType = '';
  int? storeId;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    storeId = Utils.getStoreId();
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

  void saleProduct() {
    if (cashType != '') {
      List<ProductInDetialModel> otpData = [];
      for (ProductInDetialModel data in widget.data.sizes!) {
        if (data.ware_stock > 0) {
          otpData.add(data);
        }
      }
      if (otpData.isEmpty) {
        showWarningDialog("Бараа оруулна уу");
        // AlertMessage.attentionMessage(context, "Бараа оруулна уу");
      } else {
        _bloc.add(CreateSaleEvent(otpData, cashType));
      }
    } else {
      showWarningDialog("Төлбөрийн хэрэгсэл сонгоно уу!");
    }
  }

  void changeOrderQty(ProductInDetialModel data, int type, int index) {
    if (type == 1 && data.ware_stock < data.stock!) {
      setState(() {
        data.ware_stock++;
      });
    } else if (type == 0) {
      if (data.ware_stock > 0) {
        setState(() {
          data.ware_stock--;
        });
      }
    }
    _controllers[index].text = data.ware_stock.toString();
  }

  void changeCount(ProductInDetialModel data, int value, int index) {
    if (data.stock! >= value) {
      setState(() {
        data.ware_stock = value;
      });
    } else {
      setState(() {
        data.ware_stock = data.stock!;
      });
    }
    _controllers[index].text = data.ware_stock.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Utils.cancelLoader(context);
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<SaleBloc, SaleState>(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is SaleLoading) {
                    Utils.startLoader(context);
                  }
                  if (state is SaleFailure) {
                    if (state.message == "Token") {
                      _bloc.add(CreateSaleEvent(widget.data.sizes!, cashType));
                    } else {
                      Utils.cancelLoader(context);
                      showWarningDialog(state.message);
                      // AlertMessage.attentionMessage(context, state.message);
                    }
                  }
                  if (state is SaleSuccess) {
                    Utils.cancelLoader(context);
                    showSuccessDialog("Амжилттай", false, "Бараа борлуулагдлаа");
                    // AlertMessage.statusMessage(
                    //     context, "Амжилттай", "Бараа борлуулагдлаа", false);
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  }
                })
          ],
          child: KeyboardDismissOnTap(
            dismissOnCapturedTaps: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Column(
                children: [
                  Column(children: [
                    Text(widget.title, style: const TextStyle(color: kPrimarySecondColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    const Divider(),
                    ListTile(
                        leading: widget.data.photo == null
                            ? Image.asset(
                                "assets/images/socks.png",
                                width: 80.0,
                              )
                            : Container(height: 80.0, width: 80.0, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)), child: ClipRRect(borderRadius: BorderRadius.circular(9), child: Image.network(widget.data.photo!, fit: BoxFit.cover))),
                        title: Text("Барааны нэр: ${widget.data.name}", style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
                        subtitle: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("Барааны код: ${widget.data.code}", style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal)),
                          Utils.getUserRole() == "BOSS" ? Text('Авсан үнэ: ${widget.data.sizes!.first.cost}₮', style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal)) : const SizedBox.shrink(),
                          Text('Зарах үнэ: ${widget.data.sizes!.first.price}₮', style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal))
                        ]))
                  ]),
                  Expanded(
                      child: ListView.builder(
                          // padding: const EdgeInsets.only(bottom: 250),
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
                                    child: TextFormField(
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
                          })),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(
                      child: Container(
                          // width: 100,
                          height: 40,
                          decoration: BoxDecoration(color: isChecked1 ? Colors.grey : kWhite, boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 3, offset: const Offset(2, 2))], borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                              child: const Center(child: Text("Бэлэн", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold))),
                              onTap: () {
                                setState(() {
                                  if (isChecked3) {
                                    isChecked3 = false;
                                    isChecked1 = !isChecked1;
                                    cashType = "CASH";
                                  } else if (isChecked2) {
                                    isChecked2 = false;
                                    isChecked1 = !isChecked1;
                                    cashType = "CASH";
                                  } else {
                                    isChecked1 = !isChecked1;
                                    cashType = "CASH";
                                  }
                                });
                              })),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                          // width: 80,
                          height: 40,
                          decoration: BoxDecoration(color: isChecked2 ? Colors.grey : kWhite, boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 3, offset: const Offset(2, 2))], borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                              child: const Center(child: Text("Карт", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold))),
                              onTap: () {
                                setState(() {
                                  if (isChecked1) {
                                    isChecked1 = false;
                                    isChecked2 = !isChecked2;
                                    cashType = "CARD";
                                  } else if (isChecked3) {
                                    isChecked3 = false;
                                    isChecked2 = !isChecked2;
                                    cashType = "CARD";
                                  } else {
                                    isChecked2 = !isChecked2;
                                    cashType = "CARD";
                                  }
                                });
                              })),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Container(
                            // width: 100,
                            height: 40,
                            decoration: BoxDecoration(color: isChecked3 ? Colors.grey : kWhite, boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 3, offset: const Offset(2, 2))], borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                                child: const Center(child: Text("Шилжүүлэг", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold))),
                                onTap: () {
                                  setState(() {
                                    if (isChecked2) {
                                      isChecked2 = false;
                                      isChecked3 = !isChecked3;
                                      cashType = "ACC";
                                    } else if (isChecked1) {
                                      isChecked1 = false;
                                      isChecked3 = !isChecked3;
                                      cashType = "ACC";
                                    } else {
                                      isChecked3 = !isChecked3;
                                      cashType = "ACC";
                                    }
                                  });
                                }))),
                  ]),
                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), backgroundColor: kPrimaryColor),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Буцах", style: TextStyle(color: kWhite)))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: ElevatedButton(
                                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), backgroundColor: kPrimaryColor),
                                onPressed: () {
                                  bool otpCheck = false;
                                  for (ProductInDetialModel data in widget.data.sizes!) {
                                    if (data.ware_stock != 0) {
                                      setState(() {
                                        otpCheck = true;
                                      });
                                    }
                                  }
                                  if (otpCheck) {
                                    saleProduct();
                                  } else {
                                    showWarningDialog("Бараа оруулна уу");
                                    // AlertMessage.alertMessage(
                                    //     context, "Анхаар!", "Бараа оруулна уу!");
                                  }
                                },
                                child: const Text("Борлуулах", style: TextStyle(color: kWhite))))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
