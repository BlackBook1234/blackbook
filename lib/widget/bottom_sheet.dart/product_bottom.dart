import "package:black_book/constant.dart";
import "package:black_book/models/product/total.dart";
import "package:black_book/widget/alert/component/buttons.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class BottomProductSheetsWidget extends StatelessWidget {
  BottomProductSheetsWidget({super.key, required this.data, required this.title});
  final NumberFormat format = NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Column(children: [
            Text(title, style: const TextStyle(color: kPrimarySecondColor, fontSize: 14, fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Борлуулалах үнэ: ${format.format(data.price)}"),
              Text("Авсан нийт үнэ: ${format.format(data.cost)}"),
              Text("Нийт тоо: ${format.format(data.count)}"),
            ]))
          ]))),
          BlackBookButton(
            width: double.infinity,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"),
          ),
        ]));
  }

  final String title;
  final TotalProductModel data;
}
