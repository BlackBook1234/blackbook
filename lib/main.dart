import 'dart:convert';

import 'package:black_book/bloc/refresh_token/bloc.dart';
import 'package:black_book/bloc/refresh_token/event.dart';
import 'package:black_book/bloc/refresh_token/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/global_keys.dart';
import 'package:black_book/models/user_data/user_data.dart';
import 'package:black_book/provider/loader.dart';
import 'package:black_book/provider/user_provider.dart';
import 'package:black_book/screen/home/navigator.dart';
import 'package:black_book/theme.dart';
import 'package:black_book/util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'provider/product_share_provider.dart';
import 'screen/login/login.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String? user;
  final _bloc = RefreshBloc();
  @override
  void initState() {
    super.initState();
    initUserInfo();
  }

  void initUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getString("userInfo");
    });
    if (user != null) {
      final Map<String, dynamic> data = json.decode(user!);
      Utils.getCommonProvider().setUserInfo(UserDataModel.fromJson(data));
      _bloc.add(const RefreshTokenEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommonProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => LoaderProvider())
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        navigatorKey: GlobalKeys.navigatorKey,
        theme: AppTheme.lightTheme(context),
        home: user == null
            ? LoginScreen()
            : MultiBlocListener(
                listeners: [
                  BlocListener<RefreshBloc, RefreshTokenState>(
                    bloc: _bloc,
                    listener: (context, state) {
                      if (state is RefreshLoading) {}
                      if (state is RefreshFailure) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false);
                      }
                      if (state is RefreshSuccess) {
                        Utils.cancelLoader(context);
                        if (Utils.getIpaid() == 1) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => NavigatorScreen(),
                              ),
                              (route) => false);
                        } else {
                          Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (route) => false);
                        }
                      }
                    },
                  )
                ],
                child: Scaffold(
                  body: Container(
                    color: Colors.transparent,
                    child: const Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
// allBalance niit ashig orlogiig hamt yvuulah (20 baraanaas niilber tootsvol buruu dun garna)
// borluulalt hiih uyd delguur bolon aguulahiig ylgah store_id g yu gej yvuulah we boss uyd


// page ihesgeh uyd baraanuud listen dotor list bdg uchir end neg asuudal bgaa(baraa nemegdeh uyd asuudalgui nemegdej bgayu)