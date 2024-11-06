class ProductDefaultAddModel {
  int? cost, price, stock, id;

  ProductDefaultAddModel({this.cost, this.price, this.stock, this.id});

  Map<String, dynamic> toJson() {
    return {
      'cost': cost,
      'price': price,
      'stock': stock,
      'id': id,
    };
  }
}

class ProductAddSizeModel {
  String? size;
  int? stock;

  ProductAddSizeModel({this.stock, this.size});

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'stock': stock,
    };
  }
}
