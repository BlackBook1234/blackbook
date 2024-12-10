import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/summery_detial/response.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewDialog extends StatefulWidget {
  const NewDialog(
      {super.key,
      required this.typeStore,
      required this.chosenStore,
      required this.userRole});
  final String userRole;
  final String chosenStore;
  final List<String> typeStore;

  @override
  State<NewDialog> createState() => _NewDialogState();
}

class _NewDialogState extends State<NewDialog> with BaseStateMixin {
  SummeryDetial? response;
  bool _runApi = false;
  String chosenStore = "Бүх дэлгүүр";
  final NumberFormat format = NumberFormat("#,###");

  _getSummery() async {
    if (_runApi) return;
    setState(() {
      _runApi = true;
    });
    try {
      SummeryDetial res = await api.getSummery();
      setState(() {
        response = res;
        _runApi = false;
      });
    } on APIError {
      setState(() {
        _runApi = false;
      });
    }
  }

  @override
  void initState() {
    print(widget.typeStore);
    _getSummery();
    setState(() {
      chosenStore = widget.chosenStore;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.asset("assets/images/mainLogo.png",
                            fit: BoxFit.cover)))),
            if (Utils.getUserRole() == "BOSS")
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 80,
                      height: 38,
                      decoration: BoxDecoration(
                          color: kWhite,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 9,
                                offset: const Offset(0, 0))
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: DropdownButton<String>(
                          dropdownColor: kWhite,
                          isExpanded: true,
                          iconEnabledColor: kPrimarySecondColor,
                          value: chosenStore,
                          style: const TextStyle(
                              color: kPrimarySecondColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                          items: widget.typeStore
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                          underline:
                              Container(height: 0, color: Colors.transparent),
                          onChanged: (value) {
                            setState(() {
                              chosenStore = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  BlackBookButton(
                    height: 38,
                    width: 80,
                    borderRadius: 14,
                    onPressed: () {
                      // searchAgian?.call(true);
                    },
                    color: kPrimaryColor,
                    child: const Center(
                      child: Text("Хайх"),
                    ),
                  ),
                ],
              ),
            if (response != null)
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 10),
                child: chosenStore == "Агуулах"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              response!.warehouse_total.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                          ),
                          const Divider(),
                          Text(
                            "Нийт үлдэгдэл: ${format.format(response!.warehouse_total.total_balance)}ш",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          ),
                          Text(
                            "Нийт зарах үнэ: ${format.format(response!.warehouse_total.total_price)}₮",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          ),
                          Text(
                            "Нийт авсан үнэ: ${format.format(response!.warehouse_total.total_cost)}₮",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          ),
                        ],
                      )
                    : chosenStore == "Бүх дэлгүүр"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  response!.all_total.text,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54),
                                ),
                              ),
                              const Divider(),
                              Text(
                                "Нийт үлдэгдэл: ${format.format(response!.all_total.total_balance)}ш",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                "Нийт зарах үнэ: ${format.format(response!.all_total.total_price)}₮",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                "Нийт авсан үнэ: ${format.format(response!.all_total.total_cost)}₮",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 100,
                            child: ListView.builder(
                              itemCount: response!.stores!.length,
                              itemBuilder: (context, index) {
                                if (chosenStore ==
                                    response!.stores![index].name) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          response!.stores![index].name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54),
                                        ),
                                      ),
                                      const Divider(),
                                      Text(
                                        "Нийт үлдэгдэл: ${format.format(response!.stores![index].total_balance)}ш",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        "Нийт зарах үнэ: ${format.format(response!.stores![index].total_price)}₮",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        "Нийт авсан үнэ: ${format.format(response!.stores![index].total_cost)}₮",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
              ),
          ],
        ),
      ),
    );
  }
}
