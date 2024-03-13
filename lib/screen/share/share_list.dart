import 'package:black_book/bloc/share/bloc.dart';
import 'package:black_book/bloc/share/event.dart';
import 'package:black_book/bloc/share/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/models/transfer/detial.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:black_book/widget/component/choose_type.dart';
import 'package:black_book/widget/component/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareListHistoryScreen extends StatefulWidget {
  const ShareListHistoryScreen({super.key});
  @override
  State<ShareListHistoryScreen> createState() => _ShareListHistoryScreenState();
}

class _ShareListHistoryScreenState extends State<ShareListHistoryScreen> {
  final bloc = ShareBloc();
  List<TransferDetial> list = [];
  List<TransferDetial> listSearch = [];
  String userRole = "BOSS";
  List<ProductStoreModel> storeList = [];
  String chosenType = "Агуулахаас дэлгүүр рүү шилжүүлэг";
  List<String> typeStore = ["Агуулахаас дэлгүүр рүү шилжүүлэг"];
  String searchValue = "";
  bool searchAgian = false;
  String storeId = "";
  int _page = 1;
  bool _hasMoreOrder = false;
  bool _loadingOrder = false;
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController()..addListener(_loadMoreOrder);
    bloc.add(ShareHistoryEvent(_page, storeId, false, searchValue));
    userRole = Utils.getUserRole();
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
      bloc.add(ShareHistoryEvent(_page, storeId, false, searchValue));
    }
  }

  void _agianSearch() {
    if (chosenType == "Бүх дэлгүүр" && searchValue == "") {
      bloc.add(ShareHistoryEvent(_page, storeId, false, searchValue));
    } else {
      print(searchValue);
      for (ProductStoreModel data in storeList) {
        if (data.name == chosenType) {
          storeId = "";
          storeId = data.id.toString();
        } else if (chosenType == "Бүх дэлгүүр") {
          storeId = "";
        }
      }
      bloc.add(ShareHistoryEvent(_page, storeId, searchAgian, searchValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<ShareBloc, ShareState>(
              bloc: bloc,
              listener: (context, state) {
                if (state is ShareHistoryLoading) {
                  Utils.startLoader(context);
                }
                if (state is ShareHistoryFailure) {
                  if (state.message == "Token") {
                    bloc.add(ShareHistoryEvent(
                        _page, storeId, searchAgian, searchValue));
                  } else {
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                  }
                }
                if (state is ShareHistorySuccess) {
                  Utils.cancelLoader(context);
                  setState(() {
                    _loadingOrder = false;
                    _hasMoreOrder = state.hasMoreOrder;
                    if (searchAgian) {
                      list = state.data!;
                      listSearch = state.data!;
                    } else {
                      list.addAll(state.data!);
                      listSearch.addAll(state.data!);
                    }
                    list.sort((b, a) => a.created_at!.compareTo(b.created_at!));

                    for (ProductStoreModel data in storeList) {
                      typeStore.add(data.name ?? "");
                    }
                    typeStore = typeStore.toSet().toList();
                  });
                }
              })
        ],
        child: Scaffold(
            appBar: AppBar(
                foregroundColor: kWhite,
                title: Image.asset('assets/images/logoSecond.png', width: 160),
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.keyboard_arrow_left, size: 30)),
                backgroundColor: kPrimarySecondColor),
            body: Column(children: [
              // TypeBuilder(
              //   chosenValue: "",
              //   chosenType: chosenType,
              //   userRole: userRole,
              //   typeStore: typeStore,
              //   chooseType: (String value) {
              //     setState(() {
              //       chosenType = value;
              //     });
              //   },
               
              // ),
              // SearchBuilder(
              //   searchAgian: (bool type) {
              //     setState(() {
              //       searchAgian = type;
              //     });
              //     _agianSearch();
              //   },
              //   searchValue: (String value) {
              //     setState(() {
              //       searchValue = value;
              //     });
              //   },
              // ),
              // ListBuilder(
              //   list: list,
              //   showWarningCallback: (String? id) {
              //     setState(() {
              //       goodId = id!;
              //     });
              //   },
              //   showDilaog: () {
              //     _showLogOutWarning(context);
              //   },
              //   controller: _controller,
              //   userRole: userRole,
              //   isExpanded: _isExpanded,
              //   typeTrailling: true, icon: Icons.delete_outline_outlined,
              //   trailingText: "Устгах", screenType: 'ware',
              // )
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(children: [
                    userRole == "BOSS"
                        ? Expanded(
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
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    child: DropdownButton<String>(
                                        isExpanded: true,
                                        iconEnabledColor: kPrimarySecondColor,
                                        value: chosenType,
                                        style: const TextStyle(
                                            color: kPrimarySecondColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                        items: typeStore
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                              value: value, child: Text(value));
                                        }).toList(),
                                        underline: Container(
                                            height: 0,
                                            color: Colors.transparent),
                                        onChanged: (value) {
                                          setState(() {
                                            chosenType = value!;
                                          });
                                        }))))
                        : const SizedBox(width: 0),
                    const SizedBox(width: 10)
                  ])),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
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
                                    hintStyle: const TextStyle(
                                        fontSize: 13, color: Colors.grey))))),
                    const SizedBox(width: 10),
                    InkWell(
                        onTap: () {
                          setState(() {
                            searchAgian = true;
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
                                vertical: 6, horizontal: 20),
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
                                    leading: Container(
                                        height: 80.0,
                                        width: 80.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            child: list[index].product_photo == null
                                                ? Image.asset(
                                                    "assets/images/saleProduct.jpg",
                                                    fit: BoxFit.cover)
                                                : Image.network(
                                                    list[index].product_photo!,
                                                    fit: BoxFit.cover))),
                                    title: Text(
                                        "Барааны нэр: ${list[index].product_name}",
                                        style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold)),
                                    subtitle:
                                        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(
                                          "Барааны код: ${list[index].product_code}",
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.normal)),
                                      Text('Хэмжээ: ${list[index].type!}',
                                          style: const TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          'Дэлгүүр: ${list[index].store_name!}',
                                          style: const TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.normal)),
                                      Text('Анхны үнэ: ${list[index].cost!}',
                                          style: const TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.normal)),
                                      Text('Зарах үнэ: ${list[index].price!}',
                                          style: const TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          'Төрөл: ${list[index].transfer_type!}',
                                          style: const TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.normal))
                                    ]))));
                      }))
            ])));
  }
}
