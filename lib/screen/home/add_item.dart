import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/category/category_detial.dart';
import 'package:black_book/screen/product/add_item_detial.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddIemScreen extends StatefulWidget {
  const AddIemScreen({super.key});
  @override
  State<AddIemScreen> createState() => _AddIemScreenState();
}

class _AddIemScreenState extends State<AddIemScreen> with BaseStateMixin {
  bool _loadingData = false;
  List<CategoryDetialModel> lst = [];

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

  @override
  void initState() {
    _transferDataSend();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                  trailing: SvgPicture.asset(
                    "assets/svg/right_arrow.svg",
                    width: 7,
                    colorFilter:
                        const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
                  ),
                  leading: SvgPicture.network(
                    lst[index].iconUrl!,
                    width: 30,
                    colorFilter:
                        const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
                  ),
                  title: Text(
                    lst[index].name ?? "",
                    style: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => AddItemDetialScreen(
                          id: lst[index].id!,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
