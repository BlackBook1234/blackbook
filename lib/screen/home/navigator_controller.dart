import 'package:black_book/bloc/product/bloc.dart';
import 'package:black_book/util/utils.dart';
import 'package:get/get.dart';

class NavigatorController extends GetxController {
  RxInt currentIndex = RxInt(0);
  final bloc = ProductBloc();
  String userRole = "";

  @override
  void onInit() {
    userRole = Utils.getUserRole();
    super.onInit();
  }

  void updatePage(int count) {
    currentIndex.value = count;
    update();
  }
}
