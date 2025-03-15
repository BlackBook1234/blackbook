import 'package:black_book/bloc/refresh_token/bloc.dart';
import 'package:black_book/bloc/refresh_token/event.dart';
import 'package:black_book/models/login/authentication.dart';
import 'package:black_book/models/product/product_inlist.dart';
import 'package:black_book/models/sale/sale_response.dart';
import 'package:black_book/models/sale_product/product_response.dart';
import 'package:black_book/service/api.dart';
import 'package:black_book/util/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'event.dart';
import 'state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  SaleBloc() : super(SaleInitial()) {
    on<CreateSaleEvent>((event, emit) async {
      emit(SaleLoading());
      try {
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        List<dynamic> otpList = [];
        for (ProductInDetialModel data in event.list) {
          var otpBody = {
            "id": data.id,
            "cost": data.cost,
            "price": data.price,
            "stock": data.ware_stock,
            "moneyType": event.moneyType
          };
          otpList.add(otpBody);
        }
        Map<String, Object> body;
        if (Utils.getUserRole() == "BOSS") {
          body = {"products": otpList.toList()};
        } else {
          body = {"storeId": Utils.getStoreId(), "products": otpList.toList()};
        }
        Response response =
            await apiService.postRequest('/v1/product/sale', body: body);
        AuthenticationResponseModel dataResponse =
            AuthenticationResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(SaleSuccess());
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(SaleFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(SaleFailure(dataResponse.message.reason!));
        } else {
          emit(SaleFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(SaleFailure("Серверийн алдаа"));
      }
    });
    on<GetSaleEvent>((event, emit) async {
      emit(GetSaleLoading());
      try {
        final apiService = ApiTokenService(Utils.getToken());
        String path = "";
        if (Utils.getUserRole() == "BOSS") {
          if (event.searchAgian) {
            if (event.storeId == -1) {
              path =
                  "/v1/product/sale/list/warehouse?sort=asc&page=${event.page}&limit=100&q=${event.searchValue}&from_date=${formatDateTime(event.begindate)}&to_date=${formatDateTime(event.endDate)}";
            } else {
              path =
                  "/v1/product/sale/list/store/${event.storeId}?sort=asc&page=${event.page}&limit=100&store_id=${event.storeId}&q=${event.searchValue}&from_date=${formatDateTime(event.begindate)}&to_date=${formatDateTime(event.endDate)}";
            }
          } else {
            if (event.storeId == -1) {
              path =
                  "/v1/product/sale/list/warehouse?sort=asc&page=${event.page}&limit=100&q=${event.searchValue}&from_date=${formatDateTime(event.begindate)}&to_date=${formatDateTime(event.endDate)}";
            } else {
              path =
                  "/v1/product/sale/list/store/${event.storeId}?sort=asc&page=${event.page}&limit=100&store_id=${event.storeId}&q=${event.searchValue}&from_date=${formatDateTime(event.begindate)}&to_date=${formatDateTime(event.endDate)}";
            }
          }
        } else {
          if (event.searchAgian) {
            if (event.storeId == -1) {
              path =
                  "/v1/product/sale/list/warehouse?sort=asc&page=${event.page}&limit=100&q=${event.searchValue}&from_date=${formatDateTime(event.begindate)}&to_date=${formatDateTime(event.endDate)}";
            } else {
              path =
                  "/v1/product/sale/list/store/${event.storeId}?sort=asc&page=${event.page}&limit=100&store_id=${event.storeId}&q=${event.searchValue}&from_date=${formatDateTime(event.begindate)}&to_date=${formatDateTime(event.endDate)}";
            }
          } else {
            path =
                "/v1/product/sale/list/store/${event.storeId}?sort=asc&page=${event.page}&limit=100&store_id=${event.storeId}&from_date=${formatDateTime(event.begindate)}&to_date=${formatDateTime(event.endDate)}";
          }
        }
        Response response = await apiService.getRequest(path);
        SaleProductResponseModel dataResponse =
            SaleProductResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          bool hasMoreOrder = true;
          if (dataResponse.data!.list!.length < 40) {
            hasMoreOrder = false;
          }
          emit(GetSaleSuccess(dataResponse.data!.list!,
              dataResponse.data!.total!, hasMoreOrder));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(GetSaleFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(GetSaleFailure(dataResponse.message.text!));
        } else {
          emit(GetSaleFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(GetSaleFailure("Серверийн алдаа"));
      }
    });
    on<GetMainSaleEvent>((event, emit) async {
      emit(GetMainSaleLoading());
      try {
        final apiService = ApiTokenService(Utils.getToken());
        String path = "";
        if (Utils.getUserRole() == "BOSS") {
          if (event.searchAgian) {
            if (event.storeId == "-1") {
              path =
                  "/v1/product/sale/list?sort=desc&page=${event.page}&limit=100&from_date=${formatDateTime(event.beginDate)}&to_date=${formatDateTime(event.endDate)}&is_warehouse=1";
            } else {
              if (event.storeId == "") {
                path =
                    "/v1/product/sale/list?sort=desc&page=${event.page}&limit=100&from_date=${formatDateTime(event.beginDate)}&to_date=${formatDateTime(event.endDate)}";
              } else {
                path =
                    "/v1/product/sale/list?sort=desc&page=${event.page}&limit=100&from_date=${formatDateTime(event.beginDate)}&to_date=${formatDateTime(event.endDate)}&store_id=${event.storeId}";
              }
            }
          } else {
            path =
                '/v1/product/sale/list?sort=desc&page=${event.page}&limit=100';
          }
        } else {
          if (event.searchAgian) {
            path =
                '/v1/product/sale/list?sort=desc&page=${event.page}&limit=100&store_id=${Utils.getStoreId()}&from_date=${formatDateTime(event.beginDate)}&to_date=${formatDateTime(event.endDate)}';
          } else {
            path =
                '/v1/product/sale/list?sort=desc&page=${event.page}&limit=100&store_id=${Utils.getStoreId()}';
          }
        }
        Response response = await apiService.getRequest(path);
        MainSaleProductResponseModel dataResponse =
            MainSaleProductResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          bool hasMoreOrder = true;
          if (dataResponse.data!.list!.length < 40) {
            hasMoreOrder = false;
          }
          emit(GetMainSaleSuccess(dataResponse.data!, hasMoreOrder));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(GetMainSaleFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(GetMainSaleFailure(dataResponse.message.text!));
        } else {
          emit(GetMainSaleFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(GetMainSaleFailure("Серверийн алдаа"));
      }
    });
    on<SaleProductBack>((event, emit) async {
      emit(SaleProductBackLoading());
      try {
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        var body = {
          "saleId": event.saleId,
          "stock": event.stock,
          "_amount": event.amount
        };
        Response response =
            await apiService.postRequest('/v1/product/sale/return', body: body);
        AuthenticationResponseModel dataResponse =
            AuthenticationResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(SaleProductBackSuccess());
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(SaleProductBackFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(SaleProductBackFailure(dataResponse.message.text!));
        } else {
          emit(SaleProductBackFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(SaleProductBackFailure("Серверийн алдаа"));
      }
    });
  }
}

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime.toLocal());
}
