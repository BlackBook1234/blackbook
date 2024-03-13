import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/provider/user_provider.dart';
import 'package:black_book/screen/home/navigator_controller.dart';
import 'package:black_book/screen/login/login.dart';
import 'package:black_book/screen/sale_product/sale_main.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'add_item.dart';
import 'home.dart';
import 'search.dart';
import 'ware_house_user_admin.dart';

const Color inActiveIconColor = Colors.grey;

// ignore: must_be_immutable
class NavigatorScreen extends StatelessWidget {
  NavigatorScreen({super.key});
  NavigatorController ctrl = Get.put(NavigatorController());
  // List<Widget> pages = Get.find<NavigatorController>().userRole == "BOSS"
  //     ? [
  //         const HomeScreen(),
  //         const WareHouseAdminScreen(),
  //         const AddIemScreen(),
  //         const MainSellProductScreen(),
  //         const SearchScreen()
  //       ]
  //     : [
  //         const HomeScreen(),
  //         const WareHouseAdminScreen(),
  //         const MainSellProductScreen(),
  //         const SearchScreen()
  //       ];

  _showLogOutWarning(BuildContext context) async {
    Widget continueButton = TextButton(
        child: const Text("Тийм", style: TextStyle(color: kBlack)),
        onPressed: () {
          Provider.of<CommonProvider>(context, listen: false).logout();
          Navigator.of(context).pop();
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
        });
    Widget cancelButton = TextButton(
        child: const Text("Үгүй", style: TextStyle(color: kBlack)),
        onPressed: () {
          Navigator.of(context).pop();
        });
    AlertDialog alert = AlertDialog(
        title: const Column(children: [
          Center(
              child: Text("Анхаар!",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor))),
          Divider()
        ]),
        content: const Text("Та програмаас гарахдаа итгэлтэй байна уу",
            textAlign: TextAlign.center),
        actions: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [cancelButton, continueButton])
        ]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    List<TabItem> items = Utils.getUserRole() == "BOSS"
        ? const [
            TabItem(icon: Icons.home_outlined, title: 'Нүүр'),
            TabItem(icon: Icons.favorite_border_outlined, title: 'Миний бараа'),
            TabItem(icon: Icons.add_outlined, title: 'Бараа нэмэх'),
            TabItem(icon: Icons.shopping_cart_outlined, title: 'Борлуулах'),
            TabItem(icon: Icons.search_outlined, title: 'Хайх')
          ]
        : const [
            TabItem(icon: Icons.home_outlined, title: 'Нүүр'),
            TabItem(icon: Icons.favorite_border_outlined, title: 'Миний бараа'),
            TabItem(icon: Icons.shopping_cart_outlined, title: 'Борлуулах'),
            TabItem(icon: Icons.search_outlined, title: 'Хайх')
          ];
    List<Widget> pages = Utils.getUserRole() == "BOSS"
        ? [
            const HomeScreen(),
            const WareHouseAdminScreen(),
            const AddIemScreen(),
            const MainSellProductScreen(),
            const SearchScreen()
          ]
        : [
            const HomeScreen(),
            const WareHouseAdminScreen(),
            const MainSellProductScreen(),
            const SearchScreen()
          ];
    return Obx(() => Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        drawer: const NavBar(),
        appBar: AppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Builder(
                  builder: (context) => InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Container(
                          height: 30,
                          width: 60,
                          decoration: const BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.arrow_back_ios,
                                    color: kPrimaryColor, size: 20),
                                SvgPicture.asset("assets/icons/Camera Icon.svg",
                                    colorFilter: const ColorFilter.mode(
                                        kPrimaryColor, BlendMode.srcIn))
                              ])))),
              const SizedBox(width: 10),
              Image.asset('assets/images/logoSecond.png', width: 160)
            ])),
        backgroundColor: kWhite,
        body: WillPopScope(
            onWillPop: () => _showLogOutWarning(context),
            child: pages[ctrl.currentIndex.value]),
        bottomNavigationBar: BottomBarInspiredInside(
            titleStyle: const TextStyle(fontSize: 10),
            items: items,
            backgroundColor: kWhite,
            color: inActiveIconColor,
            colorSelected: kWhite,
            indexSelected: ctrl.currentIndex.value,
            onTap: (int index) => ctrl.updatePage(index),
            padbottom: 5,
            chipStyle:
                const ChipStyle(convexBridge: true, background: kPrimaryColor),
            itemStyle: ItemStyle.circle)));
  }
}
