import 'dart:convert';

import 'package:black_book/bloc/refresh_token/bloc.dart';
import 'package:black_book/bloc/refresh_token/event.dart';
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
          if (dataResponse.message.show && dataResponse.status == "error") {
            emit(UserFailure(dataResponse.message.text!));
          } else {
            emit(UserFailure("Серверийн алдаа"));
          }
        }
      } catch (ex) {
        emit(UserFailure("Серверийн алдаа"));
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
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("userInfo", jsonEncode(dataResponse.data));
          Utils.getCommonProvider().setUserInfo(dataResponse.data!);
          emit(UserAuthenticationSuccess(dataResponse.data!));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(UserAuthenticationFailure(dataResponse.message.text!));
        } else {
          emit(UserAuthenticationFailure(""));
        }
      } catch (ex) {
        print(ex.toString());
        emit(UserAuthenticationFailure("Серверийн алдаа"));
      }
    });
    on<ChangeUserEvent>((event, emit) async {
      emit(ChangeUserLoading());
      try {
        final apiService = ApiTokenService(Utils.getToken());
        var body = {
          "storeId": event.storeId,
          "phoneNumber": event.phoneNumber,
          "countryCode": "976"
        };
        print(body);
        Response response =
            await apiService.postRequest('/v1/store/change/phone', body: body);
        print("this reponse  = ${response.data}");
        UserDataResponseModel dataResponse =
            UserDataResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(ChangeUserSuccess());
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(ChangeUserFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(ChangeUserFailure(dataResponse.message.text!));
        } else {
          emit(ChangeUserFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        print(ex);
        emit(ChangeUserFailure("Серверийн алдаа"));
      }
    });
  }
}
