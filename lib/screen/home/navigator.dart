import 'dart:io';

import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/invitaion/response.dart';
import 'package:black_book/models/notification/detial.dart';
import 'package:black_book/screen/home/search.dart';
import 'package:black_book/screen/home/widget/banners_carousel.dart';
import 'package:black_book/screen/notification/notification.dart';
import 'package:black_book/screen/sale_product/sale_main.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:black_book/widget/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'add_item.dart';
import 'home.dart';
import 'ware_house_user_admin.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key, required int screenIndex});
  final int screenIndex = 0;

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> with BaseStateMixin {
  int screenIndex = 0;
  int notificationCount = 0;
  int page = 1;
  List<NotificationDetail> notficationdata = [];
  InvitationResponse invitationResponse = InvitationResponse(data: []);

  @override
  void initState() {
    refreshPage(context);
    super.initState();
    setState(() {
      screenIndex = widget.screenIndex;
    });
    _checkInvitaion();
  }

  Future<void> refreshPage(BuildContext context) async {
    await _getUpdateStatus();
    await _getNotification();
  }

  void onBottomIconPressed(int index) {
    refreshPage(context);
    setState(() {
      screenIndex = index;
    });
  }

  Future<void> _getNotification() async {
    try {
      var res = await api.getNotification(page);
      setState(() {
        notificationCount = res.unseen!;
      });
    } on APIError catch (e) {
      showErrorDialog(e.message);
    }
  }

  Future<void> _getUpdateStatus() async {
    try {
      var res = await api.getUpdateStatus();
      if (res.data.mustUpdate) {
        if (context.mounted) {
          // ignore: use_build_context_synchronously
          updateDialog(context);
        }
      }
      // ignore: empty_catches
    } on APIError {}
  }

  _showLogOutWarning(BuildContext context) async {
    if (screenIndex != 0) {
      setState(() {
        screenIndex = 0;
      });
    }
  }

  Future<void> _checkInvitaion() async {
    if (Utils.getUserRole() == "BOSS") {
      try {
        var res = await api.checkInvation();
        setState(() {
          invitationResponse = res;
        });
        if (invitationResponse.data!.isNotEmpty) {
          invitaionDialog(invitationResponse);
        }
      } on APIError catch (e) {
        showErrorDialog(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        drawer: const NavBar(),
        appBar: AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Builder(
                  builder: (context) => InkWell(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                            height: 30,
                            width: 50,
                            decoration: const BoxDecoration(color: kWhite, borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), topRight: Radius.circular(15))),
                            child: Center(
                                child: SvgPicture.asset("assets/icons/Camera Icon.svg",
                                    colorFilter: const ColorFilter.mode(
                                      kPrimaryColor,
                                      BlendMode.srcIn,
                                    )))),
                      )),
              const SizedBox(width: 10),
              InkWell(
                  onTap: () {
                    setState(() {
                      onBottomIconPressed(0);
                    });
                  },
                  child: Image.asset('assets/images/logoSecond.png', width: 160)),
              const Expanded(child: SizedBox.shrink()),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      color: kWhite,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const NotficationScreen())).then((e) => refreshPage(context));
                    },
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(right: 10),
                  //   width: 30,
                  //   height: 30,
                  //   decoration: BoxDecoration(
                  //       border: Border.all(width: 1, color: kPrimaryColor),
                  //       color: Colors.transparent,
                  //       borderRadius: BorderRadius.circular(10)),
                  //   child: Center(
                  //     child: InkWell(
                  //       onTap: () {
                  //         Navigator.of(context)
                  //             .push(CupertinoPageRoute(
                  //                 builder: (context) =>
                  //                     const NotficationScreen()))
                  //             .then(
                  //               (value) => refreshPage(),
                  //             );
                  //       },
                  //       child: const Icon(
                  //         Icons.notifications_none,
                  //         color: kPrimaryColor,
                  //         size: 20,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  notificationCount != 0
                      ? Positioned(
                          top: 4,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              '$notificationCount',
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: kBackgroundColor,
        body: WillPopScope(
          onWillPop: () async {
            _showLogOutWarning(context);
            return false;
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInToLinear,
                      switchOutCurve: Curves.easeOutBack,
                      child: screenIndex == 0
                          ? const HomeScreen()
                          : screenIndex == 1
                              ? const WareHouseAdminScreen()
                              : screenIndex == 2
                                  ? const AddIemScreen()
                                  : screenIndex == 3
                                      ? const MainSellProductScreen()
                                      : const SearchScreen(),
                    ),
                  ),
                  SizedBox(height: isPhoneType() + 30),
                ],
              ),
              Positioned(
                bottom: Platform.isIOS ? 20 : 0,
                right: 0,
                child: CustomBottomNavigationBar(
                  onIconPresedCallback: onBottomIconPressed,
                  index: screenIndex,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(height: 20, width: size.width, color: kWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
