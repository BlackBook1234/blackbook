import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserDataModel {
  String? accessToken,
      storeName,
      avatar,
      deviceType,
      email,
      firstName,
      lastName,
      phone,
      position,
      refreshToken,
      tenantName,
      paymentExpireDate,
      mustUpdate,
      // ignore: non_constant_identifier_names
      payment_end_date,
      type;
  int? active,
      userId,
      isWarehouse,
      tenantId,
      countryCode,
      isAdmin,
      storeId,
      isPaid;
      bool? isRegistration;

  UserDataModel(
      {this.accessToken,
      this.storeName,
      this.firstName,
      this.countryCode,
      this.active,
      this.avatar,
      this.paymentExpireDate,
      this.email,
      this.mustUpdate,
      this.isPaid,
      this.lastName,
      this.phone,
      this.position,
      this.type,
      this.userId,
      this.deviceType,
      this.isAdmin,
      this.storeId,
      this.refreshToken,
      this.tenantId,
      this.isRegistration,
      // ignore: non_constant_identifier_names
      this.payment_end_date,
      this.tenantName});
  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);
}
