import 'package:black_book/bloc/store/bloc.dart';
import 'package:black_book/bloc/store/event.dart';
import 'package:black_book/bloc/store/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/store/store_detial.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'store_item.dart';

class DivisionScreen extends StatefulWidget {
  const DivisionScreen({super.key});
  @override
  State<DivisionScreen> createState() => _DivisionScreenState();
}

// GetStoreEvent
class _DivisionScreenState extends State<DivisionScreen> {
  final _bloc = StoreBloc();
  List<StoreDetialModel> lst = [];

  @override
  void initState() {
    _bloc.add(const GetStoreEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StoreBloc, StoreState>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is GetStoreLoading) {
              Utils.startLoader(context);
            }
            if (state is GetStoreFailure) {
              if (state.message == "Token") {
                _bloc.add(const GetStoreEvent());
              } else {
                Utils.cancelLoader(context);
                ErrorMessage.attentionMessage(context, state.message);
              }
            }
            if (state is GetStoreSuccess) {
              Utils.cancelLoader(context);
              setState(() {
                lst = state.list;
              });
            }
          },
        )
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
        body: Column(
          children: [
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: lst.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhite,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 3,
                              offset: const Offset(2, 2))
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "assets/icons/store.svg",
                          width: 40,
                          colorFilter: const ColorFilter.mode(
                              kPrimaryColor, BlendMode.srcIn),
                        ),
                        title: Text(
                          lst[index].name!,
                          style: const TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) =>
                                  StoreItemScreen(id: lst[index].id!),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
