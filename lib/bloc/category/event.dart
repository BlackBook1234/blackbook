import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

// Ангилал шинээр үүсгэх
class CreateCategoryEvent extends CategoryEvent {
  final String name, parent;

  const CreateCategoryEvent(this.name, this.parent);

  @override
  List<Object> get props => [name, parent];
}

//Ангилал мэдээлэл авах

class GetCategoryEvent extends CategoryEvent {
  final String type;
  const GetCategoryEvent(this.type);
  @override
  List<Object> get props => [type];
}
