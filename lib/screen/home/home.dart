import 'package:black_book/bloc/banner/bloc.dart';
import 'package:black_book/bloc/banner/event.dart';
import 'package:black_book/bloc/banner/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/banner/detial.dart';
import 'package:black_book/screen/core/add_division.dart';
import 'package:black_book/screen/core/add_type.dart';
import 'package:black_book/screen/sale_product/sold.dart';
import 'package:black_book/screen/core/ware_division.dart';
import 'package:black_book/screen/share/share_product.dart';
import 'package:black_book/screen/store/store.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/banner.dart';
import 'package:black_book/widget/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bloc = BannerBloc();
  List<BannerDetial> url = [];
  String userRole = "BOSS";

  @override
  void initState() {
    _bloc.add(const GetBannerEvent());
    super.initState();
    userRole = Utils.getUserRole();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<BannerBloc, BannerState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is BannerLoading) {
                  // Utils.startLoader(context);
                }
                if (state is BannerFailure) {
                  if (state.message == "Token") {
                    _bloc.add(const GetBannerEvent());
                  } else {
                    // Utils.cancelLoader(context);
                    ErrorMessage.attentionMessage(context, state.message);
                  }
                }
                if (state is BannerSuccess) {
                  // Utils.cancelLoader(context);
                  setState(() {
                    url = state.data;
                  });
                }
              })
        ],
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  HeadphoneBanner(urls: url),
                  userRole == "BOSS"
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 4),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: kWhite,
                                  border: Border.all(
                                      width: 1, color: kPrimaryColor),
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
                                  leading: SvgPicture.asset(
                                      "assets/svg/add_store.svg",
                                      width: 28,
                                      colorFilter: const ColorFilter.mode(
                                          kPrimaryColor, BlendMode.srcIn)),
                                  title: const Text("Салбар дэлгүүр нээх",
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold)),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                AddDivision()));
                                  })))
                      : const SizedBox(height: 0),
                  // Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 4),
                  //     child: Container(
                  //         decoration: BoxDecoration(
                  //             color: kWhite,
                  //             boxShadow: [
                  //               BoxShadow(
                  //                   color: Colors.grey.shade300,
                  //                   blurRadius: 3,
                  //                   offset: const Offset(2, 2))
                  //             ],
                  //             borderRadius: BorderRadius.circular(20)),
                  //         child: ListTile(
                  //             trailing: SvgPicture.asset(
                  //                 "assets/svg/right_arrow.svg",
                  //                 width: 7,
                  //                 colorFilter: const ColorFilter.mode(
                  //                     kPrimaryColor, BlendMode.srcIn)),
                  //             leading: SvgPicture.asset(
                  //                 "assets/svg/warehouse.svg",
                  //                 width: 28,
                  //                 colorFilter: const ColorFilter.mode(
                  //                     kPrimaryColor, BlendMode.srcIn)),
                  //             title: const Text("Агуулахын бараа",
                  //                 style: TextStyle(
                  //                     fontSize: 13.0,
                  //                     fontWeight: FontWeight.bold)),
                  //             onTap: () {
                  //               Navigator.of(context).push(
                  //                   CupertinoPageRoute(
                  //                       builder: (context) =>
                  //                           const WareHouseScreen()));
                  //             }))),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          decoration: BoxDecoration(
                              color: kWhite,
                              border:
                                  Border.all(width: 1, color: kPrimaryColor),
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
                              leading: SvgPicture.asset(
                                  "assets/icons/store.svg",
                                  width: 28,
                                  colorFilter: const ColorFilter.mode(
                                      kPrimaryColor, BlendMode.srcIn)),
                              title: const Text("Дэлгүүрийн бараа",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold)),
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) =>
                                        const WareDivisionScreen()));
                              }))),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          decoration: BoxDecoration(
                              color: kWhite,
                              border:
                                  Border.all(width: 1, color: kPrimaryColor),
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
                              leading: SvgPicture.asset("assets/svg/share.svg",
                                  width: 28,
                                  colorFilter: const ColorFilter.mode(
                                      kPrimaryColor, BlendMode.srcIn)),
                              title: const Text("Бараа шилжүүлэг",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold)),
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) =>
                                        const ShareProductScreen()));
                              }))),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          decoration: BoxDecoration(
                              color: kWhite,
                              border:
                                  Border.all(width: 1, color: kPrimaryColor),
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
                              leading: SvgPicture.asset(
                                  "assets/svg/sold_item.svg",
                                  height: 28,
                                  colorFilter: const ColorFilter.mode(
                                      kPrimaryColor, BlendMode.srcIn)),
                              title: const Text("Зарсан бараанууд",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold)),
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) =>
                                        const SoldItemMainScreen()));
                              }))),
                  userRole == "BOSS"
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: kWhite,
                                  border: Border.all(
                                      width: 1, color: kPrimaryColor),
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
                                  leading: SvgPicture.asset(
                                      "assets/svg/my_store.svg",
                                      width: 28,
                                      colorFilter: const ColorFilter.mode(
                                          kPrimaryColor, BlendMode.srcIn)),
                                  title: const Text("Миний дэлгүүрүүд",
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold)),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                const DivisionScreen()));
                                  })))
                      : const SizedBox(height: 0),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          decoration: BoxDecoration(
                              color: kWhite,
                              border:
                                  Border.all(width: 1, color: kPrimaryColor),
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
                              leading: SvgPicture.asset(
                                  "assets/svg/add_type.svg",
                                  width: 28,
                                  colorFilter: const ColorFilter.mode(
                                      kPrimaryColor, BlendMode.srcIn)),
                              title: const Text("Барааны ангилал нэмэх",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold)),
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) =>
                                        const AddTypeScreen()));
                              })))
                ]))));
  }
}
