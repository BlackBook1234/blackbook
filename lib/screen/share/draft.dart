import 'package:black_book/constant.dart';
import 'package:black_book/models/product/product_inlist.dart';
import 'package:black_book/provider/product_share_provider.dart';
import 'package:black_book/widget/bottom_sheet.dart/choose_store_share.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDraft extends StatelessWidget {
  const ProductDraft({
    super.key,
  });
  final bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Scaffold(
          appBar: AppBar(
              leadingWidth: 30,
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30)),
              foregroundColor: kWhite,
              title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, color: kPrimaryColor),
                    SizedBox(width: 5),
                    Text("Сагс",
                        style: TextStyle(
                            color: kWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))
                  ]),
              backgroundColor: kPrimarySecondColor),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                        itemCount: provider.lstDraft.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
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
                                  child: ExpansionTile(
                                      trailing: InkWell(
                                          onTap: () {
                                            provider.removeOrderItem(
                                                provider.lstDraft[index]);
                                          },
                                          child: const Icon(
                                              Icons.delete_outline_rounded,
                                              size: 30,
                                              color: kPrimaryColor)),
                                      shape: const Border(),
                                      collapsedIconColor: kPrimaryColor,
                                      leading: provider.lstDraft[index].photo == null
                                          ? Container(
                                              height: 80.0,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(9),
                                                  child: Image.asset(
                                                      "assets/images/saleProduct.jpg",
                                                      fit: BoxFit.cover)))
                                          : Container(
                                              height: 80.0,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20.0)),
                                              child: ClipRRect(borderRadius: BorderRadius.circular(9), child: Image.network(provider.lstDraft[index].photo!, fit: BoxFit.cover))),
                                      title: Text("Барааны нэр: ${provider.lstDraft[index].name}", style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
                                      subtitle: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text(
                                            "Барааны код: ${provider.lstDraft[index].code}",
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.normal)),
                                        Text(
                                            'Анхны үнэ: ${provider.lstDraft[index].sizes!.first.cost}₮',
                                            style: const TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.normal)),
                                        Text(
                                            'Зарах үнэ: ${provider.lstDraft[index].sizes!.first.price}₮',
                                            style: const TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.normal))
                                      ]),
                                      initiallyExpanded: _isExpanded,
                                      children: [
                                        const Row(children: [
                                          Expanded(child: Divider(indent: 10)),
                                          SizedBox(width: 4),
                                          Icon(Icons.circle,
                                              size: 4, color: kPrimaryColor),
                                          SizedBox(width: 4),
                                          Expanded(
                                              child: Divider(endIndent: 10))
                                        ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                  getSizesString(provider
                                                      .lstDraft[index].sizes),
                                                  style: const TextStyle(
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              Text(
                                                  getWareString(provider
                                                      .lstDraft[index].sizes),
                                                  style: const TextStyle(
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ])
                                      ])));
                        })),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              kPrimaryColor,
                              Colors.orange.shade300,
                              kPrimaryColor
                            ]),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: kWhite),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return FractionallySizedBox(
                                        heightFactor: 0.7,
                                        child: ChooseStoreBottomSheetsWidget(
                                            data: provider.lstDraft,
                                            title: "Дэлгүүр сонгох"));
                                  });
                            },
                            child: const Text("Дэлгүүр сонгох",
                                style: TextStyle(fontSize: 14)))))
              ]));
    });
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
