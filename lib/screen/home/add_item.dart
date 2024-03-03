import 'package:black_book/constant.dart';
import 'package:black_book/screen/product/category_choose.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddIemScreen extends StatelessWidget {
  const AddIemScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: SingleChildScrollView(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
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
                                leading: SvgPicture.asset("assets/svg/snow.svg",
                                    width: 28,
                                    colorFilter: const ColorFilter.mode(
                                        kPrimaryColor, BlendMode.srcIn)),
                                title: const Text("Өвөл",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600)),
                                onTap: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) =>
                                          ChooseCategoryScreen(
                                              itemType: "Өвөл")));
                                }))),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
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
                                leading: SvgPicture.asset("assets/svg/sun.svg",
                                    width: 30,
                                    colorFilter: const ColorFilter.mode(
                                        kPrimaryColor, BlendMode.srcIn)),
                                title: const Text("Зун",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600)),
                                onTap: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) =>
                                          ChooseCategoryScreen(
                                              itemType: "Зун")));
                                }))),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
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
                                leading: SvgPicture.asset(
                                    "assets/svg/flower.svg",
                                    width: 30,
                                    colorFilter: const ColorFilter.mode(
                                        kPrimaryColor, BlendMode.srcIn)),
                                title: const Text("Хавар",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600)),
                                onTap: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) =>
                                          ChooseCategoryScreen(
                                              itemType: "Хавар")));
                                }))),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
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
                                leading: const Icon(
                                    CupertinoIcons.leaf_arrow_circlepath,
                                    size: 30,
                                    color: kPrimaryColor),
                                title: const Text("Намар",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600)),
                                onTap: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) =>
                                          ChooseCategoryScreen(
                                              itemType: "Намар")));
                                })))
                  ]))))
    ])
        // Expanded(
        //     child: ListView.builder(
        //         itemCount: 5,
        //         itemBuilder: ((context, index) {
        //           return Padding(
        //               padding:
        //                   const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        //               child: Container(
        //                   decoration: BoxDecoration(
        //                       color: kWhite,
        //                       boxShadow: [
        //                         BoxShadow(
        //                             color: Colors.grey.shade300,
        //                             blurRadius: 3,
        //                             offset: const Offset(2, 2))
        //                       ],
        //                       borderRadius: BorderRadius.circular(10)),
        //                   child: ListTile(
        //                       trailing: const Icon(
        //                         Icons.arrow_right,
        //                         size: 30,
        //                       ),
        //                       leading: Image.asset("assets/images/clothes.png",
        //                           width: 50.0),
        //                       title: const Text("Барааны төрөл: Гутал",
        //                           style: TextStyle(
        //                               fontSize: 14.0,
        //                               fontWeight: FontWeight.w600)),
        //                       onTap: () {
        //                         Navigator.of(context).push(CupertinoPageRoute(
        //                             builder: (context) =>
        //                                 const ChooseCategoryScreen()));
        //                       })));
        //         })))

        ;
  }
}
