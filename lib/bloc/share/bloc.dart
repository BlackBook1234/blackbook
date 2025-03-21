import 'package:black_book/bloc/refresh_token/bloc.dart';
import 'package:black_book/bloc/refresh_token/event.dart';
import 'package:black_book/models/login/authentication.dart';
import 'package:black_book/models/product/response.dart';
import 'package:black_book/models/transfer/response.dart';
import 'package:black_book/service/api.dart';
import 'package:black_book/util/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'event.dart';
import 'state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc() : super(ShareInitial()) {
    on<CreateShareEvent>((event, emit) async {
      emit(ShareLoading());
      try {
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        Map<String, Object> body;
        Response response;
        if (Utils.getUserRole() == "BOSS") {
          body = {
            "products": event.detialList.map((e) => e.toJson()).toList(),
            "toStoreId": event.storeId
          };
          response = await apiService
              .postRequest('/v1/product/transfer/warehouse2store', body: body);
        } else {
          if (event.storeId != 0) {
            body = {
              "products": event.detialList.map((e) => e.toJson()).toList(),
              "toStoreId": event.storeId,
              "fromStoreId": Utils.getStoreId()
            };
            response = await apiService
                .postRequest('/v1/product/transfer/store2store', body: body);
          } else {
            body = {
              "products": event.detialList.map((e) => e.toJson()).toList(),
              "fromStoreId": Utils.getStoreId()
            };
            response = await apiService
                .postRequest('/v1/product/transfer/return', body: body);
          }
        }

        AuthenticationResponseModel dataResponse =
            AuthenticationResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(ShareSuccess());
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(ShareFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(ShareFailure(dataResponse.message.text!));
        } else {
          emit(ShareFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(ShareFailure("Серверийн алдаа"));
      }
    });
    on<ShareHistoryEvent>((event, emit) async {
      emit(ShareHistoryLoading());
      try {
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        String path = "";
        if (event.sourceId == '') {
          if (Utils.getUserRole() == "BOSS") {
            if (event.searchAgian) {
              if (event.storeId == "") {
                path = "/v1/product/transfer/list?sort=desc&page=1&limit=20";
              } else {
                // path =
                // "/v1/product/transfer/list?page=${event.page}&sort=desc&limit=100&q=${event.searchValue}";
              }
            } else {
              path =
                  '/v1/product/transfer/list?page=${event.page}&is_warehouse=1&limit=100&sort=desc';
            }
          } else {
            if (event.searchAgian) {
              // path =
              //     '/v1/product/transfer/list?limit=100&store_id=${Utils.getStoreId()}&page=${event.page}&sort=desc&q=${event.searchValue}';
            } else {
              path =
                  '/v1/product/transfer/list?limit=100&store_id=${Utils.getStoreId()}&page=${event.page}&sort=desc';
            }
          }
        } else {
          path =
              '/v1/product/transfer/list?limit=100&page=${event.page}&sort=desc&tid=${event.sourceId}';
        }

        Response response = await apiService.getRequest(path);
        TransferDataResponse dataResponse =
            TransferDataResponse.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          bool hasMoreOrder = true;
          if (dataResponse.data!.length < 40) {
            hasMoreOrder = false;
          }
          emit(ShareHistorySuccess(dataResponse.data!, hasMoreOrder));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(ShareHistoryFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(ShareHistoryFailure(dataResponse.message.text!));
        } else {
          emit(ShareHistoryFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(ShareHistoryFailure("Серверийн алдаа"));
      }
    });
    on<ShareProductDataEvent>((event, emit) async {
      emit(ShareProductDataLoading());
      try {
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        String path = "";
        if (Utils.getUserRole() == "BOSS") {
          if (event.searchAgian) {
            path =
                "/v1/product/my/list?page=${event.page}&sort=desc&limit=100&q=${event.searchValue}&category_id=${event.chosenValue}&is_warehouse=1";
          } else {
            path =
                '/v1/product/my/list?page=${event.page}&is_warehouse=1&limit=100&sort=desc';
          }
        } else {
          if (event.searchAgian) {
            path =
                '/v1/product/my/list?limit=100&store_id=${Utils.getStoreId()}&page=${event.page}&sort=desc&q=${event.searchValue}&category_id=${event.chosenValue}';
          } else {
            path =
                '/v1/product/my/list?limit=100&store_id=${Utils.getStoreId()}&page=${event.page}&sort=desc';
          }
        }
        Response response = await apiService.getRequest(path);
        ProductResponseModel dataResponse =
            ProductResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          bool hasMoreOrder = true;
          if (dataResponse.data!.length < 40) {
            hasMoreOrder = false;
          }
          emit(ShareProductDataSuccess(dataResponse.data!, hasMoreOrder,dataResponse.categories!));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(ShareProductDataFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(ShareProductDataFailure(dataResponse.message.text!));
        } else {
          emit(ShareProductDataFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(ShareProductDataFailure("Серверийн алдаа"));
      }
    });
  }
}
