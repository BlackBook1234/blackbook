import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/response.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/component/list_builder.dart';
import 'package:black_book/widget/component/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class DateProductSearch extends StatefulWidget {
  const DateProductSearch({super.key});
  @override
  State<DateProductSearch> createState() => _DateProductSearchState();
}

class _DateProductSearchState extends State<DateProductSearch>
    with BaseStateMixin {
  List<ProductDetialModel> list = [];
  String searchValue = "";
  bool searchAgian = false;
  int _page = 1;
  bool _runApi = false;
  late ScrollController _scrollController;
  var refresh = GlobalKey<RefreshIndicatorState>();
  DateTime begindate = DateTime.now();
  DateTime enddate = DateTime.now();
  final NumberFormat format = NumberFormat("#,###");

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_loadMorePages);
    final newDateTime = begindate.subtract(const Duration(days: 1));
    setState(() {
      begindate = newDateTime;
    });
    _getProductData();
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(top: false, child: child)));
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
      if (searchAgian) {
        list.clear();
      }
      _runApi = true;
    });
    try {
      ProductResponseModel res = await api.getDateProductDataSearch(_page,
          searchAgian, begindate.toString(), enddate.toString(), searchValue);
      setState(() {
        if (searchAgian) {
          list = res.data!;
        } else {
          list.addAll(res.data!);
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
      searchAgian = true;
    });
    _getProductData();
  }

  Future<void> refreshList() async {
    refresh.currentState?.show(atTop: false);
    setState(() {
      searchAgian = true;
      _page = 1;
      searchValue = "";
    });
    await _getProductData();
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
      body: Stack(
        children: [
          RefreshIndicator(
            color: kPrimaryColor,
            backgroundColor: kWhite,
            key: refresh,
            onRefresh: refreshList,
            child: KeyboardDismissOnTap(
              dismissOnCapturedTaps: false,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: InkWell(
                                    onTap: () {
                                      _showDialog(CupertinoDatePicker(
                                          initialDateTime: begindate,
                                          mode: CupertinoDatePickerMode.date,
                                          use24hFormat: true,
                                          onDateTimeChanged:
                                              (DateTime newDate) {
                                            setState(() => begindate = newDate);
                                          }));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: kWhite,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.shade300,
                                                  blurRadius: 3,
                                                  offset: const Offset(2, 2))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: SizedBox(
                                            height: 40,
                                            child: Center(
                                                child: Text(
                                                    "Эхлэх огноо ${begindate.year}-${begindate.month}-${begindate.day}",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight
                                                            .w500))))))),
                            const SizedBox(width: 10),
                            Expanded(
                                child: InkWell(
                                    onTap: () {
                                      _showDialog(CupertinoDatePicker(
                                          initialDateTime: enddate,
                                          mode: CupertinoDatePickerMode.date,
                                          use24hFormat: true,
                                          onDateTimeChanged:
                                              (DateTime newDate) {
                                            setState(() => enddate = newDate);
                                          }));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: kWhite,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.shade300,
                                                  blurRadius: 3,
                                                  offset: const Offset(2, 2))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: SizedBox(
                                            height: 40,
                                            child: Center(
                                                child: Text(
                                                    "Дуусах огноо ${enddate.year}-${enddate.month}-${enddate.day}",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight
                                                            .w500)))))))
                          ])),
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
                      : Expanded(
                          child: ListView.builder(
                              itemCount: list.length,
                              controller: _scrollController,
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
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: ExpansionTile(
                                          shape: const Border(),
                                          collapsedIconColor: kPrimaryColor,
                                          leading: GestureDetector(
                                              onTap: () async {
                                                await showDialog(
                                                    context: context,
                                                    builder: (_) => imageDialog(
                                                        list[index].photo,
                                                        context));
                                              },
                                              child: SizedBox(
                                                  width: 100,
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          (index + 1)
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Container(
                                                            height: 80.0,
                                                            width: 80.0,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        20.0)),
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            9),
                                                                child: list[index].photo ==
                                                                        null
                                                                    ? Image.asset(
                                                                        "assets/images/saleProduct.jpg",
                                                                        fit: BoxFit
                                                                            .cover)
                                                                    : Image.network(
                                                                        list[index].photo!,
                                                                        fit: BoxFit.cover)))
                                                      ]))),
                                          title: Text(
                                              "Барааны нэр: ${list[index].name}",
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold)),
                                          subtitle: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Барааны код: ${list[index].code}",
                                                    style: const TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                Text(
                                                    'Авсан үнэ: ${format.format(list[index].sizes!.first.cost ?? 0)}₮',
                                                    style: const TextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                Text(
                                                    'Зарах үнэ: ${format.format(list[index].sizes!.first.price ?? 0)}₮',
                                                    style: const TextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ]),
                                          initiallyExpanded: false,
                                          children: [
                                            const Row(children: [
                                              Expanded(
                                                  child: Divider(indent: 10)),
                                              SizedBox(width: 4),
                                              Icon(Icons.circle,
                                                  size: 4,
                                                  color: kPrimaryColor),
                                              SizedBox(width: 4),
                                              Expanded(
                                                  child: Divider(endIndent: 10))
                                            ]),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                      getSizesString(
                                                          list[index].sizes),
                                                      style: const TextStyle(
                                                          fontSize: 11.0,
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                  Text(
                                                      getWareString(
                                                          list[index].sizes),
                                                      style: const TextStyle(
                                                          fontSize: 11.0,
                                                          fontWeight: FontWeight
                                                              .normal))
                                                ])
                                          ])),
                                );
                              }))
                ],
              ),
            ),
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
    );
  }
}
