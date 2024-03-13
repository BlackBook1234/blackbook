import "package:black_book/bloc/share/bloc.dart";
import "package:black_book/bloc/share/event.dart";
import "package:black_book/bloc/share/state.dart";
import "package:black_book/bloc/store/bloc.dart";
import "package:black_book/bloc/store/event.dart";
import "package:black_book/bloc/store/state.dart";
import "package:black_book/constant.dart";
import "package:black_book/models/otp/product_share.dart";
import "package:black_book/models/product/product_detial.dart";
import "package:black_book/models/product/product_inlist.dart";
import "package:black_book/models/store/store_detial.dart";
import "package:black_book/provider/product_share_provider.dart";
import "package:black_book/util/utils.dart";
import "package:black_book/widget/alert/show_dilaog.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:provider/provider.dart";

class ChooseStoreBottomSheetsWidget extends StatefulWidget {
  const ChooseStoreBottomSheetsWidget(
      {super.key, required this.title, required this.data});
  @override
  State<ChooseStoreBottomSheetsWidget> createState() =>
      _ChooseStoreBottomSheetsWidgetState();
  final String title;
  final List<ProductDetialModel> data;
}

class _ChooseStoreBottomSheetsWidgetState
    extends State<ChooseStoreBottomSheetsWidget> {
  List<StoreDetialModel> lst = [];
  final _bloc = StoreBloc();
  final _shareBloc = ShareBloc();
  int? storeId;
  List<ProductInDetialModel> otpData = [];
  List<ProductShareOtp> sendData = [];
  StoreDetialModel defaultStoreModel = StoreDetialModel(
      name: "Агуулах",
      phone_number: "",
      created_at: DateTime.now().toString(),
      is_main: 1,
      id: 0);

  @override
  void initState() {
    _bloc.add(const GetStoreEvent());
    for (ProductDetialModel data in widget.data) {
      otpData.addAll(data.sizes!);
      for (ProductInDetialModel size in data.sizes!) {
        sendData.add(ProductShareOtp(
            cost: size.cost,
            price: size.price,
            stock: size.stock,
            id: size.id));
      }
    }

    super.initState();
  }

  void _shareProduct() {
    for (StoreDetialModel data in lst) {
      if (data.isChecked) {
        setState(() {
          storeId = data.id!;
        });
      }
    }
    if (storeId == null) {
      AlertMessage.statusMessage(context, "Анхаар!", "Дэлгүүр сонгон уу", true);
    } else {
      _shareBloc.add(CreateShareEvent(storeId!, sendData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return MultiBlocListener(
          listeners: [
            BlocListener<StoreBloc, StoreState>(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is GetStoreLoading) {
                    Utils.startLoader(context);
                  }
                  if (state is GetStoreFailure) {
                    if (state.message == "Token") {
                      _bloc.add(const GetStoreEvent());
                    } else {
                      Utils.cancelLoader(context);
                      AlertMessage.statusMessage(
                          context, "Анхаар!", state.message, true);
                    }
                  }
                  if (state is GetStoreSuccess) {
                    Utils.cancelLoader(context);
                    setState(() {
                      lst = state.list;
                      if (Utils.getUserRole() != "BOSS") {
                        lst.add(defaultStoreModel);
                      }
                    });
                  }
                }),
            BlocListener<ShareBloc, ShareState>(
                bloc: _shareBloc,
                listener: (context, state) {
                  if (state is ShareLoading) {
                    Utils.startLoader(context);
                  }
                  if (state is ShareFailure) {
                    if (state.message == "Token") {
                      _shareBloc.add(CreateShareEvent(storeId!, sendData));
                    } else {
                      Utils.cancelLoader(context);
                      AlertMessage.statusMessage(
                          context, "Анхаар!", state.message, true);
                    }
                  }
                  if (state is ShareSuccess) {
                    Utils.cancelLoader(context);
                    AlertMessage.statusMessage(
                        context, "Амжилттай", "Бараа шилжлээ", false);
                    provider.removeAllItem();
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  }
                })
          ],
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(children: [
                Text(widget.title,
                    style: const TextStyle(
                        color: kPrimarySecondColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                const Divider(),
                Expanded(
                    child: ListView.builder(
                        itemCount: lst.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: lst[index].isChecked
                                          ? Colors.grey.shade600
                                          : kWhite,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade300,
                                            blurRadius: 3,
                                            offset: const Offset(2, 2))
                                      ],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ListTile(
                                      leading: SvgPicture.asset(
                                          "assets/icons/store.svg",
                                          width: 40,
                                          colorFilter: ColorFilter.mode(
                                              lst[index].isChecked
                                                  ? kWhite
                                                  : kPrimaryColor,
                                              BlendMode.srcIn)),
                                      title: Text(lst[index].name!,
                                          style: lst[index].isChecked
                                              ? const TextStyle(
                                                  color: kWhite,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold)
                                              : const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold)),
                                      onTap: () {
                                        setState(() {
                                          for (StoreDetialModel data in lst) {
                                            if (data.isChecked == true) {
                                              data.isChecked = false;
                                            }
                                          }
                                          lst[index].isChecked = true;
                                        });
                                      })));
                        })),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: kPrimaryColor),
                        onPressed: () {
                          _shareProduct();
                        },
                        child: const Text("Шилжүүлэх",
                            style: TextStyle(color: kWhite))))
              ])));
    });
  }
}
