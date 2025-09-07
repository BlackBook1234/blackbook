import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/provider/user_provider.dart';
import 'package:black_book/screen/core/add_division.dart';
import 'package:black_book/screen/friend/friend_list.dart';
import 'package:black_book/screen/home/navigator.dart';
import 'package:black_book/screen/home/widget/banners_carousel.dart';
import 'package:black_book/screen/login/login.dart';
import 'package:black_book/screen/transfer/share_list.dart';
import 'package:black_book/screen/share/share_product.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/bottom_sheet.dart/change_user_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'alert/custom_dialog.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with BaseStateMixin {
  final TextEditingController _controller = TextEditingController();

  void _addFriendRequest(context) async {
    try {
      await api.addFriendRequest(phoneNumber: _controller.text);
      await showSuccessPopDialog('Мэдээлэл', true, true, 'Амжилттай урилаа').then((value) => Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
              builder: (context) => const NavigatorScreen(
                    screenIndex: 0,
                  )),
          (route) => false));
    } on APIError catch (e) {
      showErrorDialog(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: kWhite,
        child: SafeArea(
          top: false,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(color: kPrimaryColor, height: 30),
            Container(
                height: isPhoneType() + 40,
                width: double.infinity,
                color: kPrimaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image.asset('assets/images/logoSecond.png', height: 30),
                    ),
                  ],
                )),
            Stack(children: [
              Positioned(
                child: Container(
                  height: 50,
                  color: kPrimaryColor,
                ),
              ),
              Positioned(
                  child: Container(
                      height: 350,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: kPrimarySecondColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), topRight: Radius.circular(20))),
                      child: Column(children: [
                        SizedBox(height: getSize(10)),
                        SizedBox(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 14,
                              ),
                              const Icon(
                                Icons.person_outline,
                                color: Colors.white60,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 14,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Дугаар: ${Utils.getPhone()}", style: const TextStyle(color: Colors.white60, fontSize: 13.0, fontWeight: FontWeight.bold)),
                                  Text("Дэлгүүр: ${Utils.getstoreName()}", style: const TextStyle(color: Colors.white60, fontSize: 13.0, fontWeight: FontWeight.bold))
                                ],
                              )
                            ],
                          ),
                        ),
                        const Divider(),
                        ListTile(
                            trailing: SvgPicture.asset("assets/svg/right_arrow.svg", width: 7, colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn)),
                            leading: const Icon(
                              Icons.home_outlined,
                              color: Colors.white60,
                              size: 30,
                            ),
                            title: const Text("Нүүр", style: TextStyle(color: Colors.white60, fontSize: 13.0, fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => const NavigatorScreen(
                                            screenIndex: 0,
                                          )),
                                  (route) => false);
                            }),
                        ListTile(
                            trailing: SvgPicture.asset("assets/svg/right_arrow.svg", width: 7, colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn)),
                            leading: SvgPicture.asset("assets/svg/warehouse.svg", width: 28, colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn)),
                            title: const Text("Шилжиж ирсэн бараа", style: TextStyle(color: Colors.white60, fontSize: 13.0, fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => const ShareListHistoryScreen(
                                        inComeOutCome: true,
                                        sourceId: '',
                                      )));
                            }),
                        ListTile(
                            trailing: SvgPicture.asset("assets/svg/right_arrow.svg", width: 7, colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn)),
                            leading: SvgPicture.asset("assets/svg/add_store.svg", width: 28, colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn)),
                            title: const Text(
                              "Бараа шилжүүлсэн түүх",
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const ShareListHistoryScreen(inComeOutCome: false, sourceId: '')));
                            }),
                        ListTile(
                            trailing: SvgPicture.asset("assets/svg/right_arrow.svg", width: 7, colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn)),
                            leading: SvgPicture.asset("assets/svg/share.svg", width: 28, colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn)),
                            title: const Text("Бараа шилжүүлэг", style: TextStyle(color: Colors.white60, fontSize: 13.0, fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const ShareProductScreen()));
                            }),
                        Utils.getUserRole() == "BOSS"
                            ? ListTile(
                                trailing: SvgPicture.asset("assets/svg/right_arrow.svg", width: 7, colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn)),
                                leading: SvgPicture.asset("assets/svg/sold_item.svg", height: 28, colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn)),
                                title: const Text("Эрх сунгах", style: TextStyle(color: Colors.white60, fontSize: 13.0, fontWeight: FontWeight.bold)),
                                onTap: () {
                                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const AddDivision()));
                                })
                            : const SizedBox.shrink(),
                      ])))
            ]),
            const Expanded(
                child: Column(children: [
              Text("Холбоо барих", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
              Divider(indent: 20, endIndent: 20),
              Row(children: [SizedBox(width: 20), Icon(Icons.phone_outlined, color: Colors.grey), SizedBox(width: 10), InkWell(child: Text("(+976) 7676-7694", style: TextStyle(color: Colors.grey)))]),
              SizedBox(height: 10),
              Row(children: [SizedBox(width: 20), Icon(Icons.mail_outline, color: Colors.grey), SizedBox(width: 10), Text("Dogshin.Domogt@gmail.com", style: TextStyle(color: Colors.grey))]),
            ])),
            Column(children: [
              ListTile(
                  title: Row(children: [
                    SvgPicture.asset("assets/icons/drawer1.svg", width: 24, colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn)),
                    const SizedBox(width: 10),
                    const Text(
                      "Найзаа урих",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimarySecondColor),
                    )
                  ]),
                  onTap: () {
                    _addFriend();
                  }),
              ListTile(
                  title: Row(children: [
                    SvgPicture.asset("assets/icons/drawer3.svg", width: 24, colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn)),
                    const SizedBox(width: 10),
                    const Text(
                      "Урисан найзаа харах",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimarySecondColor),
                    )
                  ]),
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const FriendListScreen()));
                  }),
              Utils.getUserRole() == "BOSS"
                  ? ListTile(
                      title: Row(children: [
                        SvgPicture.asset("assets/icons/drawer2.svg", width: 24, colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn)),
                        const SizedBox(width: 10),
                        const Text(
                          "Дэлгүүрийн дугаар солих",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimarySecondColor),
                        )
                      ]),
                      onTap: () {
                        _changeUser(context);
                      })
                  : const SizedBox.shrink()
            ]),
            ListTile(
                title: Row(children: [
                  SvgPicture.asset("assets/icons/arrow_right.svg", colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn)),
                  const SizedBox(width: 10),
                  const Text(
                    "Гарах",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimarySecondColor),
                  )
                ]),
                onTap: () {
                  _showLogOutWarning(context);
                }),
          ]),
        ));
  }

  _showLogOutWarning(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (ctx) => CustomDialog(onPressedSubmit: () => _logoutFunction(context), title: 'Анхаар', desc: "Та програмаас гарахдаа итгэлтэй байна уу", type: 2),
    );
  }

  void _logoutFunction(BuildContext context) {
    Provider.of<CommonProvider>(context, listen: false).logout();
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const LoginScreen()), (route) => false);
  }

  _changeUser(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return const FractionallySizedBox(heightFactor: 0.6, child: ChangeUserBottom(title: "Дэлгүүрийн дугаар солих"));
        });
  }

  void _addFriend() {
    var alert = AlertDialog(
        content: TextFormField(
            textInputAction: TextInputAction.done,
            controller: _controller,
            maxLength: 8,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                labelText: "Утасны дугаар",
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black38),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(10)),
                prefix: const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("(+976)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))))),
        actions: [
          BlackBookButton(
            height: 40,
            borderRadius: 16,
            onPressed: () {
              if (_controller.text.length == 8) {
                // _changeUser(storeid, _controller.text);
                _addFriendRequest(context);
              } else {
                showWarningDialog("Дугаараа бүрэн оруулна уу!");
              }
            },
            child: const Center(
              child: Text("Урих", style: TextStyle(color: kWhite)),
            ),
          ),
        ]);

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }
}
