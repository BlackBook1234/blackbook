import 'package:black_book/models/product/product_detial.dart';
import 'package:black_book/models/transfer/detial.dart';
import 'package:equatable/equatable.dart';

abstract class ShareState extends Equatable {}

class ShareInitial extends ShareState {
  @override
  List<Object?> get props => [];
}

// бараа шилжүүлэг
class ShareLoading extends ShareState {
  @override
  List<Object?> get props => [];
}

class ShareFailure extends ShareState {
  final String message;

  ShareFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ShareSuccess extends ShareState {
  ShareSuccess();
  @override
  List<Object?> get props => [];
}

// бараа шилжүүлэг
class ShareHistoryLoading extends ShareState {
  @override
  List<Object?> get props => [];
}

class ShareHistoryFailure extends ShareState {
  final String message;

  ShareHistoryFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ShareHistorySuccess extends ShareState {
  final List<TransferItem>? data;
  final bool hasMoreOrder;
  ShareHistorySuccess(this.data, this.hasMoreOrder);
  @override
  List<Object?> get props => [data];
}

// бараа шилжүүлэг үндсэн өгөгдөл
class ShareProductDataLoading extends ShareState {
  @override
  List<Object?> get props => [];
}

class ShareProductDataFailure extends ShareState {
  final String message;

  ShareProductDataFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ShareProductDataSuccess extends ShareState {
  final List<ProductDetialModel> data;
  final bool hasMoreOrder;
  ShareProductDataSuccess(this.data, this.hasMoreOrder);
  @override
  List<Object?> get props => [data, hasMoreOrder];
}
