import 'package:black_book/constant.dart';
import 'package:flutter/material.dart';

class ErrorMessage {
  static void attentionMessage(
    BuildContext context,
    labelText,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        elevation: 0,
        content: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  height: 70,
                  decoration: BoxDecoration(
                      color: kBlack.withOpacity(0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Row(children: [
                    const SizedBox(width: 48),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          const Text('Алдаа!',
                              style: TextStyle(fontSize: 16, color: kWhite)),
                          Text('$labelText',
                              style:
                                  const TextStyle(fontSize: 14, color: kWhite),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis)
                        ]))
                  ])),
              const Positioned(
                  bottom: 20,
                  left: 20,
                  child: ClipRRect(
                      child: Stack(children: [
                    Icon(Icons.error_outline_outlined, color: kWhite, size: 30)
                  ]))),
              Positioned(
                  top: -20,
                  right: 0,
                  child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            color: kBlack,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Icon(Icons.close_rounded,
                              color: kWhite, size: 20))))
            ])));
  }
}
