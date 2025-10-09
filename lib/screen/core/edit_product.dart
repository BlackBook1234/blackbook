import "package:black_book/api/component/api_error.dart";
import "package:black_book/constant.dart";
import "package:black_book/models/product/product_detial.dart";
import "package:black_book/models/product/product_inlist.dart";
import "package:black_book/util/model/edit_product_model.dart";
import "package:black_book/util/utils.dart";
import "package:black_book/widget/alert/component/buttons.dart";
import "package:black_book/widget/alert/mixin_dialog.dart";
import "package:black_book/widget/dynamic_item.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    super.key,
    required this.data,
  });
  @override
  State<EditProductScreen> createState() => _BottomSheetsWidgetState();
  final ProductDetialModel data;
}

class _BottomSheetsWidgetState extends State<EditProductScreen> with BaseStateMixin {
  EditProductModel editData = EditProductModel(name: '', code: '', categoryId: 0, photoUrl: '', sizes: []);
  final TextEditingController productName = TextEditingController();
  final TextEditingController productCode = TextEditingController();
  final TextEditingController costPrice = TextEditingController();
  final TextEditingController price = TextEditingController();
  List<DynamicItemWidget> dynamicList = [];

  @override
  void initState() {
    setState(() {
      productCode.text = widget.data.code ?? "";
      productName.text = widget.data.name ?? "";
      costPrice.text = widget.data.sizes!.first.cost.toString();
      price.text = widget.data.sizes!.first.price.toString();
    });
    super.initState();
  }

  addDataInDraft(ProductDetialModel data) {
    if ((productName.text.isEmpty || productCode.text.isEmpty || costPrice.text.isEmpty || price.text.isEmpty)) {
      showWarningDialog("Утга бүрэн оруулна уу!");
      return;
    }
    for (ProductInDetialModel otpList in data.sizes!) {
      if (otpList.type!.isEmpty) {
        showWarningDialog("Утга бүрэн оруулна уу!");
        return;
      }
    }
    setState(() {
      List<SizeModel> sizeData = [];
      for (ProductInDetialModel otpList in data.sizes!) {
        SizeModel inData = SizeModel(
          type: otpList.type ?? "",
          cost: costPrice.text.isEmpty ? 0 : int.parse(costPrice.text),
          price: price.text.isEmpty ? 0 : int.parse(price.text),
          stock: otpList.stock ?? 0,
          id: otpList.id ?? 0,
        );
        sizeData.add(inData);
      }
      EditProductModel inData = EditProductModel(
        name: productName.text,
        code: productCode.text,
        categoryId: data.category_id ?? 0,
        photoUrl: data.photo ?? "",
        sizes: sizeData,
      );
      editData = inData;
    });
    _editProduct(editData);
  }

  Future<void> _editProduct(EditProductModel data) async {
    try {
      Utils.startLoader(context);
      await api.editProduct(data);
      showSuccessDialog("Мэдээлэл", false, "Амжилттай засагдлаа");
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } on APIError catch (e) {
      Utils.cancelLoader(context);
      showErrorDialog(e.message);
    }
  }

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
          title: const Text("Бараа засах", style: TextStyle(color: kWhite, fontSize: 16, fontWeight: FontWeight.w500)),
          backgroundColor: kPrimarySecondColor),
      // resizeToAvoidBottomInset: false,
      body: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          // scrollDirection: Axis.vertical,
          // clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              children: [
                ListTile(
                    leading: Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: widget.data.photo == null ? Image.asset("assets/images/saleProduct.jpg", fit: BoxFit.cover) : Image.network(widget.data.photo!))),
                    title: Text("Барааны нэр: ${widget.data.name}", style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
                    subtitle: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Барааны код: ${widget.data.code}", style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal)),
                      Utils.getUserRole() == "BOSS"
                          ? Text('Авсан үнэ: ${widget.data.sizes!.first.cost}₮', style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal))
                          : const SizedBox.shrink(),
                      Text('Зарах үнэ: ${widget.data.sizes!.first.price}₮', style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal))
                    ])),
                _buildTextField(productName, "Барааны нэр"),
                _buildTextField(productCode, "Барааны код"),
                _buildNumberField(costPrice, "Авсан үнэ"),
                _buildNumberField(price, "Зарах үнэ"),
                const Divider(),
                const SizedBox(height: 10),
                KeyboardDismissOnTap(
                  child: Column(
                    children: [
                      ...widget.data.sizes!.map((size) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(text: size.type)
                                    ..selection = TextSelection.fromPosition(
                                      TextPosition(offset: size.type!.length),
                                    ),
                                  onChanged: (value) => {
                                    setState(() {
                                      size.type = value;
                                    })
                                  },
                                  // controller: controller,
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    labelText: "Размер нэр",
                                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black38),
                                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(text: size.stock.toString())
                                    ..selection = TextSelection.fromPosition(
                                      TextPosition(offset: size.stock.toString().length),
                                    ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  onChanged: (value) => {
                                    setState(() {
                                      size.stock = int.tryParse(value) ?? 0;
                                    })
                                  },
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    labelText: "Тоо ширхэг",
                                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black38),
                                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 400),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BlackBookButton(
          width: double.infinity,
          height: 42,
          onPressed: () {
            addDataInDraft(widget.data);
          },
          child: const Text("Хадгалах"),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.done,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black38),
            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black38),
            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
