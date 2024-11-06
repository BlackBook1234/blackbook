import 'package:black_book/bloc/payment/bloc.dart';
import 'package:black_book/bloc/payment/event.dart';
import 'package:black_book/bloc/payment/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/packages/detial.dart';
import 'package:black_book/screen/login/loginpay.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Packages extends StatefulWidget {
  const Packages({super.key});
  @override
  State<Packages> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Packages> {
  final _bloc = PaymentBloc();
  List<PackagesDetial> lst = [];
  void onLogin() {}

  @override
  void initState() {
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
            body: Column(children: [
              SizedBox(
                  height: 40, child: Image.asset('assets/images/logo.png')),
              const SizedBox(height: 30),
              const Text("Та сонгоно уу?"),
              Expanded(
                  child: ListView.builder(
                      itemCount: lst.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) => PayScreen(
                                                  keys: lst[index].key!)));
                                    },
                                    title: Center(
                                        child: Text(
                                            "${lst[index].amount.toString()}₮",
                                            style: const TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 18))),
                                    subtitle: Column(children: [
                                      Text(
                                        lst[index].description!,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        lst[index].title!,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]))));
                      })),
            ])));
  }
}
