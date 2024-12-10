import 'package:black_book/bloc/store/bloc.dart';
import 'package:black_book/bloc/store/event.dart';
import 'package:black_book/bloc/store/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/store/store_detial.dart';
import 'package:black_book/screen/login/loginpay.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/custom_dialog.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';

class AddDivision extends StatefulWidget {
  const AddDivision({super.key});

  @override
  State<AddDivision> createState() => _AddDivisionState();
}

class _AddDivisionState extends State<AddDivision> with BaseStateMixin {
  final _bloc = StoreBloc();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController storeName = TextEditingController();
  List<StoreDetialModel> lst = [];

  void onCreate() {
    _bloc.add(CreateStoreEvent(storeName.text, int.parse(phoneNumber.text)));
  }

  @override
  void initState() {
    _bloc.add(const GetStoreEvent());
    super.initState();
  }

  _showLogOutWarning(BuildContext contexts, String message, String keys) async {
    showDialog<void>(
      context: context,
      builder: (ctx) => CustomDialog(
          onPressedSubmit: () {
            Navigator.pop(context);
            Navigator.of(ctx).push(
              CupertinoPageRoute(builder: (ctx) => PayScreen(keys: keys)),
            );
          },
          title: 'Анхаар',
          desc: message,
          type: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StoreBloc, StoreState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is StoreLoading) {
                Utils.startLoader(context);
              }
              if (state is StoreFailure) {
                if (state.message ==
                    "Дэлгүүр нээх эрх дууссан байна, та сунгахуу?") {
                  Utils.cancelLoader(context);
                  // show
                  _showLogOutWarning(
                      context, state.message, "extend_store_limit");
                } else if (state.message == "Token") {
                  _bloc.add(CreateStoreEvent(
                      storeName.text, int.parse(phoneNumber.text)));
                } else {
                  Utils.cancelLoader(context);
                  ErrorMessage.attentionMessage(context, state.message);
                }
              }
              if (state is StoreSuccess) {
                Utils.cancelLoader(context);
                showSuccessDialog("Мэдээлэл", false, "Амжилттай үүсгэлээ");
                // AlertMessage.statusMessage(
                //     context, "Мэдээлэл", "Амжилттай буцаагдлаа", false);
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              }
            }),
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
      child: KeyboardDismissOnTap(
        dismissOnCapturedTaps: false,
        child: Scaffold(
          endDrawerEnableOpenDragGesture: false,
          drawerEnableOpenDragGesture: false,
          appBar: AppBar(
              foregroundColor: kWhite,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30)),
              title: Image.asset('assets/images/logoSecond.png', width: 160),
              backgroundColor: kPrimarySecondColor),
          body: Column(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
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
                                    onTap: () {},
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Text("Салбар дэлгүүр нээх",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.0))))))),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                                height: 50,
                                child: TextField(
                                    textInputAction: TextInputAction.next,
                                    controller: storeName,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      labelText: "Дэлгүүрээ нэрлэнэ үү",
                                      labelStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black38),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black26),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )))),
                        SizedBox(
                            height: 70,
                            child: TextFormField(
                                textInputAction: TextInputAction.done,
                                controller: phoneNumber,
                                maxLength: 8,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    labelText: "Дэлгүүрийн утасны дугаар",
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black38),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black12),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black26),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefix: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Text("(+976)",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                    FontWeight.bold)))))),
                        const Divider(color: Colors.grey),
                        const Text(
                          "Таны бүртгэлтэй дэлгүүрүүд",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ])),
                  lst.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: lst.length,
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
                                          fontSize: 13.0,
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              )),
              Padding(
                padding: EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: MediaQuery.of(context).padding.bottom),
                child: BlackBookButton(
                  width: double.infinity,
                  onPressed: () {
                    if (storeName.text.isEmpty) {
                      ErrorMessage.attentionMessage(context, "Нэр оруулна уу!");
                    } else if (phoneNumber.text.length != 8) {
                      ErrorMessage.attentionMessage(
                          context, "Дугаар оруулна уу!");
                    } else {
                      onCreate();
                    }
                  },
                  // onPressed: () => _saveData(context, widget.model),
                  child: const Text("Хадгалах"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
