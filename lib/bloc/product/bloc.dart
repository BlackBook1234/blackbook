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
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        print(accessToken);
        var body = {
          "name": event.name,
          "code": event.code,
          "categoryId": event.categoryId,
          "photoUrl": event.url,
          "sizes": event.sizes.map((e) => e.toJson()).toList()
        };
        print(body);
        Response response =
            await apiService.postRequest('/v1/product/create', body: body);
        AuthenticationResponseModel dataResponse =
            AuthenticationResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(ProductSuccess());
        } else if (dataResponse.status == "error") {
          emit(ProductFailure(dataResponse.message.text!));
        } else {
          emit(ProductFailure(""));
        }
      } catch (ex) {
        if (ex.toString() ==
            "DioException [bad response]: The request returned an invalid status code of 403.") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(ProductFailure("Token"));
        }
        emit(ProductFailure("Серверийн алдаа"));
      }
    });
    on<GetProductEvent>((event, emit) async {
      emit(GetProductLoading());
      try {
        String accessToken = Utils.getToken();
        print(" this is product token = $accessToken");
        final apiService = ApiTokenService(accessToken);
        String path = "";
        if (Utils.getUserRole() == "BOSS") {
          if (event.searchAgian) {
            if (event.chosenType == "") {
              path =
                  "/v1/product/my/list?page=${event.page}&sort=desc&limit=40&q=${event.searchValue}&parent_category=${event.chosenValue}&is_warehouse=1";
            } else {
              path =
                  "/v1/product/my/list?page=${event.page}&sort=desc&limit=40&q=${event.searchValue}&parent_category=${event.chosenValue}&store_id=${event.chosenType}";
            }
          } else {
            path =
                '/v1/product/my/list?page=${event.page}&is_warehouse=1&limit=40&sort=desc';
          }
        } else {
          if (event.searchAgian) {
            path =
                '/v1/product/my/list?limit=40&store_id=${Utils.getStoreId()}&page=${event.page}&sort=desc&q=${event.searchValue}&parent_category=${event.chosenValue}';
          } else {
            path =
                '/v1/product/my/list?limit=40&store_id=${Utils.getStoreId()}&page=${event.page}&sort=desc';
          }
        }
        print(path);
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
        } else if (dataResponse.message.show) {
          emit(GetProductFailure(dataResponse.message.text!));
        } else {
          emit(GetProductFailure(""));
        }
      } catch (ex) {
        if (ex.toString() ==
            "DioException [bad response]: The request returned an invalid status code of 403.") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(GetProductFailure("Token"));
        } else {
          print(ex);
          emit(GetProductFailure("Серверийн алдаа"));
        }
      }
    });
    on<GetStoreItemEvent>((event, emit) async {
      emit(GetStoreItemLoading());
      try {
        String accessToken = Utils.getToken();
        print(" this is product token = $accessToken");
        final apiService = ApiTokenService(accessToken);
        Response response = await apiService.getRequest(
            '/v1/product/store/list?page=1&limit=40&store_id=${event.id}&sort=desc');
        print(response);
        ProductResponseModel dataResponse =
            ProductResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(GetStoreItemSuccess(dataResponse.data!));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(GetStoreItemFailure(dataResponse.message.text!));
        } else {
          emit(GetStoreItemFailure(""));
        }
      } catch (ex) {
        if (ex.toString() ==
            "DioException [bad response]: The request returned an invalid status code of 403.") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(GetStoreItemFailure("Token"));
        } else {
          emit(GetStoreItemFailure("Серверийн алдаа"));
        }
      }
    });
    on<GetProductSearchEvent>((event, emit) async {
      emit(GetProductLoading());
      try {
        String accessToken = Utils.getToken();
        print(" this is product token = $accessToken");
        final apiService = ApiTokenService(accessToken);
        String path = "";
        if (event.searchAgian) {
          if (event.chosenType == "") {
            path =
                '/v1/product/my/list?page=${event.page}&limit=40&q=${event.searchValue}&parent_category=${event.chosenValue}&is_warehouse=1&sort=desc';
          } else {
            path =
                '/v1/product/my/list?page=${event.page}&limit=40&q=${event.searchValue}&parent_category=${event.chosenValue}&store_id=${event.chosenType}&sort=desc';
          }
        } else {
          path =
              '/v1/product/my/list?page=${event.page}&is_warehouse=1&limit=40&sort=desc';
        }
        print(path);
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
            dataResponse.message.show) {
          emit(GetProductFailure(dataResponse.message.text!));
        } else {
          emit(GetProductFailure(""));
        }
      } catch (ex) {
        if (ex.toString() ==
            "DioException [bad response]: The request returned an invalid status code of 403.") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(GetProductFailure("Token"));
        } else {
          print(ex);
          emit(GetProductFailure("Серверийн алдаа"));
        }
      }
    });
  }
}
