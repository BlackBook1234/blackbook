import 'package:black_book/bloc/product/bloc.dart';
import 'package:black_book/bloc/product/event.dart';
import 'package:black_book/bloc/product/state.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_inlist.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/bottom_sheet.dart/sale_product.dart';
import 'package:black_book/widget/component/choose_type.dart';
import 'package:black_book/widget/component/list_builder.dart';
import 'package:black_book/widget/component/search.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';

class MainSellProductScreen extends StatefulWidget {
  const MainSellProductScreen({super.key});
  @override
  State<MainSellProductScreen> createState() => _MainSellProductScreenState();
}

class _MainSellProductScreenState extends State<MainSellProductScreen> {
  final _bloc = ProductBloc();
  DateTime dateTime = DateTime.now();
  DateTime date = DateTime.now();
  bool show = false;
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
  String userRole = "BOSS";
  int index = 0;

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
            showWarningCallback: (int? id) {
              setState(() {
                index = id!;
              });
            },
            showDilaog: () {
              for (ProductInDetialModel data in list[index].sizes!) {
                data.ware_stock = 0;
              }
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return FractionallySizedBox(
                        heightFactor: 0.7,
                        child: SellProductBottomSheetsWidget(
                            title: "Борлуулах", data: list[index]));
                  });
            },
            controller: _controller,
            userRole: userRole,
            isExpanded: _isExpanded,
            typeTrailling: true,
            icon: Icons.sell,
            trailingText: "Борлуулах",
            screenType: 'sale',
          ),
        ]));
  }
}
