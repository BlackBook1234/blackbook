import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/models/transfer/detial.dart';
import 'package:black_book/models/transfer/response.dart';
import 'package:black_book/screen/transfer/transfer_detial.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/custom_dialog.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShareListHistoryScreen extends StatefulWidget {
  const ShareListHistoryScreen(
      {super.key, required this.sourceId, required this.inComeOutCome});
  final String sourceId;
  final bool inComeOutCome; // false => all true => income
  @override
  State<ShareListHistoryScreen> createState() => _ShareListHistoryScreenState();
}

class _ShareListHistoryScreenState extends State<ShareListHistoryScreen>
    with BaseStateMixin {
  List<TransferItem> list = [];
  String userRole = "BOSS";
  String storeId = "";
  List<ProductStoreModel> storeList = [];
  String searchValue = "";
  bool searchAgian = false;
  bool _loadingData = false;
  late ScrollController _scrollController;
  int _page = 1;
  DateTime beginDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool? transferType;
  bool _runApi = false;
  bool tidActive = true;
  String chosenType = "Бүх дэлгүүр";
  List<String> typeStore = ["Бүх дэлгүүр"];
  final NumberFormat format = NumberFormat("#,###");
  ProductStoreModel defaultStoreModel = ProductStoreModel(
      name: "Агуулах",
      phone_number: "",
      created_at: DateTime.now().toString(),
      is_main: 1,
      id: -1);

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_loadMorePages);
    _getTransferData();
    userRole = Utils.getUserRole();
    setState(() {
      // endDate = beginDate.add(const Duration(days: 1));
    });
    super.initState();
  }

  void _loadMorePages() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50 &&
        list.length > 39) {
      setState(() {
        _page++;
        searchAgian = false;
      });
      _getTransferData();
    }
  }

  void _agianSearch() {
    setState(() {
      searchAgian = true;
      _page = 1;
    });
    if (chosenType == "Бүх дэлгүүр") {
      setState(() {
        storeId = '';
      });
      _getTransferData();
    } else {
      for (ProductStoreModel data in storeList) {
        if (data.name == chosenType) {
          storeId = "";
          storeId = data.id.toString();
        } else if (chosenType == "Бүх дэлгүүр") {
          storeId = "";
        }
      }
      _getTransferData();
    }
  }

  Future<void> _getTransferData() async {
    if (_runApi) return;
    setState(() {
      if (widget.sourceId == "") {
        tidActive = false;
      }
      _runApi = true;
    });
    try {
      TransferDataResponse res = await api.getTransferHistory(
          beginDate,
          endDate,
          searchAgian,
          storeId,
          _page,
          tidActive ? widget.sourceId : "",
          widget.inComeOutCome);
      setState(() {
        if (searchAgian) {
          list = res.data!;
          _runApi = false;
        } else {
          _runApi = false;
          list.addAll(res.data!);
        }
        storeList = res.stores!;
        storeList.add(defaultStoreModel);
        for (ProductStoreModel data in storeList) {
          typeStore.add(data.name ?? "");
        }
        typeStore = typeStore.toSet().toList();
      });
    } on APIError catch (e) {
      setState(() {
        _runApi = false;
      });
      showErrorDialog(e.message);
    }
  }

  _showAcceptDecline(BuildContext context, String tid) async {
    showDialog<void>(
      context: context,
      builder: (ctx) => CustomDialog(
          footerCancelText: "Татгалзах",
          footerSubmitText: "Зөвшөөрөх",
          onBackSubmit: () {
            setState(() {
              transferType = false;
            });
            _transferDataSend(transferType!, tid);
          },
          onPressedSubmit: () {
            setState(() {
              transferType = true;
            });
            _transferDataSend(transferType!, tid);
          },
          title: 'Анхаар',
          desc: "Бараа шилжүүлэгийг зөвшөөрөх үү?",
          type: 3),
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  Future<void> _transferDataSend(bool type, String tid) async {
    if (_loadingData) return;
    setState(() {
      _loadingData = true;
    });
    try {
      await api.setTranferType(type, tid);
      setState(() {
        _loadingData = false;
      });
      await showSuccessPopDialog(
              "Амжилттай", true, true, "Барааны төрөл шинэчлэгдлээ")
          .then((value) {
        setState(() {
          searchAgian = true;
          tidActive = true;
        });
        Navigator.pop(context);
        _getTransferData();
      });
      // await _agianSearch();
    } on APIError catch (e) {
      showErrorDialog(e.message);
      setState(() {
        _loadingData = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),
          foregroundColor: kWhite,
          title: Image.asset('assets/images/logoSecond.png', width: 160),
          backgroundColor: kPrimarySecondColor),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _showDialog(CupertinoDatePicker(
                                  initialDateTime: beginDate,
                                  mode: CupertinoDatePickerMode.date,
                                  use24hFormat: true,
                                  onDateTimeChanged: (DateTime newDate) {
                                    setState(() => beginDate = newDate);
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
                                    borderRadius: BorderRadius.circular(10)),
                                child: SizedBox(
                                    height: 40,
                                    child: Center(
                                        child: Text(
                                            "Эхлэх огноо ${beginDate.year}-${beginDate.month}-${beginDate.day}",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w500))))))),
                    const SizedBox(width: 10),
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _showDialog(CupertinoDatePicker(
                                  initialDateTime: endDate,
                                  mode: CupertinoDatePickerMode.date,
                                  use24hFormat: true,
                                  onDateTimeChanged: (DateTime newDate) {
                                    setState(() => endDate = newDate);
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
                                    borderRadius: BorderRadius.circular(10)),
                                child: SizedBox(
                                    height: 40,
                                    child: Center(
                                        child: Text(
                                            "Дуусах огноо ${endDate.year}-${endDate.month}-${endDate.day}",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w500)))))))
                  ])),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                BlackBookButton(
                  height: 38,
                  width: 80,
                  borderRadius: 14,
                  onPressed: () {
                    setState(() {
                      searchAgian = true;
                      _agianSearch();
                    });
                  },
                  color: kPrimaryColor,
                  child: const Center(
                    child: Text("Хайх"),
                  ),
                ),
                // InkWell(
                //     onTap: () {
                //       setState(() {
                //         searchAgian = true;
                //         _agianSearch();
                //       });
                //     },
                //     child: Container(
                //         width: 80,
                //         height: 38,
                //         decoration: BoxDecoration(
                //             color: kPrimaryColor,
                //             boxShadow: [
                //               BoxShadow(
                //                   color: Colors.grey.shade300,
                //                   blurRadius: 3,
                //                   offset: const Offset(2, 2))
                //             ],
                //             borderRadius: BorderRadius.circular(10)),
                //         child: const Center(
                //             child:
                //                 Text("Хайх", style: TextStyle(color: kWhite)))))
              ])),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                    child: ListTile(
                      trailing: InkWell(
                          onTap: () {
                            _showAcceptDecline(context, list[index].tid!);
                          },
                          child: list[index].isShowConfirmation ?? false
                              ? const Column(children: [
                                  Icon(Icons.info, color: kPrimaryColor),
                                  Text("Батлах",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10))
                                ])
                              : const SizedBox.shrink()),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) =>
                                TransferItemDetial(lst: list[index])));
                      },
                      leading: Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.asset(
                                  "assets/images/saleProduct.jpg",
                                  fit: BoxFit.cover))),
                      title: Text(
                        list[index].description ?? "",
                        style: const TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Төлөв: ',
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.normal)),
                              Expanded(
                                  child: Text('${list[index].status_text}',
                                      style: const TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.normal)))
                            ],
                          ),
                          Text(
                              "Он сар: ${formatDate(list[index].created_at ?? "")}",
                              style: const TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal)),
                          Text(
                              "Нийт үнэ: ${format.format(list[index].total_price ?? 0)}₮",
                              style: const TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal)),
                          Text(
                              'Тоо: ${format.format(list[index].total_count ?? 0)}ш',
                              style: const TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal)),
                          Text(
                            'Төрөл: ${list[index].transfer_type}',
                            style: const TextStyle(
                                fontSize: 11.0, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
