import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/notification/detial.dart';
import 'package:black_book/screen/transfer/share_list.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotficationScreen extends StatefulWidget {
  const NotficationScreen({super.key});

  @override
  State<NotficationScreen> createState() => _NotficationScreenState();
}

class _NotficationScreenState extends State<NotficationScreen>
    with BaseStateMixin {
  final ScrollController _controller = ScrollController();
  List<NotificationDetail>? notficationdata;
  int page = 1;

  @override
  void initState() {
    refreshPage();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        page++;
      });
      _getNotification();
    }
  }

  Future<void> refreshPage() async {
    await _getNotification();
  }

  Future<void> _setNotification(int id, String sourceId) async {
    try {
      await api.setNotification(id).then((value) => Navigator.of(context)
          .push(CupertinoPageRoute(
              builder: (context) => ShareListHistoryScreen(
                    sourceId: sourceId,
                    inComeOutCome: false,
                  )))
          .then((value) => refreshPage()));
    } on APIError catch (e) {
      showErrorDialog(e.message);
    }
  }

  Future<void> _getNotification() async {
    try {
      var res = await api.getNotification(page);
      setState(() {
        notficationdata = res.data;
      });
    } on APIError catch (e) {
      showErrorDialog(e.message);
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if (notficationdata == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: refreshPage,
                  child: ListView.builder(
                    itemCount: notficationdata!.length,
                    itemBuilder: (ctx, i) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: notficationdata![i].isSeen == null
                                  ? kContainerBg
                                  : kBackgroundColor,
                              borderRadius: BorderRadius.circular(18)),
                          padding:
                              const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                          child: InkWell(
                            onTap: () {
                              _setNotification(notficationdata![i].id!,
                                  notficationdata![i].sourceId!);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    notficationdata![i].title ?? "",
                                    style: const TextStyle(
                                        color: kTextDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  notficationdata![i].body ?? "",
                                  style: const TextStyle(
                                      color: kTextMedium, fontSize: 12),
                                ),
                                Text(
                                  formatDate(
                                      notficationdata![i].createdAt ?? ""),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 10,
                bottom: MediaQuery.of(context).padding.bottom,
                right: 20.0,
                left: 20),
            child: BlackBookButton(
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
}
