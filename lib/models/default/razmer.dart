class ProductRazmerModel {
  int? id, stock;

  ProductRazmerModel({this.id, this.stock});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stock': stock,
    };
  }
}
