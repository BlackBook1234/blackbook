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
            responseData.message.show) {
          emit(PackagesFailure(responseData.message.text!));
        } else {
          emit(PackagesFailure(""));
        }
      } catch (ex) {
        print(ex);
        if (ex.toString() ==
            "DioException [bad response]: The request returned an invalid status code of 403.") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
        } else {
          emit(PackagesFailure(ex.toString()));
        }
      }
    });
    on<GetInvoiceEvent>((event, emit) async {
      emit(InvoiceLoading());
      try {
        String accessToken = Utils.getToken();
        print(accessToken);
        var body = {"type": event.keys};
        final apiService = ApiTokenService(accessToken);
        Response response =
            await apiService.postRequest('/v1/payment/invoice', body: body);
        print("this reponse  = ${response.data}");
        InvoiceResponse responseData = InvoiceResponse.fromJson(response.data);
        if (response.statusCode == 200 && responseData.status == "success") {
          emit(InvoiceSuccess(responseData.data!));
        } else if (responseData.status == "error" &&
            responseData.message.show) {
          emit(InvoiceFailure(responseData.message.text!));
        } else {
          emit(InvoiceFailure(""));
        }
      } catch (ex) {
        print(ex);
        if (ex.toString() ==
            "DioException [bad response]: The request returned an invalid status code of 403.") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
        } else {
          emit(InvoiceFailure(ex.toString()));
        }
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
            responseData.message.show) {
          emit(CheckInvoiceFailure(responseData.message.text!));
        } else {
          emit(CheckInvoiceFailure(""));
        }
      } catch (ex) {
        print(ex);
        if (ex.toString() ==
            "DioException [bad response]: The request returned an invalid status code of 403.") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
        } else {
          emit(CheckInvoiceFailure(ex.toString()));
        }
      }
    });
  }
}
