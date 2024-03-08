import 'package:black_book/bloc/refresh_token/bloc.dart';
import 'package:black_book/bloc/refresh_token/event.dart';
import 'package:black_book/models/invoice/response.dart';
import 'package:black_book/models/packages/response.dart';
import 'package:black_book/service/api.dart';
import 'package:black_book/util/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'event.dart';
import 'state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<GetPackagesEvent>((event, emit) async {
      emit(PackagesLoading());
      try {
        String accessToken = Utils.getToken();
        print(accessToken);
        final apiService = ApiTokenService(accessToken);
        Response response = await apiService.getRequest('/v1/payment/packages');
        print("this reponse  = ${response.data}");
        PackagesResponse responseData =
            PackagesResponse.fromJson(response.data);
        if (response.statusCode == 200 && responseData.status == "success") {
          emit(PackagesSuccess(responseData.data!));
        } else if (responseData.status == "error" &&
            responseData.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(PackagesFailure("Token"));
        } else if (responseData.status == "error" &&
            responseData.message.show) {
          emit(PackagesFailure(responseData.message.reason!));
        } else {
          emit(PackagesFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        print(ex);
        emit(PackagesFailure("Серверийн алдаа"));
      }
    });
    on<GetInvoiceEvent>((event, emit) async {
      emit(InvoiceLoading());
      try {
        var body = {"type": event.keys};
        final apiService = ApiTokenService(Utils.getToken());
        Response response =
            await apiService.postRequest('/v1/payment/invoice', body: body);
        print("this reponse  = ${response.data}");
        InvoiceResponse responseData = InvoiceResponse.fromJson(response.data);
        if (response.statusCode == 200 && responseData.status == "success") {
          emit(InvoiceSuccess(responseData.data!));
        } else if (responseData.status == "error" &&
            responseData.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(InvoiceFailure("Token"));
        } else if (responseData.status == "error" &&
            responseData.message.show) {
          emit(InvoiceFailure(responseData.message.reason!));
        } else {
          emit(InvoiceFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        print(ex);
        emit(InvoiceFailure("Серверийн алдаа"));
      }
    });
    on<CheckInvoiceEvent>((event, emit) async {
      emit(CheckInvoiceLoading());
      try {
        String accessToken = Utils.getToken();
        print(accessToken);
        final apiService = ApiTokenService(accessToken);
        Response response = await apiService.getRequest(
            '/v1/payment/webhook/qpay?h=${event.h}&qpay_payment_id=${event.id}');
        print("this reponse  = ${response.data}");
        InvoiceResponse responseData = InvoiceResponse.fromJson(response.data);
        if (response.statusCode == 200 && responseData.status == "success") {
          emit(CheckInvoiceSuccess());
        } else if (responseData.status == "error" &&
            responseData.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(CheckInvoiceFailure("Token"));
        } else if (responseData.status == "error" &&
            responseData.message.show) {
          emit(CheckInvoiceFailure(responseData.message.reason!));
        } else {
          emit(CheckInvoiceFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        print(ex);
        emit(CheckInvoiceFailure("Серверийн алдаа"));
      }
    });
  }
}
