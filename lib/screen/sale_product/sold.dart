import 'package:black_book/bloc/sale/bloc.dart';
import 'package:black_book/bloc/sale/event.dart';
import 'package:black_book/bloc/sale/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/models/sale/sale_detial.dart';
import 'package:black_book/models/sale/sale_list.dart';
import 'package:black_book/models/sale_product/amount.dart';
import 'package:black_book/models/store/store_detial.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/bottom_sheet.dart/show_bottom.dart';
import 'package:black_book/widget/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sold_item.dart';

class SoldItemMainScreen extends StatefulWidget {
  const SoldItemMainScreen({super.key});
  @override
  State<SoldItemMainScreen> createState() => _SoldItemMainScreenState();
}

class _SoldItemMainScreenState extends State<SoldItemMainScreen> {
  DateTime dateTime = DateTime.now();
  DateTime date = DateTime.now();
  bool show = false;
  String chosenType = "Бүх дэлгүүр";
  List<String> typeStore = ["Бүх дэлгүүр"];
  DetialSaleProductModel listData = DetialSaleProductModel();
  DetialSaleProductModel listSearch = DetialSaleProductModel();
  final _bloc = SaleBloc();
  AmountModel? amount;
  String userRole = 'BOSS';
  int _page = 1;
  bool _hasMoreOrder = false;
  bool _loadingOrder = false;
  late ScrollController _controller;
  String storeId = "";
  bool searchAgian = false;
  List<ProductStoreModel> storeList = [];

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(top: false, child: child)));
  }

  void showBalance() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              title: Center(
                  child: Text("Мэдээлэл", style: TextStyle(fontSize: 20))),
              content: Text("Bank:\nCard:\nMoney:"));
        });
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_loadMoreOrder);
    _bloc.add(GetMainSaleEvent(_page, date, dateTime, storeId, searchAgian));
    super.initState();
    userRole = Utils.getUserRole();
  }

  void _loadMoreOrder() {
    if (_hasMoreOrder &&
        _controller.position.extentAfter == 0 &&
        !_loadingOrder) {
      setState(() {
        _loadingOrder = true;
        _page++;
      });
      _bloc.add(GetMainSaleEvent(_page, date, dateTime, storeId, searchAgian));
    }
  }

  void _agianSearch() {
    for (StoreDetialModel data in listData.stores!) {
      if (data.name == chosenType) {
        storeId = "";
        storeId = data.id.toString();
      } else if (chosenType == "Бүх дэлгүүр") {
        storeId = "";
      }
    }
    _bloc.add(GetMainSaleEvent(_page, date, dateTime, storeId, searchAgian));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<SaleBloc, SaleState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is GetMainSaleLoading) {
                  Utils.startLoader(context);
                  setState(() {
                    _loadingOrder = false;
                  });
                }
                if (state is GetMainSaleFailure) {
                  if (state.message == "Token") {
                    _bloc.add(GetMainSaleEvent(
                        _page, date, dateTime, storeId, searchAgian));
                  } else {
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                  }
                  setState(() {
                    _loadingOrder = false;
                  });
                }
                if (state is GetMainSaleSuccess) {
                  Utils.cancelLoader(context);
                  setState(() {
                    _loadingOrder = false;
                    _hasMoreOrder = state.hasMoreOrder;
                    listData = state.list;
                    listSearch = state.list;
                    for (StoreDetialModel data in listData.stores!) {
                      typeStore.add(data.name ?? "");
                    }
                    typeStore = typeStore.toSet().toList();
                    // list.sort((b, a) => a.date!.compareTo(b.date!));
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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: InkWell(
                                onTap: () {
                                  _showDialog(CupertinoDatePicker(
                                      initialDateTime: date,
                                      mode: CupertinoDatePickerMode.date,
                                      use24hFormat: true,
                                      onDateTimeChanged: (DateTime newDate) {
                                        setState(() => date = newDate);
                                      }));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: kWhite,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade300,
                                              blurRadius: 3,
                                              offset: const Offset(2, 2))
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: SizedBox(
                                        height: 40,
                                        child: Center(
                                            child: Text(
                                                "Эхлэх огноо ${date.year}-${date.month}-${date.day}",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500))))))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: InkWell(
                                onTap: () {
                                  _showDialog(CupertinoDatePicker(
                                      initialDateTime: dateTime,
                                      mode: CupertinoDatePickerMode.date,
                                      use24hFormat: true,
                                      onDateTimeChanged: (DateTime newDate) {
                                        setState(() => dateTime = newDate);
                                      }));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: kWhite,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade300,
                                              blurRadius: 3,
                                              offset: const Offset(2, 2))
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: SizedBox(
                                        height: 40,
                                        child: Center(
                                            child: Text(
                                                "Дуусах огноо ${dateTime.year}-${dateTime.month}-${dateTime.day}",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)))))))
                      ])),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: DropdownButton<String>(
                                            isExpanded: true,
                                            iconEnabledColor:
                                                kPrimarySecondColor,
                                            value: chosenType,
                                            style: const TextStyle(
                                                color: kPrimarySecondColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                            items: typeStore
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value));
                                            }).toList(),
                                            underline: Container(
                                                height: 0,
                                                color: Colors.transparent),
                                            onChanged: (value) {
                                              setState(() {
                                                chosenType = value!;
                                              });
                                            }))))
                            : const SizedBox(width: 0),
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
                      itemCount:
                          listData.list != null ? listData.list!.length : 0,
                      itemBuilder: (context, index) {
                        List<SaleListModel>? listModel = listData.list;
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
                                    onTap: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  SoldItemScreen(
                                                      id: listModel[index]
                                                          .store_id!)));
                                    },
                                    leading: Container(
                                        height: 80.0,
                                        width: 80.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            child: Image.asset(
                                                "assets/images/saleProduct.jpg",
                                                fit: BoxFit.cover))),
                                    title: Text("Он сар: ${listData.date}",
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
                                              "Дэлгүүрийн нэр: ${listModel![index].store_name}",
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text(
                                              "Авсан үнэ: ${listModel[index].total_cost}",
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text(
                                              'Зарсан үнэ: ${listModel[index].total_price}₮',
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
                                          data: listData.total!,
                                          title: "Мэдээлэл"));
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
                                            "Нийт үнийн дүн: ${show ? listData.total!.price : ""}₮",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)))
                                  ]))))))
            ])));
  }
}
