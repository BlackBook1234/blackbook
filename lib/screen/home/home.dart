import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/banner/detial.dart';
import 'package:black_book/screen/core/add_division.dart';
import 'package:black_book/screen/core/change_type.dart';
import 'package:black_book/screen/core/show_date_product.dart';
import 'package:black_book/screen/home/widget/banners_carousel.dart';
import 'package:black_book/screen/sale_product/sold.dart';
import 'package:black_book/screen/share/share_product.dart';
import 'package:black_book/screen/store/store.dart';
import 'package:black_book/screen/transfer/share_list.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:black_book/widget/banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with BaseStateMixin {
  List<BannerDetial> url = [];
  String userRole = "BOSS";

  @override
  void initState() {
    super.initState();
    _getBanner();
    userRole = Utils.getUserRole();
  }

  Future<void> _getBanner() async {
    try {
      if (url.isEmpty) {
        List<BannerDetial> res = await api.getBanner();
        setState(() {
          url = res;
        });
      }
    } on APIError catch (e) {
      showErrorDialog(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: getSize(10),
          ),
          HeadphoneBanner(urls: url),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: getSize(20),
                ),
                homeContainer(
                    context, "Салбар дэлгүүр нээх", "assets/svg/add_store.svg",
                    () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const AddDivision()));
                }, userRole),
                homeContainer(
                    context, "Бараа шилжүүлэг", "assets/svg/home_share.svg",
                    () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const ShareProductScreen()));
                }, "BOSS"),
                homeContainer(
                    context, "Зарагдсан бараа", "assets/svg/home-sold.svg", () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const SoldItemMainScreen()));
                }, "BOSS"),
                homeContainer(context, "Миний дэлгүүрүүд",
                    "assets/svg/home_all_store.svg", () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const DivisionScreen()));
                }, userRole),
                homeContainer(context, "Бараа шилжүүлсэн түүх",
                    "assets/svg/home_history.svg", () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const ShareListHistoryScreen(
                        inComeOutCome: false,
                        sourceId: '',
                      ),
                    ),
                  );
                }, "BOSS"),
                homeContainer(
                    context, "Шилжиж ирсэн бараа", "assets/svg/warehouse.svg",
                    () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const ShareListHistoryScreen(
                        inComeOutCome: true,
                        sourceId: '',
                      ),
                    ),
                  );
                }, "BOSS"),
                homeContainer(
                    context, "Орлуулсан бараа", "assets/svg/add_type.svg", () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const DateProductSearch(),
                    ),
                  );
                }, "BOSS"),
                homeContainer(
                    context, "Төрөл өөрчлөлт", "assets/svg/share.svg", () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const ChangeCategoryScreen(),
                    ),
                  );
                }, "BOSS"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget homeContainer(BuildContext context, String title, String iconUrl,
    Function onTap, String userRole) {
  return userRole == "BOSS"
      ? Padding(
          padding:
              const EdgeInsets.only(top: 7, bottom: 5, right: 10, left: 10),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: kWhite,
              // border: Border.all(width: 1, color: kPrimaryColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 30,
                  top: 0,
                  bottom: 0,
                  child: SvgPicture.asset(
                    iconUrl,
                    width: 20,
                    height: 20,
                    fit: BoxFit.scaleDown,
                    colorFilter:
                        const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
                  ),
                ),
                Positioned(
                  left: 70,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Positioned(
                //   right: 10,
                //   top: 0,
                //   bottom: 0,
                //   child: SvgPicture.asset(
                //     "assets/svg/right_arrow.svg",
                //     width: 7,
                //     colorFilter:
                //         const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
                //   ),
                // ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        onTap.call();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      : const SizedBox.shrink();
}
