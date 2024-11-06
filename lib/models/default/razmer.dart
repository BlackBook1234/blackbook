class ProductRazmerModel {
  int? id, stock;
  String? size;

  ProductRazmerModel({this.id, this.stock, this.size});

  Map<String, dynamic> toJson() {
    return {'id': id, 'stock': stock, 'size': size};
  }
}
