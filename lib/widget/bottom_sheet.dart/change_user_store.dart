import "package:black_book/bloc/authentication/bloc.dart";
import "package:black_book/bloc/authentication/event.dart";
import "package:black_book/bloc/authentication/state.dart";
import "package:black_book/bloc/store/bloc.dart";
import "package:black_book/bloc/store/event.dart";
import "package:black_book/bloc/store/state.dart";
import "package:black_book/constant.dart";
import "package:black_book/models/store/store_detial.dart";
import "package:black_book/screen/home/navigator.dart";
import "package:black_book/util/utils.dart";
import "package:black_book/widget/alert/component/buttons.dart";
import "package:black_book/widget/alert/mixin_dialog.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";

class ChangeUserBottom extends StatefulWidget {
  const ChangeUserBottom({super.key, required this.title});
  @override
  State<ChangeUserBottom> createState() => _ChangeUserBottomState();
  final String title;
}

class _ChangeUserBottomState extends State<ChangeUserBottom>
    with BaseStateMixin {
  List<StoreDetialModel> lst = [];
  final _bloc = StoreBloc();
  final _userBloc = AuthenticationBloc();
  int storeid = 0;
  String phoneNumber = "";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _bloc.add(const GetStoreEvent());
    super.initState();
  }

  void _changePhoneNumber() {
    var alert = AlertDialog(
        backgroundColor: kWhite,
        content: TextFormField(
            textInputAction: TextInputAction.done,
            controller: _controller,
            maxLength: 8,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                labelText: "Утасны дугаар",
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black38),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10)),
                prefix: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("(+976)",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))))),
        actions: [
          Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    kPrimaryColor,
                    Colors.orange.shade300,
                    kPrimaryColor
                  ]),
                  borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                  style: ElevatedButton.styleFrom(foregroundColor: kWhite),
                  onPressed: () {
                    if (_controller.text.length == 8) {
                      _changeUser(storeid, _controller.text);
                    } else {
                      showWarningDialog("Дугаараа бүрэн оруулна уу!");
                    }
                  },
                  child: const Text("Солих", style: TextStyle(fontSize: 14))))
        ]);

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  _changeUser(int storeId, String phoneNumber) {
    _userBloc.add(ChangeUserEvent(storeId, phoneNumber));
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
                    showErrorDialog(state.message);
                    // AlertMessage.statusMessage(
                    //     context, "Алдаа!", state.message, true);
                  }
                }
                if (state is GetStoreSuccess) {
                  Utils.cancelLoader(context);
                  setState(() {
                    lst = state.list;
                    // if (Utils.getUserRole() != "BOSS") {
                    //   lst.add(defaultStoreModel);
                    // }
                  });
                }
              }),
          BlocListener<AuthenticationBloc, UserState>(
              bloc: _userBloc,
              listener: (context, state) async {
                if (state is ChangeUserLoading) {
                  Utils.startLoader(context);
                }
                if (state is ChangeUserFailure) {
                  if (state.message == "Token") {
                    _userBloc.add(ChangeUserEvent(storeid, phoneNumber));
                  } else {
                    Utils.cancelLoader(context);
                    showErrorDialog(state.message);
                    // AlertMessage.alertMessage(context, "Алдаа!", state.message);
                  }
                }
                if (state is ChangeUserSuccess) {
                  Utils.cancelLoader(context);
                  await showSuccessPopDialog(
                          "Мэдээлэл", true, true, "Амжилттай солигдлоо")
                      .then((value) => Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const NavigatorScreen(
                              screenIndex: 0,
                            ),
                          ),
                          (route) => false));
                }
              })
        ],
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(children: [
              Text(widget.title,
                  style: const TextStyle(
                      color: kPrimarySecondColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              const Divider(),
              Expanded(
                  child: ListView.builder(
                      itemCount: lst.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: lst[index].isChecked
                                        ? Colors.grey.shade600
                                        : kWhite,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 3,
                                          offset: const Offset(2, 2))
                                    ],
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                    leading: SvgPicture.asset(
                                        "assets/icons/store.svg",
                                        width: 40,
                                        colorFilter: ColorFilter.mode(
                                            lst[index].isChecked
                                                ? kWhite
                                                : kPrimaryColor,
                                            BlendMode.srcIn)),
                                    title: Text(lst[index].name!,
                                        style: lst[index].isChecked
                                            ? const TextStyle(
                                                color: kWhite,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold)
                                            : const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold)),
                                    subtitle: Text(lst[index].phone_number!,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold)),
                                    onTap: () {
                                      setState(() {
                                        for (StoreDetialModel data in lst) {
                                          if (data.isChecked == true) {
                                            data.isChecked = false;
                                          }
                                        }
                                        lst[index].isChecked = true;
                                      });
                                    })));
                      })),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                child: BlackBookButton(
                  width: double.infinity,
                  onPressed: () {
                    for (StoreDetialModel data in lst) {
                      if (data.isChecked) {
                        setState(() {
                          storeid = data.id!;
                          phoneNumber = data.phone_number!;
                        });
                      }
                    }
                    if (phoneNumber == "") {
                    } else {
                      // _changeUser(storeid, phoneNumber);
                      _changePhoneNumber();
                    }
                  },
                  child: const Text("Дугаар солих"),
                ),
              ),
            ])));
  }
}
