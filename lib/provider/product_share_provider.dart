import 'package:black_book/models/product/product_detial.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductDetialModel> lstDraft = [];
  int currentIndex = 0;

  ProductProvider();

// захиалга нэмэх хэсгээс сагсанд хийх
  void setProductItemsData(ProductDetialModel lstData) {
    List<ProductDetialModel> itemsToAdd = [];
    if (lstDraft.isNotEmpty) {
      for (ProductDetialModel data in lstDraft) {
        if (data.good_id != lstData.good_id) {
          ProductDetialModel draftData = ProductDetialModel(
              name: lstData.name,
              code: lstData.code,
              good_id: lstData.good_id,
              category_id: lstData.category_id,
              created_at: lstData.created_at,
              parent_category: lstData.parent_category,
              parent_name: lstData.parent_name,
              category_name: lstData.category_name,
              sizes: lstData.sizes);
          itemsToAdd.add(draftData);
        }
      }
    } else {
      lstDraft.add(lstData);
    }
    lstDraft.addAll(itemsToAdd);
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
