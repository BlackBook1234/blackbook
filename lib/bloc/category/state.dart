import 'package:black_book/models/category/category_detial.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {}

class CategoryInitial extends CategoryState {
  @override
  List<Object?> get props => [];
}

// төрөл шинээр үүсгэх
class CategoryLoading extends CategoryState {
  @override
  List<Object?> get props => [];
}

class CategoryFailure extends CategoryState {
  final String message;

  CategoryFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class CategorySuccess extends CategoryState {
  CategorySuccess();
  @override
  List<Object?> get props => [];
}

//Төрөл мэдээлэл авах

class GetCategoryLoading extends CategoryState {
  @override
  List<Object?> get props => [];
}

class GetCategoryFailure extends CategoryState {
  final String message;

  GetCategoryFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class GetCategorySuccess extends CategoryState {
  final List<CategoryDetialModel> list;
  GetCategorySuccess(this.list);
  @override
  List<Object?> get props => [list];
}
