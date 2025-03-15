import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_inlist.dart';
import 'package:black_book/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ListBuilder extends StatelessWidget {
  final List<ProductDetialModel> list;
  final ScrollController controller;
  final String userRole;
  final bool isExpanded;
  final bool typeTrailling;
  final String trailingText;
  final IconData icon;
  String? goodId;
  Function? showWarningCallback;
  Function? showDilaog;
  final String screenType;
  final NumberFormat format = NumberFormat("#,###");

  ListBuilder({super.key, required this.screenType, required this.icon, required this.trailingText, required this.typeTrailling, required this.list, required this.controller, required this.userRole, required this.isExpanded, this.goodId, this.showDilaog, this.showWarningCallback});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: list.length,
            controller: controller,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Container(
                    decoration: BoxDecoration(color: kWhite, boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 3, offset: const Offset(2, 2))], borderRadius: BorderRadius.circular(20)),
                    child: ExpansionTile(
                        collapsedBackgroundColor: Colors.transparent,
                        trailing: typeTrailling
                            ? userRole == "BOSS" || userRole == "ADMIN"
                                ? InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    onTap: () {
                                      if (screenType == "sale") {
                                        showWarningCallback?.call(index);
                                      } else if (screenType == "warepurchase") {
                                        showWarningCallback?.call(list[index]);
                                      } else if (screenType == "ware") {
                                        showWarningCallback?.call(list[index].good_id);
                                      }
                                      showDilaog!.call();
                                    },
                                    child: Column(children: [Icon(icon), Text(trailingText, style: const TextStyle(color: Colors.grey, fontSize: 10))]))
                                : const Text("")
                            : const Text(""),
                        shape: const Border(),
                        collapsedIconColor: kPrimaryColor,
                        leading: GestureDetector(
                            onTap: () async {
                              await showDialog(context: context, builder: (_) => imageDialog(list[index].photo, context));
                            },
                            child: SizedBox(
                                width: 100,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                      height: 80.0,
                                      width: 80.0,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                                      child: ClipRRect(borderRadius: BorderRadius.circular(9), child: list[index].photo == null ? Image.asset("assets/images/saleProduct.jpg", fit: BoxFit.cover) : Image.network(list[index].photo!, fit: BoxFit.cover)))
                                ]))),
                        title: Text("Барааны нэр: ${list[index].name}", style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
                        subtitle: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("Барааны код: ${list[index].code}", style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal)),
                          Utils.getUserRole() == "BOSS" ? Text('Авсан үнэ: ${format.format(list[index].sizes!.first.cost ?? 0)}₮', style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal)) : const SizedBox.shrink(),
                          Text('Зарах үнэ: ${format.format(list[index].sizes!.first.price ?? 0)}₮', style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal))
                        ]),
                        initiallyExpanded: isExpanded,
                        children: [
                          const Row(children: [Expanded(child: Divider(indent: 10)), SizedBox(width: 4), Icon(Icons.circle, size: 4, color: kPrimaryColor), SizedBox(width: 4), Expanded(child: Divider(endIndent: 10))]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [Text(getSizesString(list[index].sizes), style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal)), Text(getWareString(list[index].sizes), style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal))])
                        ])),
              );
            }));
  }
}

String getSizesString(List<ProductInDetialModel>? sizes) {
  if (sizes == null || sizes.isEmpty) {
    return 'No sizes available';
  }
  return sizes.map((size) => 'Хэмжээ: ${size.type}').join('\n');
}

String getWareString(List<ProductInDetialModel>? sizes) {
  if (sizes == null || sizes.isEmpty) {
    return 'No sizes available';
  }
  return sizes.map((size) => 'Үлдэгдэл: ${size.stock}ш').join('\n');
}

Widget imageDialog(path, context) {
  return Dialog(
    child: SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      height: MediaQuery.of(context).size.height / 1.5,
      child: Image.network(
        '$path',
        fit: BoxFit.fill,
      ),
    ),
  );
}
