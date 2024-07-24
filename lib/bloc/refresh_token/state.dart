import 'package:equatable/equatable.dart';

abstract class RefreshTokenState extends Equatable {}

class RefreshInitial extends RefreshTokenState {
  @override
  List<Object?> get props => [];
}

class RefreshLoading extends RefreshTokenState {
  @override
  List<Object?> get props => [];
}

class RefreshFailure extends RefreshTokenState {
  final String message;

  RefreshFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class RefreshSuccess extends RefreshTokenState {
  RefreshSuccess();
  @override
  List<Object?> get props => [];
}
