import 'package:black_book/bloc/sale/bloc.dart';
import 'package:black_book/bloc/sale/event.dart';
import 'package:black_book/bloc/sale/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/sale/total.dart';
import 'package:black_book/models/sale_product/product_in_detial.dart';
import 'package:black_book/screen/transfer/transfer_detial.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/custom_dialog.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/bottom_sheet.dart/show_bottom.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SoldItemScreen extends StatefulWidget {
  const SoldItemScreen(
      {super.key,
      required this.id,
      required this.begindate,
      required this.endDate});
  final int id;
  final DateTime begindate, endDate;
  @override
  State<SoldItemScreen> createState() => _SoldItemScreenState();
}

class _SoldItemScreenState extends State<SoldItemScreen> with BaseStateMixin {
  DateTime dateTime = DateTime.now();
  DateTime date = DateTime.now();
  bool show = false;
  final NumberFormat format = NumberFormat("#,###");
  List<SaleProductInDetialModel> list = [];
  List<SaleProductInDetialModel> listSearch = [];
  final _bloc = SaleBloc();
  TotalSaleModel? amount;
  bool searchAgian = false;
  String searchValue = "";
  int? backamount, backsaleId, backstock;
  int _page = 1;
  bool _hasMoreOrder = false;
  bool _loadingOrder = false;
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController()..addListener(_loadMoreOrder);
    _bloc.add(GetSaleEvent(widget.id, searchAgian, searchValue, _page,
        widget.begindate, widget.endDate));
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
      _bloc.add(GetSaleEvent(widget.id, searchAgian, searchValue, _page,
          widget.begindate, widget.endDate));
    }
  }

  void _agianSearch() {
    _bloc.add(GetSaleEvent(widget.id, searchAgian, searchValue, _page,
        widget.begindate, widget.endDate));
    // _bloc.add(
    //     GetSaleEvent(_page, searchAgian, storeId, productType, searchValue));
  }

  void _backProduct(SaleProductInDetialModel data) {
    setState(() {
      backamount = data.price;
      backsaleId = data.sale_id;
      backstock = data.stock;
    });
    _bloc.add(SaleProductBack(data.price!, data.sale_id!, data.stock!));
  }

  _showLogOutWarning(
      BuildContext context, SaleProductInDetialModel data) async {
    showDialog<void>(
      context: context,
      builder: (ctx) => CustomDialog(
          onPressedSubmit: () => _backProduct(data),
          title: 'Анхаар',
          desc: "Зарагдсан барааг буцаах уу?",
          type: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<SaleBloc, SaleState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is GetSaleLoading) {
                  Utils.startLoader(context);
                  setState(() {
                    _loadingOrder = false;
                  });
                }
                if (state is GetSaleFailure) {
                  if (state.message == "Token") {
                    _bloc.add(GetSaleEvent(widget.id, searchAgian, searchValue,
                        _page, widget.begindate, widget.endDate));
                  } else {
                    setState(() {
                      _loadingOrder = false;
                    });
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                  }
                }
                if (state is GetSaleSuccess) {
                  Utils.cancelLoader(context);
                  setState(() {
                    _loadingOrder = false;
                    _hasMoreOrder = state.hasMoreOrder;
                    amount = state.total;
                    list = state.list;
                    listSearch = state.list;
                    // list.sort((b, a) => a.created_at!.compareTo(b.created_at!));
                  });
                }
              }),
          BlocListener<SaleBloc, SaleState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is SaleProductBackLoading) {
                  Utils.startLoader(context);
                }
                if (state is SaleProductBackFailure) {
                  if (state.message == "Token") {
                    _bloc.add(
                        SaleProductBack(backamount!, backsaleId!, backstock!));
                  } else {
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                  }
                }
                if (state is SaleProductBackSuccess) {
                  Utils.cancelLoader(context);
                  showSuccessDialog("Мэдээлэл", false, "Амжилттай буцаагдлаа");
                  // AlertMessage.statusMessage(
                  //     context, "Мэдээлэл", "Амжилттай буцаагдлаа", false);
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pop(context);
                    Navigator.pop(context);
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
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(children: [
                    Expanded(
                        child: SizedBox(
                            height: 35,
                            child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchValue = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black26, width: 1)),
                                    hoverColor: Colors.black12,
                                    focusColor: Colors.black12,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black26, width: 1)),
                                    fillColor: kWhite,
                                    hintText: "Барааны код",
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(10),
                                    prefixIcon: const Icon(Icons.search,
                                        color: kPrimaryColor),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    hintStyle:
                                        const TextStyle(fontSize: 14))))),
                    const SizedBox(width: 10),
                    InkWell(
                        onTap: () {
                          setState(() {
                            searchAgian = true;
                            _page = 1;
                            _agianSearch();
                          });
                        },
                        child: Container(
                            width: 80,
                            height: 38,
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 3,
                                      offset: const Offset(2, 2))
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                                child: Text("Хайх",
                                    style: TextStyle(color: kWhite)))))
                  ])),
              Expanded(
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: list.length,
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
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                    trailing: Utils.getUserRole() == "BOSS"
                                        ? InkWell(
                                            child: const Icon(
                                                Icons.settings_backup_restore,
                                                color: kPrimaryColor),
                                            onTap: () {
                                              _showLogOutWarning(
                                                  context, list[index]);
                                            },
                                          )
                                        : const SizedBox.shrink(),
                                    leading: SizedBox(
                                      width: 100,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            (index + 1).toString(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          GestureDetector(
                                              onTap: () async {
                                                await showDialog(
                                                    context: context,
                                                    builder: (_) => imageDialog(
                                                        list[index]
                                                            .product_photo,
                                                        context));
                                              },
                                              child: Container(
                                                  height: 80.0,
                                                  width: 80.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              9),
                                                      child: list[index]
                                                                  .product_photo ==
                                                              null
                                                          ? Image.asset(
                                                              "assets/images/saleProduct.jpg",
                                                              fit: BoxFit.cover)
                                                          : Image.network(
                                                              list[index]
                                                                  .product_photo!,
                                                              fit: BoxFit.cover))))
                                        ],
                                      ),
                                    ),
                                    title: Text(
                                        "Барааны нэр: ${list[index].product_name}",
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
                                            "Барааны код: ${list[index].product_code}",
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Utils.getUserRole() == "BOSS"
                                              ? Text(
                                                  'Авсан үнэ: ${format.format(list[index].cost)}₮',
                                                  style: const TextStyle(
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.normal))
                                              : const SizedBox.shrink(),
                                          Text(
                                            'Зарсан үнэ: ${format.format(list[index].price)}₮',
                                            style: const TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            'Төрөл: ${list[index].money_type == "CASH" ? "Бэлэн" : list[index].money_type == "ACC" ? "Шилжүүлэг" : "Карт"}',
                                            style: const TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text('Хэмжээ: ${list[index].type}',
                                              style: const TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text('Тоо: ${list[index].stock}ш',
                                              style: const TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ]))));
                      })),
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
                                      heightFactor: 0.4,
                                      child: BottomSheetsWidget(
                                        title: "Дэлгэрэнгүй",
                                        data: amount!,
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
                                            "Нийт үнийн дүн: ${show ? amount!.price.toString() : ""}₮",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)))
                                  ]))))))
            ])));
  }
}
