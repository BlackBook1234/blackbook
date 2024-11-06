import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/category/category_detial.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChangeCategoryScreen extends StatefulWidget {
  const ChangeCategoryScreen({super.key});
  @override
  State<ChangeCategoryScreen> createState() => _ChangeCategoryScreenState();
}

class _ChangeCategoryScreenState extends State<ChangeCategoryScreen>
    with BaseStateMixin {
  bool _loadingData = false;
  List<CategoryDetialModel> lst = [];
  final TextEditingController _controller = TextEditingController();

  Future<void> _transferDataSend() async {
    if (lst.isNotEmpty) return;
    if (_loadingData) return;
    setState(() {
      _loadingData = true;
    });
    try {
      List<CategoryDetialModel> res = await api.getProductType();
      setState(() {
        lst = res;
        _loadingData = false;
      });
    } on APIError catch (e) {
      showErrorDialog(e.message);
      setState(() {
        _loadingData = false;
      });
    }
  }

  Future<void> _changeType(context, int index) async {
    try {
      setState(() {
        _loadingData = true;
      });
      await api.changeType(_controller.text, index).then((value) => {
            setState(() {
              _loadingData = false;
              lst.clear();
              _controller.clear();
            }),
            _transferDataSend(),
            Navigator.pop(context)
          });
    } on APIError catch (e) {
      setState(() {
        _loadingData = false;
      });
      showErrorDialog(e.message);
    }
  }

  @override
  void initState() {
    _transferDataSend();
    super.initState();
  }

  void _changePhoneNumber(int index) {
    var alert = AlertDialog(
        backgroundColor: kWhite,
        content: TextFormField(
            maxLength: 20,
            textInputAction: TextInputAction.done,
            controller: _controller,
            keyboardType: TextInputType.text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: "Нэр",
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black38),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black26),
                  borderRadius: BorderRadius.circular(10)),
            )),
        actions: [
          BlackBookButton(
              onPressed: () {
                if (_controller.text.isEmpty) {
                  showErrorDialog("Нэр оруулна уу");
                  return;
                } else {
                  _changeType(context, index);
                }
              },
              width: double.infinity,
              child: const Text("Солих",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)))
        ]);
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
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
      body: ListView.builder(
        itemCount: lst.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 3,
                        offset: const Offset(2, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    trailing: const Icon(
                      Icons.edit_outlined,
                      color: kPrimaryColor,
                    ),
                    leading: SvgPicture.network(
                      lst[index].iconUrl!,
                      width: 30,
                      colorFilter: const ColorFilter.mode(
                          kPrimaryColor, BlendMode.srcIn),
                    ),
                    title: Text(
                      lst[index].name ?? "",
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      _changePhoneNumber(lst[index].id ?? 0);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
