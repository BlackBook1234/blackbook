import 'package:black_book/bloc/refresh_token/bloc.dart';
import 'package:black_book/bloc/refresh_token/event.dart';
import 'package:black_book/models/login/authentication.dart';
import 'package:black_book/models/product/response.dart';
import 'package:black_book/models/store/store_response.dart';
import 'package:black_book/service/api.dart';
import 'package:black_book/util/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'event.dart';
import 'state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreInitial()) {
    on<CreateStoreEvent>((event, emit) async {
      emit(StoreLoading());
      try {
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        var body = {
          "name": event.storeName,
          "phoneNumber": event.phoneNumber,
          "countryCode": "976"
        };
        Response response =
            await apiService.postRequest('/v1/store/create', body: body);
        AuthenticationResponseModel dataResponse =
            AuthenticationResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(StoreSuccess());
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(StoreFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(StoreFailure(dataResponse.message.text!));
        } else {
          emit(StoreFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(StoreFailure("Серверийн алдаа"));
      }
    });
    on<GetStoreEvent>((event, emit) async {
      emit(GetStoreLoading());
      try {
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        Response response = await apiService.getRequest('/v1/store/my/list');
        StoreResponseModel dataResponse =
            StoreResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(GetStoreSuccess(dataResponse.data!));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(GetStoreFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(GetStoreFailure(dataResponse.message.text!));
        } else {
          emit(GetStoreFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(GetStoreFailure("Серверийн алдаа"));
      }
    });
    on<GetStoreProductEvent>((event, emit) async {
      emit(GetStoreProductLoading());
      try {
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        String path = "";
        if (event.searchAgian) {
          if (event.chosenType == "-1") {
            path =
                '/v1/product/store/list?page=${event.page}&limit=1000&is_warehouse=1&q=${event.searchValue}&category_id=${event.chosenValue}&sort=desc';
          } else {
            path =
                '/v1/product/store/list?page=${event.page}&limit=1000&sort=desc&q=${event.searchValue}&category_id=${event.chosenValue}&store_id=${event.chosenType}';
          }
        } else {
          path =
              '/v1/product/store/list?page=${event.page}&limit=1000&is_warehouse=1';
        }
        Response response = await apiService.getRequest(path);
        ProductResponseModel dataResponse =
            ProductResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          bool hasMoreOrder = true;
          if (dataResponse.data!.length < 40) {
            hasMoreOrder = false;
          }
          emit(GetStoreProductSuccess(dataResponse.data!, dataResponse.amount!,
              dataResponse.stores!, hasMoreOrder, dataResponse.categories!));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(GetStoreProductFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(GetStoreProductFailure(dataResponse.message.text!));
        } else {
          emit(GetStoreProductFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(GetStoreProductFailure("Серверийн алдаа"));
      }
    });
  }
}
