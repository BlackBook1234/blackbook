import 'package:black_book/models/default/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

// бараа шинээр үүсгэх
class CreateProductEvent extends ProductEvent {
  final String name, code, url;
  final int categoryId;
  final List<ProductDefaultModel> sizes;

  const CreateProductEvent(
      this.name, this.code, this.categoryId, this.sizes, this.url);

  @override
  List<Object> get props => [name, code, sizes, url];
}

//бараа мэдээлэл авах
class GetProductEvent extends ProductEvent {
  final int page;
  final bool searchAgian;
  final String chosenValue, chosenType, searchValue;
  const GetProductEvent(this.page, this.searchAgian, this.chosenType,
      this.chosenValue, this.searchValue);
  @override
  List<Object> get props => [searchAgian, chosenType, chosenType, searchValue];
}

//дэлгүүрийн барааны мэдээлэл авах
class GetStoreItemEvent extends ProductEvent {
  const GetStoreItemEvent(
      this.id, this.chosenValue, this.page, this.searchAgian, this.searchValue);
  final int id;
  final int page;
  final bool searchAgian;
  final String chosenValue, searchValue;
  @override
  List<Object> get props => [id];
}

//Бүх бараа search screen
class GetProductSearchEvent extends ProductEvent {
  final int page;
  final bool searchAgian;
  final String chosenValue, chosenType, searchValue;
  const GetProductSearchEvent(this.page, this.searchAgian, this.chosenType,
      this.chosenValue, this.searchValue);
  @override
  List<Object> get props =>
      [page, searchAgian, chosenType, chosenType, searchValue];
}
