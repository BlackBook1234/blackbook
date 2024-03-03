import 'package:black_book/bloc/store/bloc.dart';
import 'package:black_book/bloc/store/event.dart';
import 'package:black_book/bloc/store/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_inlist.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/models/product/store_amount.dart';
import 'package:black_book/models/sale/sale_detial.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/bottom_sheet.dart/store_bottom.dart';
import 'package:black_book/widget/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WareDivisionScreen extends StatefulWidget {
  const WareDivisionScreen({super.key});
  @override
  State<WareDivisionScreen> createState() => _WareDivisionScreenState();
}

class _WareDivisionScreenState extends State<WareDivisionScreen> {
  DateTime dateTime = DateTime(2023, 10, 01);
  DateTime date = DateTime(2023, 10, 01);
  bool show = false;
  final _bloc = StoreBloc();
  String chosenValue = "Бүх төрөл";
  String chosenType = "Бүх дэлгүүр";
  List<String> typeValue = ["Бүх төрөл", "Өвөл", "Хавар", "Намар", "Зун"];
  List<String> typeStore = ["Бүх дэлгүүр"];
  String searchValue = "";
  List<ProductDetialModel> list = [];
  List<ProductDetialModel> listSearch = [];
  final bool _isExpanded = false;
  List<ProductStoreModel> storeList = [];
  DetialSaleProductModel listData = DetialSaleProductModel();
  StoreAmountModel? amount;
  bool searchAgian = false;
  String storeId = "";
  String productType = "";
  int _page = 1;
  bool _hasMoreOrder = false;
  bool _loadingOrder = false;
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController()..addListener(_loadMoreOrder);
    _bloc.add(GetStoreProductEvent(
        _page, searchAgian, storeId, productType, searchValue));
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
      _bloc.add(GetStoreProductEvent(
          _page, searchAgian, storeId, productType, searchValue));
    }
  }

  void _agianSearch() {
    if (chosenType == "Бүх дэлгүүр" &&
        chosenValue == "Бүх төрөл" &&
        searchValue == "") {
      _bloc.add(GetStoreProductEvent(
          _page, false, storeId, productType, searchValue));
    } else {
      for (ProductStoreModel data in storeList) {
        if (data.name == chosenType) {
          storeId = "";
          storeId = data.id.toString();
        } else if (chosenType == "Бүх дэлгүүр") {
          storeId = "";
        }
      }
      if (chosenValue == "Өвөл") {
        productType = "WINTER";
      } else if (chosenValue == "Хавар") {
        productType = "SPRING";
      } else if (chosenValue == "Намар") {
        productType = "AUTUMN";
      } else if (chosenValue == "Зун") {
        productType = "SUMMER";
      } else {
        productType = "";
      }
      _bloc.add(GetStoreProductEvent(
          _page, searchAgian, storeId, productType, searchValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<StoreBloc, StoreState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is GetStoreProductLoading) {
                  Utils.startLoader(context);
                  setState(() {
                    _loadingOrder = false;
                  });
                }
                if (state is GetStoreProductFailure) {
                  if (state.message == "Token") {
                    _bloc.add(GetStoreProductEvent(
                        _page, searchAgian, storeId, productType, searchValue));
                  } else {
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                    setState(() {
                      _loadingOrder = false;
                    });
                  }
                }
                if (state is GetStoreProductSuccess) {
                  Utils.cancelLoader(context);
                  setState(() {
                    list = state.list;
                    listSearch = state.list;
                    amount = state.amount!;
                    _loadingOrder = false;
                    _hasMoreOrder = state.hasMoreOrder;
                    list.sort((b, a) => a.created_at!.compareTo(b.created_at!));
                    storeList = state.stores!;
                    for (ProductStoreModel data in storeList) {
                      typeStore.add(data.name ?? "");
                    }
                    typeStore = typeStore.toSet().toList();
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
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(children: [
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
                                    })))),
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
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    iconEnabledColor: kPrimarySecondColor,
                                    value: chosenValue,
                                    style: const TextStyle(
                                        color: kPrimarySecondColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                    items: typeValue
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                          value: value, child: Text(value));
                                    }).toList(),
                                    underline: Container(
                                        height: 0, color: Colors.transparent),
                                    onChanged: (value) {
                                      setState(() {
                                        chosenValue = value!;
                                      });
                                    }))))
                  ])),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
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
                                    filled: true,
                                    hintText: "Барааны код",
                                    contentPadding: const EdgeInsets.all(10),
                                    prefixIcon: const Icon(Icons.search,
                                        color: kPrimaryColor),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    hintStyle: const TextStyle(
                                        fontSize: 13, color: Colors.grey))))),
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
                                child: ExpansionTile(
                                    trailing: const Text(""),
                                    shape: const Border(),
                                    collapsedIconColor: kPrimaryColor,
                                    leading: list[index].photo == null
                                        ? Container(
                                            height: 80.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    20.0)),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                                child: Image.asset(
                                                    "assets/images/saleProduct.jpg",
                                                    fit: BoxFit.cover)))
                                        : Container(
                                            height: 80.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(9),
                                                child: Image.network(list[index].photo!, fit: BoxFit.cover))),
                                    title: Text("Барааны нэр: ${list[index].name}", style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
                                    subtitle: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text("Барааны код: ${list[index].code}",
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          'Анхны үнэ: ${list[index].sizes!.first.cost}₮',
                                          style: const TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          'Зарах үнэ: ${list[index].sizes!.first.price}₮',
                                          style: const TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.normal))
                                    ]),
                                    initiallyExpanded: _isExpanded,
                                    children: [
                                      const Row(children: [
                                        Expanded(child: Divider(indent: 10)),
                                        SizedBox(width: 4),
                                        Icon(Icons.circle,
                                            size: 4, color: kPrimaryColor),
                                        SizedBox(width: 4),
                                        Expanded(child: Divider(endIndent: 10))
                                      ]),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                                getSizesString(
                                                    list[index].sizes),
                                                style: const TextStyle(
                                                    fontSize: 11.0,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            Text(
                                                getWareString(
                                                    list[index].sizes),
                                                style: const TextStyle(
                                                    fontSize: 11.0,
                                                    fontWeight:
                                                        FontWeight.normal))
                                          ])
                                    ])));
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
                                      child: BottomSheetStore(
                                          data: amount!, title: "Мэдээлэл"));
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
                                            "Нийт үнийн дүн: ${show ? amount!.total_price : ""}₮",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)))
                                  ]))))))
            ])));
  }
}

String getSizesString(List<ProductInDetialModel>? sizes) {
  if (sizes == null || sizes.isEmpty) {
    return 'No sizes available';
  }
  return sizes.map((size) => 'Хэмжээ: ${size.type}').join('\n');
}

String getWareString(List<ProductInDetialModel>? sizes) {
  if (sizes == null || sizes.isEmpty) {
    return 'No sizes available';
  }
  return sizes.map((size) => 'Үлдэгдэл: ${size.stock}ш').join('\n');
}
