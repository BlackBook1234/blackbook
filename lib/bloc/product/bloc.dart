import 'package:black_book/bloc/refresh_token/bloc.dart';
import 'package:black_book/bloc/refresh_token/event.dart';
import 'package:black_book/models/login/authentication.dart';
import 'package:black_book/models/product/response.dart';
import 'package:black_book/service/api.dart';
import 'package:black_book/util/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'event.dart';
import 'state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<CreateProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final apiService = ApiTokenService(Utils.getToken());
        var body = {
          "name": event.name,
          "code": event.code,
          "categoryId": event.categoryId,
          "photoUrl": event.url,
          "sizes": event.sizes.map((e) => e.toJson()).toList()
        };
        Response response =
            await apiService.postRequest('/v1/product/create', body: body);
        AuthenticationResponseModel dataResponse =
            AuthenticationResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(ProductSuccess());
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(ProductFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(ProductFailure(dataResponse.message.text!));
        } else {
          emit(ProductFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(ProductFailure("Серверийн алдаа"));
      }
    });

    on<GetProductEvent>((event, emit) async {
      emit(GetProductLoading());
      try {
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        String path = "";
        if (Utils.getUserRole() == "BOSS") {
          if (event.searchAgian) {
            if (event.chosenType == "-1") {
              path =
                  "/v1/product/my/list?page=${event.page}&sort=desc&limit=100&q=${event.searchValue}&category_id=${event.chosenValue}&is_warehouse=1";
            } else {
              path =
                  "/v1/product/my/list?page=${event.page}&sort=desc&limit=100&q=${event.searchValue}&category_id=${event.chosenValue}&store_id=${event.chosenType}";
            }
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
          emit(GetProductSuccess(
              dataResponse.data!, dataResponse.stores!, hasMoreOrder));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(GetProductFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(GetProductFailure(dataResponse.message.text!));
        } else {
          emit(GetProductFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(GetProductFailure("Серверийн алдаа"));
      }
    });
    on<GetStoreItemEvent>((event, emit) async {
      emit(GetStoreItemLoading());
      try {
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        String path = "";
        if (event.searchAgian) {
          path =
              '/v1/product/store/list?page=${event.page}&limit=100&store_id=${event.id}&sort=desc&category_id=${event.chosenValue}&q=${event.searchValue}';
        } else {
          path =
              '/v1/product/store/list?page=${event.page}&limit=100&store_id=${event.id}&sort=desc';
        }
        Response response = await apiService.getRequest(path);
        ProductResponseModel dataResponse =
            ProductResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          bool hasMoreOrder = true;
          if (dataResponse.data!.length < 40) {
            hasMoreOrder = false;
          }
          emit(GetStoreItemSuccess(dataResponse.data!, hasMoreOrder));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(GetStoreItemFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(GetStoreItemFailure(dataResponse.message.text!));
        } else {
          emit(GetStoreItemFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(GetStoreItemFailure("Серверийн алдаа"));
      }
    });
    on<GetProductSearchEvent>((event, emit) async {
      emit(GetProductLoading());
      try {
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        String path = "";
        if (event.searchAgian) {
          if (event.chosenType == "-1") {
            path =
                '/v1/product/my/list?page=${event.page}&limit=100&q=${event.searchValue}&category_id=${event.chosenValue}&sort=desc&is_warehouse=1';
          } else {
            if (event.chosenType == "") {
              path =
                  '/v1/product/my/list?page=${event.page}&limit=100&q=${event.searchValue}&category_id=${event.chosenValue}&sort=desc';
            } else {
              path =
                  '/v1/product/my/list?page=${event.page}&limit=100&q=${event.searchValue}&category_id=${event.chosenValue}&store_id=${event.chosenType}&sort=desc';
            }
          }
        } else {
          path = '/v1/product/my/list?page=${event.page}&limit=100&sort=desc';
        }
        Response response = await apiService.getRequest(path);
        ProductResponseModel dataResponse =
            ProductResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          bool hasMoreOrder = true;
          if (dataResponse.data!.length < 40) {
            hasMoreOrder = false;
          }
          emit(GetProductSuccess(
              dataResponse.data!, dataResponse.stores!, hasMoreOrder));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(GetProductFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(GetProductFailure(dataResponse.message.text!));
        } else {
          emit(GetProductFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(GetProductFailure("Серверийн алдаа"));
      }
    });

    on<PurchaseProduct>((event, emit) async {
      emit(PurchaseProductLoading());
      try {
        final apiService = ApiTokenService(Utils.getToken());
        var body = {
          "sizes": event.sizes.map((e) => e.toJson()).toList(),
          "good_id": event.good_id
        };
        print("---$body");
        Response response =
            await apiService.postRequest('/v1/product/add', body: body);
        AuthenticationResponseModel dataResponse =
            AuthenticationResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(PurchaseProductSuccess());
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(PurchaseProductFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(PurchaseProductFailure(dataResponse.message.text!));
        } else {
          emit(PurchaseProductFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(PurchaseProductFailure("Серверийн алдаа"));
      }
    });
  }
}
