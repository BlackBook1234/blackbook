import 'package:black_book/models/otp/product_share.dart';
import 'package:equatable/equatable.dart';

abstract class ShareEvent extends Equatable {
  const ShareEvent();

  @override
  List<Object> get props => [];
}

// бараа шилжүүлэг
class CreateShareEvent extends ShareEvent {
  final int storeId;
  final List<ProductShareOtp> detialList;

  const CreateShareEvent(this.storeId, this.detialList);

  @override
  List<Object> get props => [storeId, detialList];
}

// бараа шилжүүлэгийн түүх
class ShareHistoryEvent extends ShareEvent {
  final DateTime beginDate, endDate;
  final String storeId;
  final bool searchAgian;
  final int page;
  final String sourceId;
  const ShareHistoryEvent(
      this.beginDate, this.endDate, this.searchAgian, this.storeId, this.page,this.sourceId);
  @override
  List<Object> get props => [];
}

// барааны үндсэн өгөгдөл түүх
class ShareProductDataEvent extends ShareEvent {
  final int page;
  final bool searchAgian;
  final String chosenValue, searchValue;
  const ShareProductDataEvent(
      this.page, this.searchAgian, this.chosenValue, this.searchValue);
  @override
  List<Object> get props => [searchAgian, page, searchValue, chosenValue];
}
