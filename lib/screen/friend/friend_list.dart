import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/friend/detial.dart';
import 'package:black_book/models/friend/list.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({super.key});

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen>
    with BaseStateMixin {
  List<PhoneNumberList> list = [];
  PhoneNumber response = PhoneNumber();
  final List<String> statusNames = [
    "Сонгох",
    "Баталгаажсан",
    "Цуцалсан",
    "Хүлээгдэж байна"
  ];
  int _page = 1;
  bool _loadingOrder = false;
  final ScrollController _controller = ScrollController();
  String chosenValue = "Сонгох";
  final NumberFormat format = NumberFormat("#,###");

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    _getFriendList();
    // });
    _controller.addListener(_scrollListener);
    // _getFriendList();
    super.initState();
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      _getFriendList();
    }
  }

  void _changeType(String value) {
    setState(() {
      _page = 1;
      list.clear();
      chosenValue = value;
    });
    _getFriendList();
  }

  void _getFriendList() async {
    if (_loadingOrder) return;
    setState(() {
      _loadingOrder = true;
    });
    try {
      response = await api.getFriendList(_page, chosenValue);
      setState(() {
        list.addAll(response.list!);
        _loadingOrder = false;
        _page++;
      });
    } on APIError catch (e) {
      showErrorDialog(e.message);
      setState(() {
        _loadingOrder = false;
      });
    }
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
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
            title: Image.asset('assets/images/logoSecond.png', width: 160),
            backgroundColor: kPrimarySecondColor),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
              margin: const EdgeInsets.only(top: 10, right: 20, left: 20,bottom: 10),
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                  color: kWhite,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 3,
                        offset: const Offset(2, 2))
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: DropdownButton<String>(
                      isExpanded: true,
                      iconEnabledColor: kPrimarySecondColor,
                      value: chosenValue,
                      style: const TextStyle(
                          color: kPrimarySecondColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                      items: statusNames
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                      underline:
                          Container(height: 0, color: Colors.transparent),
                      onChanged: (value) {
                        _changeType(value!);
                      }))),
          Expanded(child: Builder(builder: (context) {
            if (list.isEmpty && _loadingOrder) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            }
            return ListView.builder(
              controller: _controller,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: list[index].has_color != ""
                                ? Utils.fromHex(list[index].has_color!)
                                : kWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 3,
                                offset: const Offset(2, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          // trailing: InkWell(
                          //     child: const Icon(
                          //         Icons.info_outline,
                          //         color: kPrimaryColor),
                          //     onTap: () {
                          //       // _showLogOutWarning(context, list[index]);
                          //     }),
                          leading: const Icon(
                            Icons.person_outline_outlined,
                            size: 40,
                          ),
                          title: Text("Дугаар: ${list[index].phone_number}",
                              style: const TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.w500)),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Төлөв: ",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Expanded(
                                    child: Text(
                                      list[index].status_text ?? "",
                                      style: TextStyle(
                                          color: list[index].status == "PENDING"
                                              ? kPrimaryColor
                                              : list[index].status == "DECLINED"
                                                  ? kDanger
                                                  : kSuccess,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Огноо: ${formatDate(list[index].created_at ?? "")}",
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      list[index].has_line == 1
                          ? Column(
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Expanded(child: Divider(indent: 10)),
                                    const SizedBox(width: 4),
                                    Text(
                                      format.format(list[index].line_amount ??
                                          "0".toString()),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      " - ${list[index].line_text ?? ""}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 4),
                                    const Expanded(
                                        child: Divider(endIndent: 10))
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            );
          })),
          Padding(
            padding: const EdgeInsets.all(10.0) +
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: BlackBookButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Буцах"),
            ),
          ),
        ]));
  }
}
