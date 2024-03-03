import "package:black_book/constant.dart";
import "package:black_book/global_keys.dart";
import "package:black_book/models/product/product_detial.dart";
import "package:black_book/models/product/product_inlist.dart";
import "package:black_book/provider/product_share_provider.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";

// ignore: must_be_immutable
class ProductBottomSheetsWidget extends StatefulWidget {
  ProductBottomSheetsWidget({
    super.key,
    required this.data,
    required this.title,
  });
  @override
  State<ProductBottomSheetsWidget> createState() => _BottomSheetsWidgetState();
  String title;
  ProductDetialModel data;
}

class _BottomSheetsWidgetState extends State<ProductBottomSheetsWidget> {
  void changeOrderQty(ProductInDetialModel data, int type) {
    if (type == 1 && data.ware_stock < data.warehouse_stock!) {
      setState(() {
        data.ware_stock++;
      });
    } else if (type == 0) {
      if (data.ware_stock > 0) {
        setState(() {
          data.ware_stock--;
        });
      }
    }
  }

  addDataInDraft(List<ProductInDetialModel> data) {
    List<ProductInDetialModel> listData = [];
    for (ProductInDetialModel otpList in data) {
      if (otpList.ware_stock != 0) {
        ProductInDetialModel inData = ProductInDetialModel(
            cost: data.first.cost,
            price: otpList.price,
            stock: otpList.ware_stock,
            id: otpList.id,
            type: otpList.type);
        listData.add(inData);
      }
    }
    ProductDetialModel draftData = ProductDetialModel(
        name: widget.data.name,
        code: widget.data.code,
        category_id: widget.data.category_id,
        created_at: widget.data.created_at,
        parent_category: widget.data.parent_category,
        parent_name: widget.data.parent_name,
        good_id: widget.data.good_id,
        sizes: listData,
        category_name: widget.data.category_name);
    Provider.of<ProductProvider>(GlobalKeys.navigatorKey.currentContext!,
            listen: false)
        .setProductItemsData(draftData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Column(children: [
          Column(children: [
            Text(widget.title,
                style: const TextStyle(
                    color: kPrimarySecondColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(
                leading: Image.asset("assets/images/socks.png", width: 80.0),
                title: Text("Барааны нэр: ${widget.data.name}",
                    style: const TextStyle(
                        fontSize: 12.0, fontWeight: FontWeight.bold)),
                subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Барааны код: ${widget.data.code}",
                          style: const TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal)),
                      Text('Анхны үнэ: ${widget.data.sizes!.first.cost}₮',
                          style: const TextStyle(
                              fontSize: 11.0, fontWeight: FontWeight.normal)),
                      Text('Зарах үнэ: ${widget.data.sizes!.first.price}₮',
                          style: const TextStyle(
                              fontSize: 11.0, fontWeight: FontWeight.normal))
                    ]))
          ]),
          Expanded(
              child: ListView.builder(
                  itemCount: widget.data.sizes!.length,
                  itemBuilder: (context, index) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Үлдэгдэл: ${widget.data.sizes![index].warehouse_stock}ш',
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.normal)),
                                Text(
                                    'Хэмжээ: ${widget.data.sizes![index].type}',
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.normal)),
                              ]),
                          Row(children: [
                            MaterialButton(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topLeft: Radius.circular(10))),
                                height: 20,
                                minWidth: 20.0,
                                color: kPrimaryColor,
                                textColor: Colors.white,
                                child: const Text("-",
                                    style: TextStyle(fontSize: 10)),
                                onPressed: () => {
                                      changeOrderQty(
                                          widget.data.sizes![index], 0)
                                    }),
                            SizedBox(
                                width: 15,
                                height: 50,
                                child: TextField(
                                    style: const TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                    controller: TextEditingController(
                                        text: widget
                                            .data.sizes![index].ware_stock
                                            .toString()),
                                    onChanged: (value) {
                                      changeCount(widget.data.sizes![index],
                                          int.tryParse(value) ?? 0);
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero))),
                            MaterialButton(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                height: 20,
                                minWidth: 20.0,
                                color: kPrimaryColor,
                                textColor: Colors.white,
                                child: const Text("+",
                                    style: TextStyle(fontSize: 10)),
                                onPressed: () => {
                                      changeOrderQty(
                                          widget.data.sizes![index], 1)
                                    })
                          ])
                        ]);
                  })),
          Row(children: [
            Expanded(
                child: ElevatedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: kPrimaryColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        const Text("Буцах", style: TextStyle(color: kWhite)))),
            const SizedBox(width: 10),
            Expanded(
                child: ElevatedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: kPrimaryColor),
                    onPressed: () {
                      addDataInDraft(widget.data.sizes!);
                    },
                    child: const Text("Сагсанд хийх",
                        style: TextStyle(color: kWhite))))
          ])
        ]));
  }

  void changeCount(ProductInDetialModel data, int value) {
    if (data.warehouse_stock! >= value) {
      setState(() {
        data.ware_stock = value;
      });
    } else {
      setState(() {
        data.ware_stock = data.warehouse_stock!;
      });
    }
  }
}
