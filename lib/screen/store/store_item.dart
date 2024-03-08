import 'package:black_book/bloc/product/bloc.dart';
import 'package:black_book/bloc/product/event.dart';
import 'package:black_book/bloc/product/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/component/choose_type.dart';
import 'package:black_book/widget/component/list_builder.dart';
import 'package:black_book/widget/component/search.dart';
import 'package:black_book/widget/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreItemScreen extends StatefulWidget {
  const StoreItemScreen({super.key, required this.id});
  @override
  State<StoreItemScreen> createState() => _StoreItemScreenState();
  final int id;
}

class _StoreItemScreenState extends State<StoreItemScreen> {
  DateTime dateTime = DateTime.now();
  DateTime date = DateTime.now();
  List<ProductDetialModel> list = [];
  List<ProductDetialModel> listSearch = [];
  final _bloc = ProductBloc();
  bool show = false;
  final bool _isExpanded = false;
  String chosenValue = "Бүх төрөл";
  List<String> typeValue = ["Бүх төрөл", "Өвөл", "Хавар", "Намар", "Зун"];
  String searchValue = "";
  bool searchAgian = false;
  String productType = "";
  int _page = 1;
  bool _hasMoreOrder = false;
  bool _loadingOrder = false;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_loadMoreOrder);
    _bloc.add(
        GetStoreItemEvent(widget.id, productType, _page, false, searchValue));
  }

  void _loadMoreOrder() {
    if (_hasMoreOrder &&
        _controller.position.extentAfter == 0 &&
        !_loadingOrder) {
      setState(() {
        _loadingOrder = true;
        _page++;
      });
      _bloc.add(GetStoreItemEvent(
          widget.id, productType, _page, searchAgian, searchValue));
    }
  }

  void _agianSearch() {
    if (chosenValue == "Бүх төрөл" && searchValue == "") {
      setState(() {
        _page = 1;
      });
      _bloc.add(GetStoreItemEvent(
          widget.id, productType, _page, searchAgian, searchValue));
    } else {
      print(searchValue);

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
      _bloc.add(GetStoreItemEvent(
          widget.id, productType, _page, searchAgian, searchValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is GetStoreItemLoading) {
                  Utils.startLoader(context);
                  setState(() {
                    _loadingOrder = false;
                  });
                }
                if (state is GetStoreItemFailure) {
                  if (state.message == "Token") {
                    _bloc.add(GetStoreItemEvent(widget.id, productType, _page,
                        searchAgian, searchValue));
                  } else {
                    setState(() {
                      _loadingOrder = false;
                    });
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                  }
                }
                if (state is GetStoreItemSuccess) {
                  Utils.cancelLoader(context);
                  setState(() {
                    _loadingOrder = false;
                    _hasMoreOrder = state.hasMoreOrder;
                    if (searchAgian) {
                      list = state.list;
                      listSearch = state.list;
                    } else {
                      list.addAll(state.list);
                      listSearch.addAll(state.list);
                    }
                    list.sort((b, a) => a.created_at!.compareTo(b.created_at!));
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
                controller: _controller,
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
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
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
                                            "Нийт үнийн дүн: ${show ? "" : ""}₮",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)))
                                  ]))))))
            ])));
  }
}
