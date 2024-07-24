import 'package:equatable/equatable.dart';

abstract class RemoveState extends Equatable {}

class RemoveInitial extends RemoveState {
  @override
  List<Object?> get props => [];
}

// бараа зарах
class RemoveLoading extends RemoveState {
  @override
  List<Object?> get props => [];
}

class RemoveFailure extends RemoveState {
  final String message;

  RemoveFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class RemoveSuccess extends RemoveState {
  RemoveSuccess();
  @override
  List<Object?> get props => [];
}
