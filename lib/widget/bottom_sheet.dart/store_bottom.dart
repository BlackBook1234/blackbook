import "package:black_book/constant.dart";
import "package:black_book/models/product/store_amount.dart";
import "package:black_book/widget/alert/component/buttons.dart";
import "package:flutter/material.dart";

class BottomSheetStore extends StatelessWidget {
  const BottomSheetStore({super.key, required this.data, required this.title});
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
            ListTile(subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Борлуулалтын үнэ: ${data.total_price}"), Text("Цэвэр ашиг: ${data.total_cost}")]))
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
  final StoreAmountModel data;
}
