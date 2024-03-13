import 'package:badges/badges.dart';
import 'package:black_book/bloc/share/bloc.dart';
import 'package:black_book/bloc/share/event.dart';
import 'package:black_book/bloc/share/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_inlist.dart';
import 'package:black_book/provider/product_share_provider.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/bottom_sheet.dart/product_draft_bottom.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:black_book/widget/component/choose_type.dart';
import 'package:black_book/widget/component/list_builder.dart';
import 'package:black_book/widget/component/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'draft.dart';

class ShareProductScreen extends StatefulWidget {
  const ShareProductScreen({super.key});
  @override
  State<ShareProductScreen> createState() => _ShareProductScreenState();
}

class _ShareProductScreenState extends State<ShareProductScreen> {
  final _bloc = ShareBloc();
  bool show = false;
  List<ProductDetialModel> list = [];
  List<ProductDetialModel> listSearch = [];
  final bool _isExpanded = false;
  String chosenValue = "Бүх төрөл";
  List<String> typeValue = ["Бүх төрөл", "Өвөл", "Хавар", "Намар", "Зун"];
  String searchValue = "";
  bool searchAgian = false;
  String storeId = "";
  String productType = "";
  int _page = 1;
  bool _hasMoreOrder = false;
  bool _loadingOrder = false;
  late ScrollController _controller;
  int? index;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_loadMoreOrder);
    _bloc.add(
        ShareProductDataEvent(_page, searchAgian, productType, searchValue));
  }

  void _loadMoreOrder() {
    if (_hasMoreOrder &&
        _controller.position.extentAfter == 0 &&
        !_loadingOrder) {
      setState(() {
        _loadingOrder = true;
        _page++;
      });
      _bloc.add(
          ShareProductDataEvent(_page, searchAgian, productType, searchValue));
    }
  }

  void _agianSearch() {
    if (chosenValue == "Бүх төрөл" && searchValue == "") {
      _bloc.add(ShareProductDataEvent(_page, false, productType, searchValue));
    } else {
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
      _bloc.add(
          ShareProductDataEvent(_page, searchAgian, productType, searchValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<ShareBloc, ShareState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is ShareProductDataLoading) {
                  Utils.startLoader(context);
                  setState(() {
                    _loadingOrder = false;
                  });
                }
                if (state is ShareProductDataFailure) {
                  if (state.message == "Token") {
                    _bloc.add(ShareProductDataEvent(
                        _page, searchAgian, productType, searchValue));
                  } else {
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                    setState(() {
                      _loadingOrder = false;
                    });
                  }
                }
                if (state is ShareProductDataSuccess) {
                  Utils.cancelLoader(context);
                  setState(() {
                    _loadingOrder = false;
                    list = state.data;
                    _hasMoreOrder = state.hasMoreOrder;
                    listSearch = state.data;
                    list.sort((b, a) => a.created_at!.compareTo(b.created_at!));
                  });
                }
              })
        ],
        child: Consumer<ProductProvider>(builder: (context, provider, child) {
          return Scaffold(
              appBar: AppBar(
                  actions: <Widget>[
                    Badge(
                        position: BadgePosition.topEnd(top: 2, end: 2),
                        badgeContent: Text(provider.lstDraft.length.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10)),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) =>
                                          const ProductDraft()));
                                },
                                icon:
                                    const Icon(Icons.shopping_cart_outlined))))
                  ],
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.keyboard_arrow_left, size: 30)),
                  foregroundColor: kWhite,
                  title:
                      Image.asset('assets/images/logoSecond.png', width: 160),
                  backgroundColor: kPrimarySecondColor),
              body: Column(children: [
                TypeBuilder(
                  chosenValue: chosenValue,
                  chosenType: "",
                  userRole: Utils.getUserRole(),
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
                  screenType: "sale",
                  list: list,
                  showWarningCallback: (int? ind) {
                    setState(() {
                      index = ind;
                    });
                  },
                  showDilaog: () {
                    for(ProductInDetialModel data in list[index!].sizes!){
                      setState(() {
                        data.ware_stock = 0;
                      });
                    }
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return FractionallySizedBox(
                              heightFactor: 0.7,
                              child: ProductBottomSheetsWidget(
                                  title: "Сагс", data: list[index!]));
                        });
                  },
                  controller: _controller,
                  userRole: "ADMIN",
                  isExpanded: _isExpanded,
                  typeTrailling: true,
                  icon: Icons.add_shopping_cart_rounded,
                  trailingText: "Сагс",
                )
              ]));
        }));
  }
}
