import 'package:black_book/constant.dart';
import 'package:black_book/screen/second/add_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddTypeScreen extends StatelessWidget {
  const AddTypeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.keyboard_arrow_left, size: 30)),
            foregroundColor: kWhite,
            title: Image.asset('assets/images/logoSecond.png', width: 160)),
        body: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
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
                                            child: Text(
                                                "Барааны ангилал сонгох",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14))))))),
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
                                        "assets/svg/snow.svg",
                                        width: 28,
                                        colorFilter: const ColorFilter.mode(
                                            kPrimaryColor, BlendMode.srcIn)),
                                    title: const Text("Өвөл",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  AddTypeSecondScreen(
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
                                    leading: SvgPicture.asset(
                                        "assets/svg/sun.svg",
                                        width: 30,
                                        colorFilter: const ColorFilter.mode(
                                            kPrimaryColor, BlendMode.srcIn)),
                                    title: const Text("Зун",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  AddTypeSecondScreen(
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
                                    leading: const Icon(Icons.local_florist,
                                        size: 30, color: kPrimaryColor),
                                    title: const Text("Хавар",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  AddTypeSecondScreen(
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
                                            fontWeight: FontWeight.bold)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  AddTypeSecondScreen(
                                                      itemType: "Намар")));
                                    })))
                      ]))))
        ]));
  }
}
