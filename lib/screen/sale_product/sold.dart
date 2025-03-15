import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/models/sale/sale_detial.dart';
import 'package:black_book/models/sale/sale_list.dart';
import 'package:black_book/models/sale_product/amount.dart';
import 'package:black_book/models/store/store_detial.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/bottom_sheet.dart/show_bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'sold_item.dart';

class SoldItemMainScreen extends StatefulWidget {
  const SoldItemMainScreen({super.key});
  @override
  State<SoldItemMainScreen> createState() => _SoldItemMainScreenState();
}

class _SoldItemMainScreenState extends State<SoldItemMainScreen>
    with BaseStateMixin {
  DateTime dateTime = DateTime.now();
  DateTime date = DateTime.now();
  bool show = false;
  String chosenType = "Бүх дэлгүүр";
  List<String> typeStore = ["Бүх дэлгүүр"];
  DetialSaleProductModel listData = DetialSaleProductModel();
  AmountModel? amount;
  String userRole = 'BOSS';
  int _page = 1;
  String storeId = "";
  bool searchAgian = false;
  List<ProductStoreModel> storeList = [];
  SaleListModel? otpWarehouse;
  bool _runApi = false;
  final NumberFormat format = NumberFormat("#,###");
  // late ScrollController _scrollController;
  StoreDetialModel defaultStoreModel = StoreDetialModel(
      name: "Агуулах",
      phone_number: "",
      created_at: DateTime.now().toString(),
      is_main: 1,
      id: -1);

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

  @override
  void initState() {
    super.initState();
    // _scrollController = ScrollController();
    // _scrollController.addListener(_loadMorePages);
    _getProductData();
    super.initState();
    userRole = Utils.getUserRole();
  }

  // void _loadMorePages() {
  //   if (_scrollController.position.pixels ==
  //           _scrollController.position.maxScrollExtent &&
  //       !_runApi) {
  //     setState(() {
  //       searchAgian = false;
  //       _page++;
  //     });
  //     _getProductData();
  //   }
  // }

  Future<void> _getProductData() async {
    if (_runApi) return;
    setState(() {
      _runApi = true;
    });
    try {
      DetialSaleProductModel res =
          await api.getSoldProduct(_page, date, dateTime, storeId, searchAgian);
      setState(() {
        listData = res;
        if (res.warehouse != null) {
          otpWarehouse = SaleListModel(
              store_id: -1,
              store_name: listData.warehouse!.name,
              total_cost: listData.warehouse!.total_cost,
              total_price: listData.warehouse!.total_price);
          listData.list!.add(otpWarehouse!);
        }
        listData.stores!.add(defaultStoreModel);
        for (StoreDetialModel data in listData.stores!) {
          typeStore.add(data.name ?? "");
        }
        typeStore = typeStore.toSet().toList();
        _runApi = false;
        // if (listData.list != []) {
        //   chosenType = Utils.getstoreName();
        // }
      });
    } on APIError catch (e) {
      setState(() {
        _runApi = false;
      });
      showErrorDialog(e.message);
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
    _getProductData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                    borderRadius: BorderRadius.circular(10)),
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
                                    borderRadius: BorderRadius.circular(10)),
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
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    iconEnabledColor: kPrimarySecondColor,
                                    value: chosenType,
                                    style: const TextStyle(
                                        color: kPrimarySecondColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                    items: typeStore
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                          value: value, child: Text(value));
                                    }).toList(),
                                    underline: Container(
                                        height: 0, color: Colors.transparent),
                                    onChanged: (value) {
                                      setState(() {
                                        chosenType = value!;
                                      });
                                    }))))
                    : Expanded(
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
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: Center(
                                  child: Text(
                                Utils.getstoreName(),
                                style: const TextStyle(
                                    color: kPrimarySecondColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              )),
                            ))),
                const SizedBox(width: 10),
                BlackBookButton(
                  height: 38,
                  width: 80,
                  borderRadius: 14,
                  onPressed: () {
                    setState(() {
                      searchAgian = true;
                      _agianSearch();
                    });
                  },
                  color: kPrimaryColor,
                  child: const Center(
                    child: Text("Хайх"),
                  ),
                ),
              ])),
          Expanded(
              child: ListView.builder(
                  // controller: _scrollController,
                  itemCount: listData.list != null ? listData.list!.length : 0,
                  itemBuilder: (context, index) {
                    List<SaleListModel>? listModel = listData.list;
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Container(
                            decoration: BoxDecoration(
                                color: listModel![index].total_cost != 0
                                    ? Colors.green.shade300
                                    : kWhite,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 3,
                                      offset: const Offset(2, 2))
                                ],
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                                onTap: () {
                                  if (listModel[index].total_price != 0) {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                SoldItemScreen(
                                                    begindate: date,
                                                    endDate: dateTime,
                                                    id: listModel[index]
                                                        .store_id!)));
                                  }
                                },
                                leading: Container(
                                    height: 80.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(9),
                                        child: Image.asset(
                                            "assets/images/saleProduct.jpg",
                                            fit: BoxFit.cover))),
                                title: Text(
                                  "Дэлгүүр: ${listModel[index].store_name}",
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Он сар: ${listData.date}",
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.normal)),
                                      Utils.getUserRole() == "BOSS"
                                          ? Text(
                                              "Авсан үнэ: ${format.format(listModel[index].total_cost ?? 0)}₮",
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight:
                                                      FontWeight.normal))
                                          : const SizedBox.shrink(),
                                      Text(
                                          'Зарсан үнэ: ${format.format(listModel[index].total_price ?? 0)}₮',
                                          style: const TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          'Төлөв: ${listModel[index].total_cost != 0 ? "Борлуулалттай" : "Борлуулалтгүй"}',
                                          style: const TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.normal))
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
                                  heightFactor: 0.4,
                                  child: BottomSheetsWidget(
                                    data: listData.total!,
                                    title: "Мэдээлэл",
                                  ));
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
        ]));
  }
}
