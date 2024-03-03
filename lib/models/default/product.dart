class ProductDefaultModel {
  int? cost, price, stock;
  String? type;

  ProductDefaultModel({this.cost, this.price, this.stock, this.type});

  Map<String, dynamic> toJson() {
    return {
      'cost': cost,
      'price': price,
      'stock': stock,
      'type': type,
    };
  }
}
