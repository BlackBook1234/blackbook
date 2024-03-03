import 'package:black_book/bloc/sale/bloc.dart';
import 'package:black_book/bloc/sale/event.dart';
import 'package:black_book/bloc/sale/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/sale/total.dart';
import 'package:black_book/models/sale_product/product_in_detial.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/bottom_sheet.dart/show_bottom.dart';
import 'package:black_book/widget/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoldItemScreen extends StatefulWidget {
  const SoldItemScreen({super.key, required this.id});
  final int id;
  @override
  State<SoldItemScreen> createState() => _SoldItemScreenState();
}

class _SoldItemScreenState extends State<SoldItemScreen> {
  DateTime dateTime = DateTime.now();
  DateTime date = DateTime.now();
  bool show = false;
  List<SaleProductInDetialModel> list = [];
  List<SaleProductInDetialModel> listSearch = [];
  final _bloc = SaleBloc();
  TotalSaleModel? amount;
  bool searchAgian = false;
  String searchValue = "";
  SaleProductInDetialModel? productBackdata;
  int _page = 1;
  bool _hasMoreOrder = false;
  bool _loadingOrder = false;
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController()..addListener(_loadMoreOrder);
    _bloc.add(GetSaleEvent(widget.id, searchAgian, searchValue, _page));
    super.initState();
  }

  void _loadMoreOrder() {
    if (_hasMoreOrder &&
        _controller.position.extentAfter == 0 &&
        !_loadingOrder) {
      setState(() {
        _loadingOrder = true;
        _page++;
      });
      _bloc.add(GetSaleEvent(widget.id, searchAgian, searchValue, _page));
    }
  }

  void _agianSearch() {
    // _bloc.add(
    //     GetSaleEvent(_page, searchAgian, storeId, productType, searchValue));
  }

  void search(String searchValue) {
    setState(() {
      list = listSearch
          .where((item) => item.product_name!
              .toLowerCase()
              .contains(searchValue.toLowerCase()))
          .toList();
    });
  }

  void searchDate() {
    list = listSearch
        .where((user) =>
            DateTime.tryParse(user.created_at!)!.isAfter(date) &&
            DateTime.tryParse(user.created_at!)!.isBefore(dateTime))
        .toList();
  }

  void _backProduct(SaleProductInDetialModel data) {
    setState(() {
      productBackdata!.price = data.price;
      productBackdata!.sale_id = data.sale_id;
      productBackdata!.stock = data.stock;
    });
    print("${data.price}  ${data.sale_id}  ${data.stock}");
    _bloc.add(SaleProductBack(data.price!, data.sale_id!, data.stock!));
  }

  _showLogOutWarning(
      BuildContext context, SaleProductInDetialModel data) async {
    Widget continueButton = TextButton(
        child: const Text("Тийм", style: TextStyle(color: kBlack)),
        onPressed: () {
          Navigator.of(context).pop();
          _backProduct(data);
        });
    Widget cancelButton = TextButton(
        child: const Text("Үгүй", style: TextStyle(color: kBlack)),
        onPressed: () {
          Navigator.of(context).pop();
        });
    AlertDialog alert = AlertDialog(
        title: const Column(children: [
          Center(
              child: Text("Анхаар!",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor))),
          Divider()
        ]),
        content: const Text("Зарагдсан барааг буцаах уу?",
            textAlign: TextAlign.center),
        actions: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [cancelButton, continueButton])
        ]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<SaleBloc, SaleState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is GetSaleLoading) {
                  Utils.startLoader(context);
                  setState(() {
                    _loadingOrder = false;
                  });
                }
                if (state is GetSaleFailure) {
                  if (state.message == "Token") {
                    _bloc.add(GetSaleEvent(
                        widget.id, searchAgian, searchValue, _page));
                  } else {
                    setState(() {
                      _loadingOrder = false;
                    });
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                  }
                }
                if (state is GetSaleSuccess) {
                  Utils.cancelLoader(context);
                  setState(() {
                    _loadingOrder = false;
                    _hasMoreOrder = state.hasMoreOrder;
                    amount = state.total;
                    list = state.list;
                    listSearch = state.list;
                    list.sort((b, a) => a.created_at!.compareTo(b.created_at!));
                  });
                }
              }),
          BlocListener<SaleBloc, SaleState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is SaleProductBackLoading) {
                  Utils.startLoader(context);
                }
                if (state is SaleProductBackFailure) {
                  if (state.message == "Token") {
                    _bloc.add(SaleProductBack(productBackdata!.price!,
                        productBackdata!.sale_id!, productBackdata!.stock!));
                  } else {
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                  }
                }
                if (state is SaleProductBackSuccess) {
                  Utils.cancelLoader(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            scrollable: true,
                            title:
                                Text("Мэдээлэл", textAlign: TextAlign.center),
                            contentPadding: EdgeInsets.only(
                                right: 20, left: 20, bottom: 20, top: 20),
                            content: Column(children: [
                              Text("Амжилттай буцаагдлаа"),
                              SizedBox(height: 20)
                            ]));
                      });
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pop(context);
                    Navigator.pop(context);
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
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(children: [
                    Expanded(
                        child: SizedBox(
                            height: 35,
                            child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchValue = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black26, width: 1)),
                                    hoverColor: Colors.black12,
                                    focusColor: Colors.black12,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black26, width: 1)),
                                    fillColor: kWhite,
                                    hintText: "Барааны код",
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(10),
                                    prefixIcon: const Icon(Icons.search,
                                        color: kPrimaryColor),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    hintStyle:
                                        const TextStyle(fontSize: 14))))),
                    const SizedBox(width: 10),
                    InkWell(
                        onTap: () {
                          setState(() {
                            searchAgian = true;
                            _agianSearch();
                          });
                        },
                        child: Container(
                            width: 80,
                            height: 38,
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 3,
                                      offset: const Offset(2, 2))
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                                child: Text("Хайх",
                                    style: TextStyle(color: kWhite)))))
                  ])),
              Expanded(
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 3,
                                          offset: const Offset(2, 2))
                                    ],
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                    trailing: InkWell(
                                        child: const Icon(
                                            Icons.settings_backup_restore,
                                            color: kPrimaryColor),
                                        onTap: () {
                                          _showLogOutWarning(
                                              context, list[index]);
                                        }),
                                    leading: SizedBox(
                                        width: 100,
                                        child: Row(children: [
                                          Text((index + 1).toString()),
                                          Container(
                                              height: 80.0,
                                              // width: 80.0,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(9),
                                                  child: Image.asset(
                                                      "assets/images/saleProduct.jpg",
                                                      fit: BoxFit.cover))),
                                        ])),
                                    title: Text(
                                        "Барааны нэр: ${list[index].product_name}",
                                        style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Барааны код: ${list[index].product_code}",
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text(
                                              'Анхны үнэ: ${list[index].cost}₮',
                                              style: const TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text(
                                              'Зарах үнэ: ${list[index].price}₮',
                                              style: const TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text(
                                              'Төрөл: ${list[index].money_type == "CASH" ? "Бэлэн" : list[index].money_type == "ACC" ? "Шилжүүлэг" : "Карт"}',
                                              style: const TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text('Хэмжээ: ${list[index].type}',
                                              style: const TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text('Тоо: ${list[index].stock}ш',
                                              style: const TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ]))));
                      })),
              Padding(
                  padding: const EdgeInsets.all(10),
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
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return FractionallySizedBox(
                                      heightFactor: 0.3,
                                      child: BottomSheetsWidget(
                                          title: "Дэлгэрэнгүй", data: amount!));
                                });
                          },
                          child: SizedBox(
                              height: 60,
                              width: MediaQuery.of(context).size.width / 1.1,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  child: Row(children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (show) {
                                              show = false;
                                            } else {
                                              show = true;
                                            }
                                          });
                                        },
                                        child: Icon(show == true
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                    Expanded(
                                        child: Text(
                                            "Нийт үнийн дүн: ${show ? amount!.price.toString() : ""}₮",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)))
                                  ]))))))
            ])));
  }
}
