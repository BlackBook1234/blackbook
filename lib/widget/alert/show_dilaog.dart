// import 'package:black_book/constant.dart';
// import 'package:flutter/material.dart';

// class AlertMessage {
//   static void attentionMessage(
//     BuildContext context,
//     labelText,
//   ) {
//     showDialog(
//         context: context,
//         builder: (context) => Dialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.0)),
//               child: SizedBox(
//                 height: 180,
//                 width: 50,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                         height: 60.0,
//                         width: 60.0,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20.0)),
//                         child: ClipRRect(
//                             borderRadius: BorderRadius.circular(9),
//                             child: Image.asset("assets/images/mainLogo.png",
//                                 fit: BoxFit.cover))),
//                     Text(
//                       labelText,
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                     ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text(
//                           "Ok",
//                           style: TextStyle(color: kPrimaryColor),
//                         ))
//                   ],
//                 ),
//               ),
//             ));
//   }

//   static void alertMessage(
//       BuildContext context, String status, String labelText) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//               icon: SizedBox(
//                 width: 30,
//                 height: 30,
//                 child: Image.asset(
//                   "assets/images/mainLogo.png",
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(15))),
//               scrollable: true,
//               title: Text(status,
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center),
//               contentPadding: const EdgeInsets.only(
//                   right: 20, left: 20, bottom: 20, top: 10),
//               content: Column(children: [
//                 Text(labelText, textAlign: TextAlign.center),
//                 const SizedBox(height: 20)
//               ]));
//         });
//   }

//   static void statusMessage(
//       BuildContext context, String status, String labelText, bool popup) {
//     showDialog(
//         barrierDismissible: popup,
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//               icon: SizedBox(
//                 width: 30,
//                 height: 30,
//                 child: Image.asset(
//                   "assets/images/mainLogo.png",
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(15))),
//               scrollable: true,
//               title: Text(status,
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center),
//               contentPadding: const EdgeInsets.only(
//                   right: 20, left: 20, bottom: 20, top: 10),
//               content: Column(children: [
//                 Text(labelText, textAlign: TextAlign.center),
//                 const SizedBox(height: 20)
//               ]));
//         });
//   }
// }
