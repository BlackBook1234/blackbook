import "package:black_book/constant.dart";
import "package:black_book/models/sale/total.dart";
import "package:flutter/material.dart";

class BottomSheetsWidget extends StatelessWidget {
  const BottomSheetsWidget(
      {super.key, required this.data, required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Column(children: [
            Text(title,
                style: const TextStyle(
                    color: kPrimarySecondColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text("Борлуулалтын үнэ: ${data.price}"),
                  Text("Цэвэр ашиг: ${data.cost}"),
                  Text(
                      "Банк: ${data.price_money_types!.first.amount}₮\nКарт: ${data.price_money_types![1].amount}₮\nБэлэн: ${data.price_money_types!.last.amount}₮")
                ]))
          ]))),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: kPrimaryColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok", style: TextStyle(color: kWhite))))
        ]));
  }

  final String title;
  final TotalSaleModel data;
}
