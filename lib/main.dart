import 'dart:convert';

import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/global_keys.dart';
import 'package:black_book/models/user_data/user_data.dart';
import 'package:black_book/provider/loader.dart';
import 'package:black_book/provider/type.dart';
import 'package:black_book/provider/user_provider.dart';
import 'package:black_book/screen/home/navigator.dart';
import 'package:black_book/theme.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'provider/product_share_provider.dart';
import 'screen/login/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with BaseStateMixin {
  String? user;

  @override
  void initState() {
    super.initState();
    initUserInfo();
  }

  Future<void> _getUserData(context) async {
    try {
      await api.refreshToken();
    } on APIError catch (e) {
      if (e.message != "Интернэт холболтоо шалгана уу.") {
        setState(() {
          user = null;
        });
      } else if (e.message == "token_expired") {
        setState(() {
          user = null;
        });
      }
    }
  }

  Future<void> initUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getString("userInfo");
    });
    if (user != null) {
      final Map<String, dynamic> data = json.decode(user!);
      Utils.getCommonProvider().setUserInfo(UserDataModel.fromJson(data));
      // ignore: use_build_context_synchronously
      await _getUserData(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommonProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => LoaderProvider()),
        ChangeNotifierProvider(create: (_) => TypeProvider())
      ],
      child: KeyboardVisibilityProvider(
        child: MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              // Locale('zh', ''),
              Locale('mn', ''),
            ],
            locale: const Locale('mn', ''),
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            navigatorKey: GlobalKeys.navigatorKey,
            theme: AppTheme.lightTheme(context),
            home: user == null
                ? const LoginScreen()
                : Utils.getUserRole() == "WORKER" || Utils.getIpaid() == 1
                    ? const NavigatorScreen(
                        screenIndex: 0,
                      )
                    : const LoginScreen()

            // Provider.of<CommonProvider>(context, listen: false).logout()
            // : MultiBlocListener(
            //     listeners: [
            //       BlocListener<RefreshBloc, RefreshTokenState>(
            //         bloc: _bloc,
            //         listener: (context, state) {
            //           if (state is RefreshLoading) {}
            //           if (state is RefreshFailure) {
            //             Navigator.pushAndRemoveUntil(
            //                 context,
            //                 CupertinoPageRoute(
            //                     builder: (context) => const LoginScreen()),
            //                 (route) => false);
            //           }
            //           if (state is RefreshSuccess) {
            //             Utils.cancelLoader(context);
            //             if (Utils.getUserRole() == "WORKER") {
            //               Navigator.pushAndRemoveUntil(
            //                   context,
            //                   CupertinoPageRoute(
            //                     builder: (context) => const NavigatorScreen(),
            //                   ),
            //                   (route) => false);
            //             } else if (Utils.getIpaid() == 1) {
            //               Navigator.pushAndRemoveUntil(
            //                   context,
            //                   CupertinoPageRoute(
            //                     builder: (context) => const NavigatorScreen(),
            //                   ),
            //                   (route) => false);
            //             } else {
            //               Provider.of<CommonProvider>(context, listen: false)
            //                   .logout();
            //               Navigator.pushAndRemoveUntil(
            //                   context,
            //                   CupertinoPageRoute(
            //                     builder: (context) => const LoginScreen(),
            //                   ),
            //                   (route) => false);
            //             }
            //           }
            //         },
            //       )
            //     ],
            //     child: Scaffold(
            //       body: Container(
            //         color: Colors.transparent,
            //         child: const Center(
            //           child: SizedBox(
            //             height: 30,
            //             width: 30,
            //             child: CircularProgressIndicator(color: kPrimaryColor,),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            ),
      ),
    );
  }
}
// allBalance niit ashig orlogiig hamt yvuulah (20 baraanaas niilber tootsvol buruu dun garna)
// borluulalt hiih uyd delguur bolon aguulahiig ylgah store_id g yu gej yvuulah we boss uyd


// page ihesgeh uyd baraanuud listen dotor list bdg uchir end neg asuudal bgaa(baraa nemegdeh uyd asuudalgui nemegdej bgayu)