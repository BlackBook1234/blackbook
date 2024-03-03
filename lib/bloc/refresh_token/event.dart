import 'package:equatable/equatable.dart';

abstract class RefreshEvent extends Equatable {
  const RefreshEvent();

  @override
  List<Object> get props => [];
}

// шинээр токен авах
class RefreshTokenEvent extends RefreshEvent {
  const RefreshTokenEvent();
  @override
  List<Object> get props => [];
}
