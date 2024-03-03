import 'package:equatable/equatable.dart';

abstract class RemoveEvent extends Equatable {
  const RemoveEvent();

  @override
  List<Object> get props => [];
}

class RemoveProductEvent extends RemoveEvent {
  final String goodId;
  const RemoveProductEvent(this.goodId);

  @override
  List<Object> get props => [goodId];
}

