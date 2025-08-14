import 'package:black_book/bloc/payment/bloc.dart';
import 'package:black_book/bloc/payment/event.dart';
import 'package:black_book/bloc/payment/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/packages/detial.dart';
import 'package:black_book/screen/login/loginpay.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';

class Packages extends StatefulWidget {
  final String url;
  final String storeId;
  final bool isMain;
  const Packages(this.url, this.storeId, this.isMain, {super.key});
  @override
  State<Packages> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Packages> {
  final _bloc = PaymentBloc();
  List<PackagesDetial> lst = [];
  final ScrollController _scrollController = ScrollController();
  final NumberFormat format = NumberFormat("#,###");

  @override
  void initState() {
    lst.clear();
    _bloc.add(GetPackagesEvent(widget.url));
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> descLst = ["Хязгааргүй ашигла         .", "Хялбар хурдан хямд      .", "Зарлагаа бодитоор хяна"];
    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: false,
      child: MultiBlocListener(
        listeners: [
          BlocListener<PaymentBloc, PaymentState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is PackagesLoading) {
                  Utils.startLoader(context);
                }
                if (state is PackagesFailure) {
                  Utils.cancelLoader(context);
                  ErrorMessage.attentionMessage(context, state.message);
                }
                if (state is PackagesSuccess) {
                  Utils.cancelLoader(context);
                  setState(() {
                    lst = state.data;
                  });
                }
              })
        ],
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
              shadowColor: Colors.transparent,
              elevation: 0,
              backgroundColor: kBackgroundColor,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30))),
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 40, child: Image.asset('assets/images/logo.png')),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: kWhite.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 3,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: descLst.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_outline_outlined, color: kDanger, size: 16),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  descLst[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                  softWrap: false,
                                  textAlign: TextAlign.center, // ⭐ Optional: center text inside its box
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        color: Colors.grey.shade200,
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: lst.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    if (lst.isNotEmpty)
                                      Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: lst[index].image == null
                                                ? SizedBox(
                                                    width: 70,
                                                    height: 70,
                                                    child: Image.asset(
                                                      "assets/images/mainLogo.png",
                                                      fit: BoxFit.fill,
                                                    ))
                                                : SizedBox(
                                                    width: 70,
                                                    height: 70,
                                                    child: Image.network(
                                                      lst[index].image!,
                                                      fit: BoxFit.fill,
                                                    )),
                                          ),
                                          Positioned(
                                            top: 30,
                                            right: 10,
                                            child: Center(
                                              child: Text(
                                                "${format.format((lst[index].oldAmount ?? 0))}₮",
                                                style: const TextStyle(fontWeight: FontWeight.w600, color: kTextMedium, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 0,
                                            left: 0,
                                            child: Center(
                                              child: Text(
                                                lst[index].title ?? "",
                                                style: TextStyle(fontSize: 16, color: Colors.grey.shade700, fontWeight: FontWeight.w900),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 40,
                                            right: 10,
                                            child: Transform(
                                              transform: Matrix4.rotationZ(0.1),
                                              alignment: Alignment.center,
                                              child: Container(
                                                width: 70,
                                                height: 2,
                                                color: kTextMedium,
                                              ),
                                            ),
                                          ),
                                          if (lst.isNotEmpty)
                                            Positioned(
                                              bottom: 10,
                                              right: 0,
                                              left: 0,
                                              child: Center(
                                                child: Text(
                                                  "${format.format((lst[index].amount ?? 0))}₮",
                                                  style: const TextStyle(fontWeight: FontWeight.w900, color: kPrimaryColor, fontSize: 24),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    const SizedBox(height: 10),
                                    // if (lst.isNotEmpty)
                                    //   SizedBox(
                                    //     height: lst[0].description!.length * 42 > 500 ? 440 : lst[0].description!.length * 42,
                                    //     child: ListView.builder(
                                    //         shrinkWrap: true,
                                    //         physics: const NeverScrollableScrollPhysics(),
                                    //         itemCount: lst[0].description!.length,
                                    //         itemBuilder: (context, i) {
                                    //           return Padding(
                                    //             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                    //             child: Row(
                                    //               children: [
                                    //                 const Icon(
                                    //                   Icons.check_circle_outline_outlined,
                                    //                   color: kPrimaryColor,
                                    //                   size: 16,
                                    //                 ),
                                    //                 const SizedBox(width: 10),
                                    //                 Expanded(
                                    //                   child: Text(
                                    //                     lst[0].description![i],
                                    //                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           );
                                    //         }),
                                    //   ),
                                    BlackBookButton(
                                        width: double.infinity,
                                        height: 40,
                                        onPressed: () {
                                          Navigator.of(context).push(CupertinoPageRoute(
                                              builder: (context) => PayScreen(
                                                    isMain: widget.isMain,
                                                    keys: lst[index].key!,
                                                    storeId: widget.url == "/v1/payment/packages_store" ? widget.storeId : "",
                                                  )));
                                        },
                                        child: const Text("Төлбөр төлөх"))
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    final double maxScroll = _scrollController.position.maxScrollExtent;
                    final double currentScroll = _scrollController.position.pixels;
                    final double targetScroll = (currentScroll + 200).clamp(0, maxScroll);
                    _scrollController.animateTo(
                      targetScroll,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
                      child: const Icon(
                        Icons.keyboard_double_arrow_down_outlined,
                        size: 30,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
