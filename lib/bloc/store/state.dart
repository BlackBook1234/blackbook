import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:black_book/models/product/store_amount.dart';
import 'package:black_book/models/store/store_detial.dart';
import 'package:equatable/equatable.dart';

abstract class StoreState extends Equatable {}

class StoreInitial extends StoreState {
  @override
  List<Object?> get props => [];
}

// дэлгүүр шинээр үүсгэх
class StoreLoading extends StoreState {
  @override
  List<Object?> get props => [];
}

class StoreFailure extends StoreState {
  final String message;

  StoreFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class StoreSuccess extends StoreState {
  StoreSuccess();
  @override
  List<Object?> get props => [];
}

//Дэлгүүрийн мэдээлэл авах

class GetStoreLoading extends StoreState {
  @override
  List<Object?> get props => [];
}

class GetStoreFailure extends StoreState {
  final String message;

  GetStoreFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class GetStoreSuccess extends StoreState {
  final List<StoreDetialModel> list;
  GetStoreSuccess(this.list);
  @override
  List<Object?> get props => [list];
}

//Дэлгүүрийн бараа авах

class GetStoreProductLoading extends StoreState {
  @override
  List<Object?> get props => [];
}

class GetStoreProductFailure extends StoreState {
  final String message;

  GetStoreProductFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class GetStoreProductSuccess extends StoreState {
  final List<ProductDetialModel> list;
  final StoreAmountModel? amount;
  final List<ProductStoreModel>? stores;
  final bool hasMoreOrder;
  GetStoreProductSuccess(
      this.list, this.amount, this.stores, this.hasMoreOrder);
  @override
  List<Object?> get props => [list, amount, stores, hasMoreOrder];
}
