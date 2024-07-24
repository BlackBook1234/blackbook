import 'package:black_book/models/product/product_inlist.dart';
import 'package:equatable/equatable.dart';

abstract class SaleEvent extends Equatable {
  const SaleEvent();

  @override
  List<Object> get props => [];
}

// бараа зарах
class CreateSaleEvent extends SaleEvent {
  final List<ProductInDetialModel> list;
  final String moneyType;
  const CreateSaleEvent(this.list, this.moneyType);

  @override
  List<Object> get props => [list];
}

// барааны мэдээлэл авах
class GetSaleEvent extends SaleEvent {
  final int storeId, page;
  final String searchValue;
  final bool searchAgian;
  final DateTime begindate, endDate;
  const GetSaleEvent(this.storeId, this.searchAgian, this.searchValue,
      this.page, this.begindate, this.endDate);
  @override
  List<Object> get props => [storeId, searchAgian, searchValue];
}

// барааны ерөнхий мэдээлэл авах
class GetMainSaleEvent extends SaleEvent {
  final DateTime beginDate, endDate;
  final String storeId;
  final bool searchAgian;
  final int page;
  const GetMainSaleEvent(
      this.page, this.beginDate, this.endDate, this.storeId, this.searchAgian);
  @override
  List<Object> get props => [page, beginDate, endDate, storeId, searchAgian];
}

// зарагдсан бараа буцаах
class SaleProductBack extends SaleEvent {
  final int saleId, stock, amount;
  const SaleProductBack(this.amount, this.saleId, this.stock);
  @override
  List<Object> get props => [];
}
