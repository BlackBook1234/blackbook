import 'package:black_book/bloc/product/bloc.dart';
import 'package:black_book/bloc/product/event.dart';
import 'package:black_book/bloc/product/state.dart';
import 'package:black_book/bloc/remove/bloc.dart';
import 'package:black_book/bloc/remove/event.dart';
import 'package:black_book/bloc/remove/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/component/choose_type.dart';
import 'package:black_book/widget/component/list_builder.dart';
import 'package:black_book/widget/component/search.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WareHouseAdminScreen extends StatefulWidget {
  const WareHouseAdminScreen({super.key});
  @override
  State<WareHouseAdminScreen> createState() => _WareHouseAdminScreenState();
}

class _WareHouseAdminScreenState extends State<WareHouseAdminScreen> {
  DateTime dateTime = DateTime.now();
  DateTime date = DateTime.now();
  List<ProductDetialModel> list = [];
  List<ProductDetialModel> listSearch = [];
  final _bloc = ProductBloc();
  final removeBloc = RemoveBloc();
  final bool _isExpanded = false;
  String goodId = '';
  String userRole = "BOSS";
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
    _bloc.add(
        GetProductEvent(_page, searchAgian, storeId, productType, searchValue));
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
      _bloc.add(GetProductEvent(
          _page, searchAgian, storeId, productType, searchValue));
    }
  }

  void _agianSearch() {
    if (chosenType == "Бүх дэлгүүр" &&
        chosenValue == "Бүх төрөл" &&
        searchValue == "") {
          setState(() {
            _page = 1;
          });
      _bloc.add(
          GetProductEvent(_page, false, storeId, productType, searchValue));
    } else {
      print(searchValue);
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
      _bloc.add(GetProductEvent(
          _page, searchAgian, storeId, productType, searchValue));
    }
  }

  void _showLogOutWarning(BuildContext context) async {
    Widget continueButton = TextButton(
        child: const Text("Тийм", style: TextStyle(color: kBlack)),
        onPressed: () {
          removeBloc.add(RemoveProductEvent(goodId));
          Navigator.pop(context);
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
        content: const Text("Бараа устгахдаа итгэлтэй байна уу",
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
                    _bloc.add(GetProductEvent(
                        _page, searchAgian, storeId, productType, searchValue));
                  } else {
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                    setState(() {
                      _loadingOrder = false;
                    });
                  }
                }
                if (state is GetProductSuccess) {
                  Utils.cancelLoader(context);
                  setState(() {
                    print(state.hasMoreOrder);
                    _loadingOrder = false;
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
                  });
                }
              }),
          BlocListener<RemoveBloc, RemoveState>(
              bloc: removeBloc,
              listener: (context, state) {
                if (state is RemoveLoading) {
                  Utils.startLoader(context);
                }
                if (state is RemoveFailure) {
                  if (state.message == "Token") {
                    removeBloc.add(RemoveProductEvent(goodId));
                  } else {
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                  }
                }
                if (state is RemoveSuccess) {
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
                              Text("Амжилттай устгагдлаа"),
                              SizedBox(height: 20)
                            ]));
                      });
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
                }
              })
        ],
        child: Column(children: [
          TypeBuilder(
            chosenValue: chosenValue,
            chosenType: chosenType,
            userRole: userRole,
            typeStore: typeStore,
            chooseType: (String value) {
              setState(() {
                chosenValue = value;
              });
            },
            chooseStore: (String value) {
              setState(() {
                chosenType = value;
              });
            },
          ),
          SearchBuilder(
            searchAgian: (bool type) {
              setState(() {
                searchAgian = type;
              });
              _agianSearch();
            },
            searchValue: (String value) {
              setState(() {
                searchValue = value;
              });
            },
          ),
          ListBuilder(
            list: list,
            showWarningCallback: (String? id) {
              setState(() {
                goodId = id!;
              });
            },
            showDilaog: () {
              _showLogOutWarning(context);
            },
            controller: _controller,
            userRole: userRole,
            isExpanded: _isExpanded,
            typeTrailling: true, icon: Icons.delete_outline_outlined,
            trailingText: "Устгах", screenType: 'ware',
          )
        ]));
  }
}
