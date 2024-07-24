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
