import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {}

class ProductInitial extends ProductState {
  @override
  List<Object?> get props => [];
}

// бараа шинээр үүсгэх
class ProductLoading extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductFailure extends ProductState {
  final String message;

  ProductFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ProductSuccess extends ProductState {
  ProductSuccess();
  @override
  List<Object?> get props => [];
}

//бараа мэдээлэл авах

class GetProductLoading extends ProductState {
  @override
  List<Object?> get props => [];
}

class GetProductFailure extends ProductState {
  final String message;

  GetProductFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class GetProductSuccess extends ProductState {
  final List<ProductDetialModel> list;
  final List<ProductStoreModel> storeList;
  final bool hasMoreOrder;
  GetProductSuccess(this.list, this.storeList, this.hasMoreOrder);
  @override
  List<Object?> get props => [list, storeList];
}

//дэлгүүрийн барааны мэдээлэл авах

class GetStoreItemLoading extends ProductState {
  @override
  List<Object?> get props => [];
}

class GetStoreItemFailure extends ProductState {
  final String message;

  GetStoreItemFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class GetStoreItemSuccess extends ProductState {
  final List<ProductDetialModel> list;
  GetStoreItemSuccess(this.list);
  @override
  List<Object?> get props => [list];
}
