import 'package:equatable/equatable.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

// дэлгүүр шинээр үүсгэх
class CreateStoreEvent extends StoreEvent {
  final String storeName;
  final int phoneNumber;

  const CreateStoreEvent(this.storeName, this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber, storeName];
}

//Дэлгүүрийн мэдээлэл авах

class GetStoreEvent extends StoreEvent {
  const GetStoreEvent();
  @override
  List<Object> get props => [];
}
//Дэлгүүрийн бараа авах

class GetStoreProductEvent extends StoreEvent {
  final int page;
  final bool searchAgian;
  final String chosenValue, chosenType, searchValue;
  const GetStoreProductEvent(this.page, this.searchAgian, this.chosenType,
      this.chosenValue, this.searchValue);
  @override
  List<Object> get props =>
      [searchAgian, chosenType, chosenType, searchValue, page];
}
