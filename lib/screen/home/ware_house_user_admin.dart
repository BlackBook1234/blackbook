import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/bloc/remove/bloc.dart';
import 'package:black_book/bloc/remove/event.dart';
import 'package:black_book/bloc/remove/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/global_keys.dart';
import 'package:black_book/models/product/categories.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/models/product/response.dart';
import 'package:black_book/provider/type.dart';
import 'package:black_book/screen/core/add_razmer.dart';
import 'package:black_book/screen/core/edit_product.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/custom_dialog.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/bottom_sheet.dart/purchase_product.dart';
import 'package:black_book/widget/component/choose_type.dart';
import 'package:black_book/widget/component/list_builder.dart';
import 'package:black_book/widget/component/search.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class WareHouseAdminScreen extends StatefulWidget {
  const WareHouseAdminScreen({super.key});
  @override
  State<WareHouseAdminScreen> createState() => _WareHouseAdminScreenState();
}

class _WareHouseAdminScreenState extends State<WareHouseAdminScreen> with BaseStateMixin {
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
  List<String> typeStore = ["Бүх дэлгүүр"];
  String searchValue = "";
  bool searchAgian = false;
  String storeId = "";
  String productType = "";
  int _page = 1;
  bool _runApi = false;
  late ScrollController _scrollController;
  List<CategoriesModel> categories = [];
  ProductStoreModel defaultStoreModel = ProductStoreModel(name: "Агуулах", phone_number: "", created_at: DateTime.now().toString(), is_main: 1, id: -1);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_loadMorePages);
    userRole = Utils.getUserRole();
    _getProductData();
    setState(() {
      chosenType = Utils.getstoreName();
    });
  }

  void _loadMorePages() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50 && !_runApi) {
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
      ProductResponseModel res = await api.getProductData(_page, searchAgian, storeId, productType, searchValue);
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
        categories = res.categories!;
        Provider.of<TypeProvider>(GlobalKeys.navigatorKey.currentContext!, listen: false).setTypeList(res.categories!.map((e) => e.name).toList());
        _runApi = false;
        // if (list != []) {
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
          return FractionallySizedBox(heightFactor: 0.9, child: PurchaseProductBottom(title: "Бараа нэмэх", data: datas));
        }).then((value) {
      setState(() {
        _page = 1;
        for (ProductStoreModel data in storeList) {
          if (data.name == chosenType) {
            storeId = data.id.toString();
          } else if (chosenType == "Бүх дэлгүүр") {
            storeId = "";
          }
        }
        searchAgian = true;
        list.clear();
      });
      _getProductData();
    });
  }

  void _editProductBottom(ProductDetialModel datas) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => EditProductScreen(data: datas))).then((a) {
      setState(() {
        _page = 1;
        for (ProductStoreModel data in storeList) {
          if (data.name == chosenType) {
            storeId = data.id.toString();
          } else if (chosenType == "Бүх дэлгүүр") {
            storeId = "";
          }
        }
        searchAgian = true;
        list.clear();
      });
      _getProductData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _agianSearch() {
    setState(() {
      searchAgian = true;
      _page = 1;
      if (chosenType == "Бүх дэлгүүр" && chosenValue == "Бүх төрөл" && searchValue == "") {
        setState(() {
          storeId = '';
          productType = '';
        });
        _getProductData();
      } else {
        for (ProductStoreModel data in storeList) {
          if (data.name == chosenType) {
            storeId = data.id.toString();
          } else if (chosenType == "Бүх дэлгүүр") {
            storeId = "";
          }
        }
        for (CategoriesModel data in categories) {
          if (chosenValue == data.name) {
            productType = data.id.toString();
          } else if (chosenValue == "Бүх төрөл") {
            productType = "";
          }
        }
        _getProductData();
      }
    });
  }

  void _chooseAction() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: const Column(children: [Center(child: Text("Бараа", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryColor))), Divider()]),
              actions: [
                Column(
                  children: [
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
                              child: Text("Нэмэх", style: TextStyle(color: kPrimaryColor)),
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
                              _showDeleteProduct(context);
                            },
                            color: kPrimaryColor,
                            child: const Center(child: Text("Устгах")),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    BlackBookButton(
                      height: 40,
                      borderRadius: 16,
                      onPressed: () {
                        Navigator.pop(context);
                        _editProductBottom(purchase!);
                      },
                      color: kDisable,
                      child: const Center(
                        child: Text("Засах", style: TextStyle(color: kPrimaryColor)),
                      ),
                    ),
                  ],
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

  _showDeleteProduct(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (ctx) => CustomDialog(
          onPressedSubmit: () {
            removeBloc.add(RemoveProductEvent(goodId));
          },
          title: 'Анхаар',
          desc: "Бараа устгахдаа итгэлтэй байна уу",
          type: 2),
    );
  }

  void addRazmer(ProductDetialModel datas) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => ProductAddSzieScreen(model: datas)));
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
                Future.delayed(const Duration(seconds: 1), () {
                  if (context.mounted) Navigator.pop(context);
                }).then((value) => refreshPage());
              }
            })
      ],
      child: KeyboardDismissOnTap(
        dismissOnCapturedTaps: false,
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: FloatingActionButton(
              mini: true,
              backgroundColor: kDisable,
              onPressed: () => showNewDialog(context, chosenType, typeStore, categories, chosenValue),
              child: const Icon(Icons.remove_red_eye_outlined, color: kPrimaryColor)),
          body: Stack(
            children: [
              Column(
                children: [
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
                        ),
                ],
              ),
              if (_runApi)
                const Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                        strokeWidth: 4,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
