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
      mustUpdate,
      type;
  int? active,
      userId,
      isWarehouse,
      tenantId,
      countryCode,
      isAdmin,
      storeId,
      isPaid;

  UserDataModel(
      {this.accessToken,
      this.storeName,
      this.firstName,
      this.countryCode,
      this.active,
      this.avatar,
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
      this.tenantName});
  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);
}
