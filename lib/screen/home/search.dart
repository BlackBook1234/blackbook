import 'package:black_book/bloc/product/bloc.dart';
import 'package:black_book/bloc/product/event.dart';
import 'package:black_book/bloc/product/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_inlist.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _bloc = ProductBloc();
  List<ProductDetialModel> list = [];
  List<ProductDetialModel> listSearch = [];
  final bool _isExpanded = false;
  List<ProductStoreModel> storeList = [];
  String chosenValue = "Бүх төрөл";
  String chosenType = "Бүх дэлгүүр";
  List<String> typeValue = ["Бүх төрөл", "Өвөл", "Хавар", "Намар", "Зун"];
  List<String> typeStore = ["Бүх дэлгүүр"];
  String searchValue = "";
  bool searchAgian = false;
  String storeId = "";
  String productType = "";
  int _page = 1;
  bool _hasMoreOrder = false;
  bool _loadingOrder = false;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_loadMoreOrder);
    _bloc.add(GetProductSearchEvent(
        _page, searchAgian, storeId, productType, searchValue));
  }

  void _loadMoreOrder() {
    if (_hasMoreOrder &&
        _controller.position.extentAfter == 0 &&
        !_loadingOrder) {
      setState(() {
        _loadingOrder = true;
        _page++;
      });
      _bloc.add(GetProductSearchEvent(
          _page, searchAgian, storeId, productType, searchValue));
    }
  }

  void _agianSearch() {
    if (chosenType == "Бүх дэлгүүр" &&
        chosenValue == "Бүх төрөл" &&
        searchValue == "") {
      _bloc.add(
          GetProductEvent(_page, false, storeId, productType, searchValue));
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
      _bloc.add(GetProductSearchEvent(
          _page, searchAgian, storeId, productType, searchValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is GetProductLoading) {
                  Utils.startLoader(context);
                  setState(() {
                    _loadingOrder = false;
                  });
                }
                if (state is GetProductFailure) {
                  if (state.message == "Token") {
                    _bloc.add(GetProductSearchEvent(
                        _page, searchAgian, storeId, productType, searchValue));
                  } else {
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                  }
                  setState(() {
                    _loadingOrder = false;
                  });
                }
                if (state is GetProductSuccess) {
                  Utils.cancelLoader(context);
                  setState(() {
                    _hasMoreOrder = state.hasMoreOrder;
                    if (searchAgian) {
                      list = state.list;
                      listSearch = state.list;
                    } else {
                      list.addAll(state.list);
                      listSearch.addAll(state.list);
                    }
                    list.sort((b, a) => a.created_at!.compareTo(b.created_at!));
                    storeList = state.storeList;
                    for (ProductStoreModel data in storeList) {
                      typeStore.add(data.name ?? "");
                    }
                    typeStore = typeStore.toSet().toList();
                    _loadingOrder = false;
                  });
                }
              })
        ],
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: DropdownButton<String>(
                                isExpanded: true,
                                iconEnabledColor: kPrimarySecondColor,
                                value: chosenType,
                                style: const TextStyle(
                                    color: kPrimarySecondColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                                items: typeStore.map<DropdownMenuItem<String>>(
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
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: DropdownButton<String>(
                                isExpanded: true,
                                iconEnabledColor: kPrimarySecondColor,
                                value: chosenValue,
                                style: const TextStyle(
                                    color: kPrimarySecondColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                                items: typeValue.map<DropdownMenuItem<String>>(
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
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
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
                                hintText: "Барааны код",
                                focusColor: Colors.black12,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.black26, width: 1)),
                                fillColor: kWhite,
                                filled: true,
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
                            child:
                                Text("Хайх", style: TextStyle(color: kWhite)))))
              ])),
          Expanded(
              child: ListView.builder(
                  itemCount: list.length,
                  controller: _controller,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 20),
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
                                shape: const Border(),
                                trailing: const Text(""),
                                leading: list[index].photo == null
                                    ? Container(
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
                                                fit: BoxFit.cover)))
                                    : Container(
                                        height: 80.0,
                                        width: 80.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            child: Image.network(list[index].photo!,
                                                fit: BoxFit.cover))),
                                title: Text("Барааны нэр: ${list[index].name}",
                                    style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
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
                                        Text(getSizesString(list[index].sizes),
                                            style: const TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.normal)),
                                        Text(getWareString(list[index].sizes),
                                            style: const TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.normal))
                                      ])
                                ])));
                  }))
        ]));
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
