class SizeModel {
  final int id;
  final String type;
  final int cost;
  final int price;
  final int stock;

  SizeModel({
    required this.id,
    required this.type,
    required this.cost,
    required this.price,
    required this.stock,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: json['id'],
      type: json['type'],
      cost: json['cost'],
      price: json['price'],
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'cost': cost,
        'price': price,
        'stock': stock,
      };
}

class EditProductModel {
  final String name;
  final String code;
  final int categoryId;
  final String photoUrl;
  final List<SizeModel> sizes;

  EditProductModel({
    required this.name,
    required this.code,
    required this.categoryId,
    required this.photoUrl,
    required this.sizes,
  });

  factory EditProductModel.fromJson(Map<String, dynamic> json) {
    return EditProductModel(
      name: json['name'],
      code: json['code'],
      categoryId: json['categoryId'],
      photoUrl: json['photoUrl'],
      sizes: (json['sizes'] as List).map((size) => SizeModel.fromJson(size)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'categoryId': categoryId,
        'photoUrl': photoUrl,
        'sizes': sizes.map((s) => s.toJson()).toList(),
      };
}
