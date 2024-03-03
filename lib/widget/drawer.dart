import 'package:black_book/constant.dart';
import 'package:black_book/provider/user_provider.dart';
import 'package:black_book/screen/home/ware_house_user_admin.dart';
import 'package:black_book/screen/sale_product/sold.dart';
import 'package:black_book/screen/login/login.dart';
import 'package:black_book/screen/share/share_list.dart';
import 'package:black_book/screen/share/share_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
          height: 80,
          width: double.infinity,
          color: kPrimaryColor,
          child: Align(
              alignment: Alignment.center,
              child: Image.asset('assets/images/logoSecond.png', height: 40))),
      Stack(children: [
        Container(
            color: kPrimaryColor,
            child: Container(height: 100, color: kPrimaryColor)),
        Positioned(
            child: Container(
                height: 230,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: kPrimarySecondColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(children: [
                  ListTile(
                      trailing: SvgPicture.asset("assets/svg/right_arrow.svg",
                          width: 7,
                          colorFilter: const ColorFilter.mode(
                              Colors.white60, BlendMode.srcIn)),
                      leading: SvgPicture.asset("assets/svg/warehouse.svg",
                          width: 28,
                          colorFilter: const ColorFilter.mode(
                              Colors.white60, BlendMode.srcIn)),
                      title: const Text("Агуулахын бараа",
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => const WareHouseAdminScreen()));
                      }),
                  ListTile(
                      trailing: SvgPicture.asset("assets/svg/right_arrow.svg",
                          width: 7,
                          colorFilter: const ColorFilter.mode(
                              Colors.white60, BlendMode.srcIn)),
                      leading: SvgPicture.asset("assets/svg/add_store.svg",
                          width: 28,
                          colorFilter: const ColorFilter.mode(
                              Colors.white60, BlendMode.srcIn)),
                      title: const Text("Бараа шилжүүлгийн түүх",
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) =>
                                const ShareListHistoryScreen()));
                      }),
                  ListTile(
                      trailing: SvgPicture.asset("assets/svg/right_arrow.svg",
                          width: 7,
                          colorFilter: const ColorFilter.mode(
                              Colors.white60, BlendMode.srcIn)),
                      leading: SvgPicture.asset("assets/svg/share.svg",
                          width: 28,
                          colorFilter: const ColorFilter.mode(
                              Colors.white60, BlendMode.srcIn)),
                      title: const Text("Бараа шилжүүлэг",
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => const ShareProductScreen()));
                      }),
                  ListTile(
                      trailing: SvgPicture.asset("assets/svg/right_arrow.svg",
                          width: 7,
                          colorFilter: const ColorFilter.mode(
                              Colors.white60, BlendMode.srcIn)),
                      leading: SvgPicture.asset("assets/svg/sold_item.svg",
                          height: 28,
                          colorFilter: const ColorFilter.mode(
                              Colors.white60, BlendMode.srcIn)),
                      title: const Text("Зарсан бараанууд",
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => const SoldItemMainScreen()));
                      })
                ])))
      ]),
      const SizedBox(height: 30),
      const Expanded(
          child: Column(children: [
        Text("Холбоо барих",
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
        Divider(indent: 20, endIndent: 20),
        Row(children: [
          SizedBox(width: 20),
          Icon(Icons.phone_outlined, color: Colors.grey),
          SizedBox(width: 10),
          Text("(+976) 98111149", style: TextStyle(color: Colors.grey))
        ]),
        SizedBox(height: 10),
        Row(children: [
          SizedBox(width: 20),
          Icon(Icons.mail_outline, color: Colors.grey),
          SizedBox(width: 10),
          Text("KharDevter@gmail.com", style: TextStyle(color: Colors.grey))
        ])
      ])),
      ListTile(
          title: Row(children: [
            SvgPicture.asset("assets/icons/arrow_right.svg",
                colorFilter:
                    const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn)),
            const SizedBox(width: 10),
            const Text(
              "Гарах",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kPrimarySecondColor),
            )
          ]),
          onTap: () {
            _showLogOutWarning(context);
          })
    ]));
  }

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
}
