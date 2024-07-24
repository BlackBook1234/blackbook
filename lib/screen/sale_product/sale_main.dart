import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_inlist.dart';
import 'package:black_book/models/product/response.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/bottom_sheet.dart/sale_product.dart';
import 'package:black_book/widget/component/list_builder.dart';
import 'package:black_book/widget/component/search.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:lottie/lottie.dart';

class MainSellProductScreen extends StatefulWidget {
  const MainSellProductScreen({super.key});
  @override
  State<MainSellProductScreen> createState() => _MainSellProductScreenState();
}

class _MainSellProductScreenState extends State<MainSellProductScreen>
    with BaseStateMixin {
  List<ProductDetialModel> list = [];
  final bool _isExpanded = false;
  String searchValue = "";
  bool searchAgian = false;
  int _page = 1;
  int index = 0;
  late ScrollController _scrollController;
  bool _runApi = false;
  bool first = false;
  final date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_loadMorePages);
    _getProductData().then((value) {
      setState(() {
        first = true;
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
      _runApi = true;
    });
    try {
      ProductResponseModel res = await api.getProductData(
          _page,
          searchAgian,
          Utils.getUserRole() == "BOSS" ? "-1" : Utils.getStoreId().toString(),
          "",
          searchValue);
      setState(() {
        if (searchAgian) {
          list = res.data!;
        } else {
          list.addAll(res.data!);
        }
        if (!first) {
          list = [];
        }
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
    });
    _getProductData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          width: double.infinity,
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
            child: Center(
              child: Text(
                "${date.year}-${date.month}-${date.day}",
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
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
        searchText: "Барааны нэр код",
      ),
      list.isEmpty
          ? Center(
              child: Column(
                children: [
                  Lottie.asset('assets/json/empty-page.json'),
                  const Text(
                    "Зарах барааны код болон\n нэрээр хайна уу!",
                    style: TextStyle(fontSize: 16, color: kDisabledText),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )
          : ListBuilder(
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
                              title: "Бараа зарах", data: list[index]));
                    }).then((value) {
                  setState(() {
                    _page = 1;
                    searchAgian = true;
                  });
                  _getProductData();
                });
              },
              controller: _scrollController,
              userRole: "ADMIN",
              isExpanded: _isExpanded,
              typeTrailling: true,
              icon: Icons.sell,
              trailingText: "Бараа зарах",
              screenType: 'sale',
            ),
    ]);
  }
}
