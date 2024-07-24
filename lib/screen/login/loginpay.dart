import 'package:black_book/bloc/payment/bloc.dart';
import 'package:black_book/bloc/payment/event.dart';
import 'package:black_book/bloc/payment/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/invoice/detial.dart';
import 'package:black_book/screen/home/navigator.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key, required this.keys});
  final String keys;
  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> with BaseStateMixin {
  final PageController _pageController = PageController();
  final String _chosenValue = "Хаан Банк";
  final _bloc = PaymentBloc();
  InvoiceDetial lst = InvoiceDetial();
  int currentPage = 0;

  @override
  void initState() {
    _bloc.add(GetInvoiceEvent(widget.keys));
    super.initState();
  }

  void checkPayment() {
    _bloc.add(CheckInvoiceEvent(lst.orderId!));
  }

  _launchURL(String path) async {
    String url = path;
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showErrorDialog("Аппликейшн байхгүй байна!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<PaymentBloc, PaymentState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is InvoiceLoading) {
                  Utils.startLoader(context);
                }
                if (state is InvoiceFailure) {
                  Utils.cancelLoader(context);
                  showErrorDialog(state.message);
                  // AlertMessage.alertMessage(context, "Мэдээлэл", state.message);
                }
                if (state is InvoiceSuccess) {
                  setState(() {
                    lst = state.data;
                  });
                  Utils.cancelLoader(context);
                }
              }),
          BlocListener<PaymentBloc, PaymentState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is CheckInvoiceLoading) {
                  Utils.startLoader(context);
                }
                if (state is CheckInvoiceFailure) {
                  Utils.cancelLoader(context);
                  showWarningDialog(state.message);
                }
                if (state is CheckInvoiceSuccess) {
                  Utils.cancelLoader(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const NavigatorScreen()),
                      (route) => false);
                  // Navigator.of(context).push(CupertinoPageRoute(
                  //     builder: (context) => const NavigatorScreen()));
                }
              })
        ],
        child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
                width: 140,
                height: 40,
                child: FloatingActionButton(
                    backgroundColor: kWhite,
                    onPressed: () {
                      checkPayment();
                    },
                    child: const Center(
                        child: Text("Төлбөр шалгах",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kPrimaryColor, fontSize: 14))))),
            body: Column(children: [
              Container(
                  height: 70,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: kPrimarySecondColor),
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text("ТӨЛБӨР ТӨЛӨХ",
                          style: TextStyle(
                              color: kWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)))),
              Container(
                  height: 45,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: kPrimarySecondColor),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                currentPage = 0;
                              });
                              _pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut);
                            },
                            child: Container(
                                height: 30,
                                width: 100.0,
                                decoration: BoxDecoration(
                                    color: currentPage == 0
                                        ? kWhite
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Center(
                                    child: Text("QPAY",
                                        style: TextStyle(
                                            color: currentPage == 0
                                                ? kPrimarySecondColor
                                                : kWhite,
                                            fontWeight: FontWeight.bold))))),
                        InkWell(
                            onTap: () {
                              setState(() {
                                currentPage = 1;
                              });
                              _pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut);
                            },
                            child: Container(
                                height: 30,
                                width: 100.0,
                                decoration: BoxDecoration(
                                    color: currentPage == 1
                                        ? kWhite
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Center(
                                    child: Text("Шилжүүлэг",
                                        style: TextStyle(
                                            color: currentPage == 1
                                                ? kPrimarySecondColor
                                                : kWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13)))))
                      ])),
              Expanded(
                  child: PageView(
                      controller: _pageController,
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                      children: [
                    Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(children: [
                          const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text("Төлөх дүн",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14))),
                          const SizedBox(height: 5),
                          Text("${lst.amount ?? "0"} ₮",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                  color: kPrimaryColor)),
                          Container(
                              width: 110,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Хугацаа: ",
                                        style: TextStyle(color: kPrimaryColor)),
                                    Text(lst.title ?? "")
                                  ])),
                          const Text("Банкны апп-аар",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Expanded(
                              child: lst.qpay != null &&
                                      lst.qpay!.urls != null &&
                                      lst.qpay!.urls!.isNotEmpty
                                  ? GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3),
                                      itemCount: lst.qpay!.urls!.length,
                                      itemBuilder: (context, int index) {
                                        return GridTile(
                                            child: InkWell(
                                                onTap: () async {
                                                  String url = lst
                                                      .qpay!.urls![index].link!;
                                                  _launchURL(url);
                                                },
                                                child: Column(children: [
                                                  Container(
                                                      height: 60.0,
                                                      width: 60.0,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0)),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9),
                                                          child: Image.network(
                                                              lst
                                                                  .qpay!
                                                                  .urls![index]
                                                                  .logo!,
                                                              fit: BoxFit
                                                                  .cover))),
                                                  Text(
                                                      lst.qpay!.urls![index]
                                                          .name!,
                                                      style: const TextStyle(
                                                          fontSize: 12))
                                                ])));
                                      })
                                  : const Center(
                                      child: CircularProgressIndicator()))
                        ])),
                    SingleChildScrollView(
                        child: Column(children: [
                      const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text("Төлөх дүн",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14))),
                      const SizedBox(height: 5),
                      Text("${lst.amount.toString()} ₮",
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
                              color: kPrimaryColor)),
                      const Text("Банкны шилжүүлгээр",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 30),
                          child: lst.qpay != null &&
                                  lst.qpay!.urls != null &&
                                  lst.qpay!.urls!.isNotEmpty
                              ? Column(children: [
                                  Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.15),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 10),
                                          child: DropdownButton<String>(
                                              isExpanded: true,
                                              value: _chosenValue,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                              items: <String>[
                                                'Хаан Банк'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value));
                                              }).toList(),
                                              underline: Container(
                                                  height: 0,
                                                  color: Colors.transparent),
                                              onChanged: (value) {}))),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Дансний дугаар",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12)),
                                                  Text(lst.manual![0].account!,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500))
                                                ]),
                                            InkWell(
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: lst.manual![0]
                                                              .account!));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Амжилттай хуулагдлаа")));
                                                },
                                                child: Container(
                                                    width: 100,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withOpacity(0.15),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: const Center(
                                                        child: Text("Хуулах",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize:
                                                                    12)))))
                                          ])),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Гүйлгээний утга",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12)),
                                                  Text(
                                                      lst.manual![0].description
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500))
                                                ]),
                                            InkWell(
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: lst.manual![0]
                                                              .description!));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Амжилттай хуулагдлаа")));
                                                },
                                                child: Container(
                                                    width: 100,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withOpacity(0.15),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: const Center(
                                                        child: Text("Хуулах",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize:
                                                                    12)))))
                                          ])),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Дансний нэр",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12)),
                                                  Text(
                                                      lst.manual![0]
                                                          .accountName!,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500))
                                                ]),
                                            InkWell(
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: lst.manual![0]
                                                              .accountName!));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Амжилттай хуулагдлаа")));
                                                },
                                                child: Container(
                                                    width: 100,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withOpacity(0.15),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: const Center(
                                                        child: Text("Хуулах",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize:
                                                                    12)))))
                                          ]))
                                ])
                              : const Center(
                                  child: CircularProgressIndicator()))
                    ]))
                  ]))
            ])));
  }
}
