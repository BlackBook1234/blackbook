import "package:black_book/constant.dart";
import "package:black_book/models/product/product_detial.dart";
import "package:black_book/models/product/product_inlist.dart";
import "package:black_book/util/utils.dart";
import "package:black_book/widget/alert/component/buttons.dart";
import "package:black_book/widget/alert/mixin_dialog.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class ProductAddSzieBottom extends StatefulWidget {
  const ProductAddSzieBottom({
    super.key,
    required this.data,
    required this.title,
  });
  @override
  State<ProductAddSzieBottom> createState() => _BottomSheetsWidgetState();
  final String title;
  final ProductDetialModel data;
}

class _BottomSheetsWidgetState extends State<ProductAddSzieBottom>
    with BaseStateMixin {
  void changeOrderQty(ProductInDetialModel data, int type) {
    if (type == 1 && data.ware_stock < data.stock!) {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Column(
        children: [
          Column(children: [
            Text(widget.title,
                style: const TextStyle(
                    color: kPrimarySecondColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(
                leading: Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: widget.data.photo == null
                            ? Image.asset("assets/images/saleProduct.jpg",
                                fit: BoxFit.cover)
                            : Image.network(widget.data.photo!))),
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
                      Utils.getUserRole() == "BOSS"
                          ? Text('Авсан үнэ: ${widget.data.sizes!.first.cost}₮',
                              style: const TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal))
                          : const SizedBox.shrink(),
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
                                    'Үлдэгдэл: ${widget.data.sizes![index].stock}ш',
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
                                        fillColor: kBackgroundColor,
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
          Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: BlackBookButton(
              width: double.infinity,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Буцах"),
            ),
          ),
        ],
      ),
    );
  }

  void changeCount(ProductInDetialModel data, int value) {
    if (data.stock! >= value) {
      setState(() {
        data.ware_stock = value;
      });
    } else {
      setState(() {
        data.ware_stock = data.stock!;
      });
    }
  }
}
