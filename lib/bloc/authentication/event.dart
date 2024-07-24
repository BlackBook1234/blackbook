import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserLoginEvent extends UserEvent {
  final String deviceToken, deviceType;
  final int phoneNumber;

  const UserLoginEvent(this.deviceType, this.deviceToken, this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber, deviceToken, deviceType];
}

class UserAuthenticationEvent extends UserEvent {
  final String deviceToken, deviceType, otpCode;
  final int phoneNumber;

  const UserAuthenticationEvent(
      this.deviceType, this.deviceToken, this.phoneNumber, this.otpCode);

  @override
  List<Object> get props => [phoneNumber, deviceToken, deviceType, otpCode];
}

class ChangeUserEvent extends UserEvent {
  final String phoneNumber;
  final int storeId;

  const ChangeUserEvent(this.storeId, this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber, storeId];
}
