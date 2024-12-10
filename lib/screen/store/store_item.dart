import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/global_keys.dart';
import 'package:black_book/models/product/categories.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/response.dart';
import 'package:black_book/models/product/total.dart';
import 'package:black_book/provider/type.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/bottom_sheet.dart/product_bottom.dart';
import 'package:black_book/widget/component/choose_type.dart';
import 'package:black_book/widget/component/list_builder.dart';
import 'package:black_book/widget/component/search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StoreItemScreen extends StatefulWidget {
  const StoreItemScreen({super.key, required this.id});
  @override
  State<StoreItemScreen> createState() => _StoreItemScreenState();
  final int id;
}

class _StoreItemScreenState extends State<StoreItemScreen> with BaseStateMixin {
  DateTime dateTime = DateTime.now();
  DateTime date = DateTime.now();
  List<ProductDetialModel> list = [];
  bool show = false;
  final bool _isExpanded = false;
  String chosenValue = "Бүх төрөл";
  List<String> typeValue = ["Бүх төрөл"];
  String searchValue = "";
  bool searchAgian = true;
  String productType = "";
  int _page = 1;
  String userRole = "BOSS";
  bool _runApi = false;
  late ScrollController _scrollController;
  TotalProductModel? total;
  final NumberFormat format = NumberFormat("#,###");
  List<CategoriesModel> categories = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_loadMorePages);
    userRole = Utils.getUserRole();
    _getProductData();
  }

  void _loadMorePages() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50 &&
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
      _runApi = true;
    });
    try {
      ProductResponseModel res = await api.getProductDataSearch(
          _page, searchAgian, widget.id.toString(), productType, searchValue);
      setState(() {
        if (searchAgian) {
          list = res.data!;
        } else {
          list.addAll(res.data!);
        }
        total = res.total;
        categories = res.categories!;
        Provider.of<TypeProvider>(GlobalKeys.navigatorKey.currentContext!,
                listen: false)
            .setTypeList(res.categories!.map((e) => e.name).toList());
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
    if (chosenValue == "Бүх төрөл" && searchValue == "") {
      setState(() {
        _page = 1;
        searchAgian = true;
      });
      _getProductData();
    } else {
      for (CategoriesModel data in categories) {
        if (chosenValue == data.name) {
          productType = data.parent;
        } else if (chosenValue == "Бүх төрөл") {
          productType = "";
        }
      }
      _getProductData();
    }
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
          TypeBuilder(
            // typeValue:typeValue,
            chosenValue: chosenValue,
            chosenType: "",
            userRole: "",
            chooseType: (String value) {
              setState(() {
                chosenValue = value;
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
            controller: _scrollController,
            userRole: "",
            isExpanded: _isExpanded,
            typeTrailling: false,
            icon: Icons.delete_outline_outlined,
            trailingText: "",
            screenType: 'store',
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
                                  child: BottomProductSheetsWidget(
                                    data: total!,
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
                                        "Нийт үнийн дүн: ${show ? format.format(total!.price) : ""}₮",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)))
                              ]))))))
        ]));
  }
}
