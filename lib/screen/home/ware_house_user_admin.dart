import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/bloc/remove/bloc.dart';
import 'package:black_book/bloc/remove/event.dart';
import 'package:black_book/bloc/remove/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/models/product/response.dart';
import 'package:black_book/screen/core/add_razmer.dart';
import 'package:black_book/screen/home/widget/banners_carousel.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/bottom_sheet.dart/product_draft_bottom.dart';
import 'package:black_book/widget/bottom_sheet.dart/product_razmer_add.dart';
import 'package:black_book/widget/bottom_sheet.dart/purchase_product.dart';
import 'package:black_book/widget/component/choose_type.dart';
import 'package:black_book/widget/component/list_builder.dart';
import 'package:black_book/widget/component/search.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class WareHouseAdminScreen extends StatefulWidget {
  const WareHouseAdminScreen({super.key});
  @override
  State<WareHouseAdminScreen> createState() => _WareHouseAdminScreenState();
}

class _WareHouseAdminScreenState extends State<WareHouseAdminScreen>
    with BaseStateMixin {
  DateTime dateTime = DateTime.now();
  DateTime date = DateTime.now();
  List<ProductDetialModel> list = [];
  List<ProductDetialModel> listSearch = [];
  final removeBloc = RemoveBloc();
  final bool _isExpanded = false;
  String goodId = '';
  ProductDetialModel? purchase;
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
  bool _runApi = false;
  late ScrollController _scrollController;
  ProductStoreModel defaultStoreModel = ProductStoreModel(
      name: "Агуулах",
      phone_number: "",
      created_at: DateTime.now().toString(),
      is_main: 1,
      id: -1);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_loadMorePages);
    userRole = Utils.getUserRole();
    _getProductData();
  }

  void _loadMorePages() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_runApi) {
      setState(() {
        searchAgian = false;
        _page++;
      });
      _getProductData();
    }
  }

  Future<void> _getProductData() async {
    if (_runApi) return;
    setState(() {
      if (searchAgian) {
        list.clear();
      }
      _runApi = true;
    });
    try {
      ProductResponseModel res = await api.getProductData(
          _page, searchAgian, storeId, productType, searchValue);
      setState(() {
        if (searchAgian) {
          list = res.data!;
        } else {
          list.addAll(res.data!);
        }
        storeList = res.stores!;
        storeList.add(defaultStoreModel);
        for (ProductStoreModel data in storeList) {
          typeStore.add(data.name ?? "");
        }
        typeStore = typeStore.toSet().toList();
        _runApi = false;
        if (list != []) {
          chosenType = Utils.getstoreName();
        }
      });
    } on APIError catch (e) {
      setState(() {
        _runApi = false;
      });
      showErrorDialog(e.message);
    }
  }

  Future<void> refreshPage() async {
    setState(() {
      _page = 1;
      searchAgian = true;
    });
    await _getProductData();
  }

  void _purchaseBottom(ProductDetialModel datas) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
              heightFactor: 0.6,
              child: PurchaseProductBottom(title: "Бараа нэмэх", data: datas));
        }).then((value) {
      setState(() {
        _page = 1;
        searchAgian = true;
      });
      _getProductData();
    });
  }

  void _agianSearch() {
    setState(() {
      searchAgian = true;
      _page = 1;
    });
    if (chosenType == "Бүх дэлгүүр" &&
        chosenValue == "Бүх төрөл" &&
        searchValue == "") {
      setState(() {
        storeId = '';
        productType = '';
      });
      _getProductData();
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
      _getProductData();
    }
  }

  void _chooseAction() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Column(children: [
                Center(
                    child: Text("Бараа",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor))),
                Divider()
              ]),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: BlackBookButton(
                        height: 40,
                        borderRadius: 16,
                        onPressed: () {
                          Navigator.pop(context);
                          _purchaseBottom(purchase!);
                        },
                        color: kDisable,
                        child: const Center(
                          child: Text("Нэмэх",
                              style: TextStyle(color: kPrimaryColor)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: BlackBookButton(
                        height: 40,
                        borderRadius: 16,
                        onPressed: () {
                          Navigator.pop(context);
                          _showLogOutWarning(context);
                        },
                        color: kPrimaryColor,
                        child: const Center(child: Text("Устгах")),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getSize(10),
                ),
                BlackBookButton(
                  height: 40,
                  borderRadius: 16,
                  onPressed: () {
                    Navigator.pop(context);
                    addRazmer(purchase!);
                  },
                  color: kDisabledText,
                  child: const Center(child: Text("Размер нэмэх")),
                ),
              ]);
        }).then((value) {
      setState(() {
        _page = 1;
        searchAgian = false;
        list.clear();
      });
      _getProductData();
    });
  }

  void _showLogOutWarning(BuildContext context) async {
    Widget continueButton = TextButton(
        child: const Text("Тийм", style: TextStyle(color: kBlack)),
        onPressed: () {
          removeBloc.add(RemoveProductEvent(goodId));
          // Navigator.pop(context);
        });
    Widget cancelButton = TextButton(
        child: const Text("Үгүй", style: TextStyle(color: kBlack)),
        onPressed: () {
          Navigator.pop(context);
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

  void addRazmer(ProductDetialModel datas) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ProductAddSzieScreen(model: datas)));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
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
                  showSuccessDialog("Мэдээлэл", false, "Амжилттай устгагдлаа");
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }).then((value) => refreshPage());
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
          list.isEmpty
              ? Center(
                  child: Lottie.asset('assets/json/empty-page.json'),
                )
              : ListBuilder(
                  list: list,
                  showWarningCallback: (ProductDetialModel? datas) {
                    setState(() {
                      goodId = datas!.good_id!;
                      purchase = datas;
                    });
                  },
                  showDilaog: () {
                    _chooseAction();
                  },
                  controller: _scrollController,
                  userRole: userRole,
                  isExpanded: _isExpanded,
                  typeTrailling: true,
                  icon: Icons.info,
                  trailingText: "",
                  screenType: 'warepurchase',
                )
        ]));
  }
}
