import 'package:black_book/bloc/store/bloc.dart';
import 'package:black_book/bloc/store/event.dart';
import 'package:black_book/bloc/store/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/models/product/store_amount.dart';
import 'package:black_book/models/sale/sale_detial.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/bottom_sheet.dart/store_bottom.dart';
import 'package:black_book/widget/component/choose_type.dart';
import 'package:black_book/widget/component/list_builder.dart';
import 'package:black_book/widget/component/search.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WareDivisionScreen extends StatefulWidget {
  const WareDivisionScreen({super.key});
  @override
  State<WareDivisionScreen> createState() => _WareDivisionScreenState();
}

class _WareDivisionScreenState extends State<WareDivisionScreen> {
  bool show = false;
  final _bloc = StoreBloc();
  String chosenValue = "Бүх төрөл";
  String chosenType = "Агуулах";
  List<String> typeValue = ["Бүх төрөл", "Өвөл", "Хавар", "Намар", "Зун"];
  List<String> typeStore = ["Бүх дэлгүүр", "Агуулах"];
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
  ProductStoreModel defaultStoreModel = ProductStoreModel(
      name: "Агуулах",
      phone_number: "",
      created_at: DateTime.now().toString(),
      is_main: 1,
      id: -1);

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
      setState(() {
        _page = 1;
      });
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
                    storeList.add(defaultStoreModel);
                    for (ProductStoreModel data in storeList) {
                      typeStore.add(data.name ?? "");
                    }
                    if (Utils.getUserRole() == "BOSS") {
                      chosenType = "Агуулах";
                    } else {
                      if (list != []) {
                        chosenType = Utils.getstoreName();
                      }
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
              TypeBuilder(
                chosenValue: chosenValue,
                chosenType: chosenType,
                userRole: "BOSS",
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
                controller: _controller,
                userRole: "BOSS",
                isExpanded: _isExpanded,
                typeTrailling: false,
                screenType: 'store',
                icon: Icons.abc,
                trailingText: '',
              ),
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
