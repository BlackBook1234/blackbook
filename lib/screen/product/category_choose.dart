import 'package:black_book/bloc/category/bloc.dart';
import 'package:black_book/bloc/category/event.dart';
import 'package:black_book/bloc/category/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/category/category_detial.dart';
import 'package:black_book/screen/product/add_item_detial.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class ChooseCategoryScreen extends StatefulWidget {
  ChooseCategoryScreen({super.key, required this.itemType});
  @override
  State<ChooseCategoryScreen> createState() => _ChooseCategoryScreenState();
  String itemType;
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  final _bloc = CategoryBloc();
  String parent = '';
  List<CategoryDetialModel> list = [];

  @override
  void initState() {
    if (widget.itemType == "Өвөл") {
      setState(() {
        parent = "WINTER";
      });
    } else if (widget.itemType == "Зун") {
      setState(() {
        parent = "SUMMER";
      });
    } else if (widget.itemType == "Хавар") {
      setState(() {
        parent = "SPRING";
      });
    } else {
      setState(() {
        parent = "AUTUMN";
      });
    }
    _bloc.add(GetCategoryEvent(parent));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<CategoryBloc, CategoryState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is GetCategoryLoading) {
                  Utils.startLoader(context);
                }
                if (state is GetCategoryFailure) {
                  if (state.message == "Token") {
                    _bloc.add(GetCategoryEvent(parent));
                  } else {
                    Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                  }
                }
                if (state is GetCategorySuccess) {
                  Utils.cancelLoader(context);
                  setState(() {
                    list = state.list;
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
              Expanded(
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 20),
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
                                    trailing: SvgPicture.asset(
                                        "assets/svg/right_arrow.svg",
                                        width: 7,
                                        colorFilter: const ColorFilter.mode(
                                            kPrimaryColor, BlendMode.srcIn)),
                                    leading: Image.asset(
                                        "assets/images/clothes.png",
                                        width: 50.0),
                                    title: Text(
                                        "Багц: ${list[index].parent_name}",
                                        style: const TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text("Төрөл: ${list[index].name}",
                                        style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  AddItemDetialScreen(
                                                      id: list[index].id!)));
                                    })));
                      })))
            ])));
  }
}
