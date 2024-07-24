import 'package:black_book/models/sale/sale_detial.dart';
import 'package:black_book/models/sale/total.dart';
import 'package:black_book/models/sale_product/product_in_detial.dart';
import 'package:equatable/equatable.dart';

abstract class SaleState extends Equatable {}

class SaleInitial extends SaleState {
  @override
  List<Object?> get props => [];
}

// бараа зарах
class SaleLoading extends SaleState {
  @override
  List<Object?> get props => [];
}

class SaleFailure extends SaleState {
  final String message;

  SaleFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class SaleSuccess extends SaleState {
  SaleSuccess();
  @override
  List<Object?> get props => [];
}

// бараа зарах
class GetSaleLoading extends SaleState {
  @override
  List<Object?> get props => [];
}

class GetSaleFailure extends SaleState {
  final String message;

  GetSaleFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class GetSaleSuccess extends SaleState {
  final List<SaleProductInDetialModel> list;
  final TotalSaleModel total;
  final bool hasMoreOrder;
  GetSaleSuccess(this.list, this.total, this.hasMoreOrder);
  @override
  List<Object?> get props => [list];
}

// бараа ерөнхий
class GetMainSaleLoading extends SaleState {
  @override
  List<Object?> get props => [];
}

class GetMainSaleFailure extends SaleState {
  final String message;

  GetMainSaleFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class GetMainSaleSuccess extends SaleState {
  final DetialSaleProductModel list;
  final bool hasMoreOrder;
  GetMainSaleSuccess(this.list, this.hasMoreOrder);
  @override
  List<Object?> get props => [list, hasMoreOrder];
}

// зарагдсан бараа буцаах
class SaleProductBackLoading extends SaleState {
  @override
  List<Object?> get props => [];
}

class SaleProductBackFailure extends SaleState {
  final String message;

  SaleProductBackFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class SaleProductBackSuccess extends SaleState {
  SaleProductBackSuccess();
  @override
  List<Object?> get props => [];
}
