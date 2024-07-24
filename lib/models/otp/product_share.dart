class ProductShareOtp {
  int? cost, price, stock, id;

  ProductShareOtp({this.cost, this.price, this.stock, this.id});

  Map<String, dynamic> toJson() {
    return {
      'cost': cost,
      'price': price,
      'stock': stock,
      'id': id,
    };
  }
}
