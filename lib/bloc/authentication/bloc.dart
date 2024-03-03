import 'dart:convert';

import 'package:black_book/models/login/authentication.dart';
import 'package:black_book/models/user_data/user_data_response.dart';
import 'package:black_book/service/api.dart';
import 'package:black_book/util/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event.dart';
import 'state.dart';

class AuthenticationBloc extends Bloc<UserEvent, UserState> {
  AuthenticationBloc() : super(UserInitial()) {
    on<UserLoginEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final apiService = ApiService();
        var body = {
          "phoneNumber": event.phoneNumber,
          "countryCode": "976",
          "deviceToken": event.deviceToken,
          "deviceType": event.deviceType
        };
        print(body);
        Response response =
            await apiService.postRequest('/v1/auth/login', body: body);
        AuthenticationResponseModel dataResponse =
            AuthenticationResponseModel.fromJson(response.data);
        print(" this is data = ${response.data}");
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(UserSuccess());
        } else {
          if (dataResponse.message.show) {
            emit(UserFailure(dataResponse.message.text!));
          } else {
            emit(UserFailure(""));
          }
        }
      } catch (ex) {
        print("aldaa = ${ex}");
        emit(UserFailure(ex.toString()));
      }
    });
    on<UserAuthenticationEvent>((event, emit) async {
      emit(UserAuthenticationLoading());
      try {
        final apiService = ApiService();
        var body = {
          "phoneNumber": event.phoneNumber,
          "countryCode": "976",
          "deviceToken": event.deviceToken,
          "deviceType": event.deviceType,
          "otpCode": event.otpCode
        };
        print(body);
        Response response =
            await apiService.postRequest('/v1/auth/otp/check', body: body);
        UserDataResponseModel dataResponse =
            UserDataResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(UserAuthenticationSuccess(dataResponse.data!));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(UserAuthenticationFailure(dataResponse.message.text!));
        } else {
          emit(UserAuthenticationFailure(""));
        }
        final prefs = await SharedPreferences
            .getInstance(); //TODO mash chuhal ene heseg tolbor tolson uyd hadgalna
        prefs.setString("userInfo", jsonEncode(dataResponse.data));
        Utils.getCommonProvider().setUserInfo(dataResponse.data!);
        // ignore: deprecated_member_use
      } on DioError catch (ex) {
        if (ex.response!.statusCode == 500) {
          emit(UserAuthenticationFailure("Серверийн алдаа"));
        } else {
          emit(UserAuthenticationFailure(ex.toString()));
        }
      }
    });
    // on<UserLoginEvent>((event, emit) async {
    //   emit(UserLoading());
    //   try {
    //     final apiService = ApiService();
    //     var body = {};

    //     Response response = await apiService.getRequest('/api/getUserData');
    //     print(response.data);
    //     print("object");
    //     emit(UserSuccess());
    //   } catch (ex) {
    //     print("this ex = ${ex.toString()}");
    //     emit(UserFailure(ex.toString()));
    //   }
    // });
    //  on<InterruptedGoodsEvent>((event, emit) async {
    //   emit(InterruptedGoodsLoading());
    //   try {
    //     String locationKey =
    //         Utils.getUserProvider().location?.locationKey ?? '';
    //     String userKey = Utils.getUserProvider().userInfo?.userkey ?? '';
    //     final apiService = ApiService();
    //     var body = {
    //       "latitude": "47.8963126",
    //       "searchValue": "",
    //       "userKey": "230118412885200570",
    //       "page": 0,
    //       "longitude": "106.8889575",
    //       "locationKey": "220429027174500000",
    //       "deviceId": ""
    //     };
    //     Response response =
    //         await apiService.postRequest('/order/getAllItemList', body: body);
    // print("---------hELLO -------" "${response}");

    // InterruptedResponse reportDatas =
    //     InterruptedResponse.fromJson(response.data);
    // bool hasMoreOrder = true;
    //   if (reportDatas.list.length < 20) hasMoreOrder = false;
    //   emit(InterruptedGoodsSuccess(
    //       interruptedGoodsList: reportDatas.list, hasMoreItem: hasMoreOrder));
    // } catch (ex) {
    //   emit(InterruptedGoodsFailure(ex.toString()));
    // }
    // });
  }
}
