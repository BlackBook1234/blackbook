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
import 'package:intl/intl.dart';

class Packages extends StatefulWidget {
  const Packages({super.key});
  @override
  State<Packages> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Packages> {
  final _bloc = PaymentBloc();
  List<PackagesDetial> lst = [];
  final NumberFormat format = NumberFormat("#,###");

  @override
  void initState() {
    lst.clear();
    _bloc.add(const GetPackagesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
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
            elevation: 0,
            backgroundColor: kBackgroundColor,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.keyboard_arrow_left, size: 30))),
        body: Column(
          children: [
            const SizedBox(height: 40),
            SizedBox(height: 40, child: Image.asset('assets/images/logo.png')),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (lst.isNotEmpty)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                                width: 90,
                                height: 70,
                                child: Image.asset(
                                  "assets/images/70.jpg",
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Positioned(
                            top: 10,
                            child: Center(
                              child: Text(
                                "${format.format((lst[0].oldAmount ?? 0))}₮",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: kTextMedium,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 60,
                            right: 0,
                            left: 0,
                            child: Transform(
                              transform: Matrix4.rotationZ(0.09),
                              child: Divider(
                                endIndent: 110,
                                height: 4,
                                thickness: 1,
                                indent: 110,
                                color: Colors.black.withOpacity(0.4),
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
                                  "${format.format((lst[0].amount ?? 0))}₮",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: kPrimaryColor,
                                      fontSize: 21),
                                ),
                              ),
                            ),
                        ],
                      ),
                    const Divider(
                      color: kPrimaryColor,
                    ),
                    if (lst.isNotEmpty)
                      SizedBox(
                        height: lst[0].description!.length * 42 > 500
                            ? 440
                            : lst[0].description!.length * 42,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: lst[0].description!.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 8),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline_outlined,
                                      color: kPrimaryColor,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        lst[0].description![i],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    BlackBookButton(
                        width: double.infinity,
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) =>
                                  PayScreen(keys: lst[0].key!)));
                        },
                        child: const Text("Төлбөр төлөх"))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
