import 'package:flutter/material.dart';

class TypeProvider extends ChangeNotifier {
  List<String> typeList = [];

  TypeProvider();

// захиалга нэмэх хэсгээс сагсанд хийх
  void setTypeList(List<String> lstData) {
    typeList = lstData;
    notifyListeners();
  }

  void addTypeList(String name) {
    typeList.add(name);
    notifyListeners();
  }

  void removeList() {
    typeList.clear();
    notifyListeners();
  }
}
