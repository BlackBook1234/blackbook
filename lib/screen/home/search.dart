import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/models/product/response.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/component/choose_type.dart';
import 'package:black_book/widget/component/list_builder.dart';
import 'package:black_book/widget/component/search.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with BaseStateMixin {
  List<ProductDetialModel> list = [];
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
  bool _runApi = false;
  late ScrollController _scrollController;
  var refresh = GlobalKey<RefreshIndicatorState>();
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
    _getProductData().then((value) {
      setState(() {
        chosenType = Utils.getstoreName();
      });
    });
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
      ProductResponseModel res = await api.getProductDataSearch(
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
      });
    } on APIError catch (e) {
      setState(() {
        _runApi = false;
      });
      showErrorDialog(e.message);
    }
  }

  void _agianSearch() {
    setState(() {
      _page = 1;
      searchAgian = true;
    });
    if (chosenType == "Бүх дэлгүүр" &&
        chosenValue == "Бүх төрөл" &&
        searchValue == "") {
      setState(() {
        storeId = "";
        productType = "";
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

  Future<void> refreshList() async {
    refresh.currentState?.show(atTop: false);
    setState(() {
      searchAgian = true;
      _page = 1;
      searchValue = "";
      storeId = "";
      productType = "";
    });
    await _getProductData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kPrimaryColor,
      backgroundColor: kWhite,
      key: refresh,
      onRefresh: refreshList,
      child: Column(
        children: [
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
              setState(
                () {
                  searchValue = value;
                },
              );
            },
          ),
          list.isEmpty
              ? Center(
                  child: Lottie.asset('assets/json/empty-page.json'),
                )
              : ListBuilder(
                  list: list,
                  controller: _scrollController,
                  userRole: "BOSS",
                  isExpanded: _isExpanded,
                  typeTrailling: false,
                  icon: Icons.abc,
                  trailingText: "",
                  screenType: 'search',
                ),
        ],
      ),
    );
  }
}
