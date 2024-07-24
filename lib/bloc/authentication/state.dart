import 'package:black_book/models/user_data/user_data.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {}

class UserInitial extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserFailure extends UserState {
  final String message;

  UserFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class UserSuccess extends UserState {
  UserSuccess();
  @override
  List<Object?> get props => [];
}
//UserAuthenticationEvent

class UserAuthenticationLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserAuthenticationFailure extends UserState {
  final String message;

  UserAuthenticationFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class UserAuthenticationSuccess extends UserState {
  final UserDataModel data;
  UserAuthenticationSuccess(this.data);
  @override
  List<Object?> get props => [];
}

//chnage user
class ChangeUserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class ChangeUserFailure extends UserState {
  final String message;

  ChangeUserFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ChangeUserSuccess extends UserState {
  ChangeUserSuccess();
  @override
  List<Object?> get props => [];
}
