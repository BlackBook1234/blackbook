import 'package:black_book/models/product/product_detial.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductDetialModel> lstDraft = [];
  int currentIndex = 0;

  ProductProvider();

// захиалга нэмэх хэсгээс сагсанд хийх
  void setProductItemsData(ProductDetialModel lstData) {
    if (lstDraft.isNotEmpty) {
      bool found = false;
      for (int i = 0; i < lstDraft.length; i++) {
        ProductDetialModel data = lstDraft[i];
        if (data.good_id == lstData.good_id) {
          found = true;
          break;
        }
      }
      if (!found) {
        lstDraft.add(lstData);
      }
    } else {
      lstDraft.add(lstData);
    }
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void removeOrderItem(ProductDetialModel order) {
    lstDraft.remove(order);
    notifyListeners();
  }

  void removeAllItem() {
    lstDraft.clear();
    notifyListeners();
  }
}
