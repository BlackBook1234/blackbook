import 'dart:convert';
import 'dart:io';
import 'package:black_book/models/user_data/user_data_response.dart';
import 'package:black_book/service/api.dart';
import 'package:black_book/util/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event.dart';
import 'state.dart';

class RefreshBloc extends Bloc<RefreshEvent, RefreshTokenState> {
  RefreshBloc() : super(RefreshInitial()) {
    on<RefreshTokenEvent>((event, emit) async {
      emit(RefreshLoading());
      try {
        String refreshToken = Utils.getRefreshToken();
        final apiService = ApiService();
        String deviceType = "";
        String deviceToken = "";
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          AndroidDeviceInfo info = await deviceInfo.androidInfo;
          deviceType = "android";
          deviceToken = info.model;
        } else if (Platform.isIOS) {
          IosDeviceInfo info = await deviceInfo.iosInfo;
          deviceType = "iOS";
          deviceToken = info.name;
        } else {
          deviceType = "huawei";
          deviceToken = "huawei";
        }
        print(refreshToken);
        var body = {
          "deviceToken": deviceToken,
          "deviceType": deviceType,
          "refreshToken": refreshToken
        };
        print(body);
        Response response =
            await apiService.postRequest('/v1/auth/refresh', body: body);
        UserDataResponseModel dataResponse =
            UserDataResponseModel.fromJson(response.data);
        print("reponse = ${response}");
        if (response.statusCode == 200 && dataResponse.status == "success") {
          Utils.getCommonProvider().setUserInfo(dataResponse.data!);
          final prefs = await SharedPreferences.getInstance();
          prefs.remove("userInfo");
          prefs.setString("userInfo", jsonEncode(dataResponse.data));
          emit(RefreshSuccess());
        } else if (dataResponse.status == "error") {
          emit(RefreshFailure(dataResponse.message.text!));
        } else {
          emit(RefreshFailure(""));
        }
      } catch (ex) {
        print("object = $ex");
        emit(RefreshFailure(ex.toString()));
      }
    });
  }
}
