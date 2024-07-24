// import 'package:black_book/constant.dart';
// import 'package:flutter/material.dart';

// class MainScaffold extends StatelessWidget {
//   Widget child;
//   bool? loadingData = false;
//   Function? onTap;
//   MainScaffold(
//     {Key? key,
//     required this.child,
//     this.loadingData,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (onTap != null) {
//           onTap!();
//         }
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//             leading: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(Icons.keyboard_arrow_left, size: 30)),
//             foregroundColor: kWhite,
//             title: Image.asset('assets/images/logoSecond.png', width: 160),
//             backgroundColor: kPrimarySecondColor),
//         body: loadingData == true
//             ? child
//             :   RefreshIndicator(
//             color: kPrimaryColor,
//             backgroundColor: kWhite,
//             key: refresh,
//             onRefresh: refreshList,
//             child: Center(
//                 child: CircularProgressIndicator(
//                   color: kPrimaryColor,
//                 ),
//               ),
//       ),
//     );
//   }
// }
