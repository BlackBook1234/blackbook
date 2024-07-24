import 'package:black_book/constant.dart';
import 'package:black_book/models/transfer/detial.dart';
import 'package:black_book/models/transfer/product.dart';
import 'package:black_book/models/transfer/product_detial.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransferItemDetial extends StatelessWidget {
  const TransferItemDetial({super.key, required this.lst});
  final TransferItem lst;
  final bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final NumberFormat format = NumberFormat("#,###");
    List<TransferProduct>? products = lst.products;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),
          foregroundColor: kWhite,
          title: Image.asset('assets/images/logoSecond.png', width: 160),
          backgroundColor: kPrimarySecondColor),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Container(
              decoration: BoxDecoration(
                color: kWhite,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 3,
                      offset: const Offset(2, 2))
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: Column(
                  children: [
                    Text(
                      "Дэлгүүр: ${lst.total_cost}",
                      style: const TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Төлөв: ${lst.status_text}",
                      style: const TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: kWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 3,
                            offset: const Offset(2, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: ExpansionTile(
                      leading: GestureDetector(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => imageDialog(
                                    products[index].photo, context));
                          },
                          child: Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: products[index].photo == null
                                      ? Image.asset(
                                          "assets/images/saleProduct.jpg",
                                          fit: BoxFit.cover)
                                      : Image.network(products[index].photo!,
                                          fit: BoxFit.cover)))),
                      initiallyExpanded: isExpanded,
                      shape: const Border(),
                      collapsedIconColor: kPrimaryColor,
                      trailing: const SizedBox.shrink(),
                      title: Text("Барааны нэр: ${products[index].name}",
                          style: const TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold)),
                      subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Барааны код: ${products[index].code}",
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal)),
                            Text(
                                'Тоо: ${format.format(products[index].count ?? 0)}ш',
                                style: const TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.normal)),
                          ]),
                      children: [
                        const Row(children: [
                          Expanded(
                            child: Divider(indent: 10),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.circle, size: 4, color: kPrimaryColor),
                          SizedBox(width: 4),
                          Expanded(
                            child: Divider(endIndent: 10),
                          )
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              getSzie(products[index].sizes),
                              style: const TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              getSizesString(products[index].sizes),
                              style: const TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              getWareString(products[index].sizes),
                              style: const TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
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

String getSizesString(List<TransferProductSize>? sizes) {
  if (sizes == null || sizes.isEmpty) {
    return 'No sizes available';
  }
  return sizes.map((size) => 'Тоо: ${size.stock}ш').join('\n');
}

String getSzie(List<TransferProductSize>? sizes) {
  if (sizes == null || sizes.isEmpty) {
    return 'No sizes available';
  }
  return sizes.map((size) => 'Хэмжээ: ${size.type}').join('\n');
}

String getWareString(List<TransferProductSize>? sizes) {
  final NumberFormat format = NumberFormat("#,###");
  if (sizes == null || sizes.isEmpty) {
    return 'No sizes available';
  }
  return sizes
      .map((size) => 'Үнэ: ${format.format(size.price ?? 0)}₮')
      .join('\n');
}
