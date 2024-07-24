import 'package:black_book/bloc/refresh_token/bloc.dart';
import 'package:black_book/bloc/refresh_token/event.dart';
import 'package:black_book/models/login/authentication.dart';
import 'package:black_book/service/api.dart';
import 'package:black_book/util/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'event.dart';
import 'state.dart';

class RemoveBloc extends Bloc<RemoveEvent, RemoveState> {
  RemoveBloc() : super(RemoveInitial()) {
    on<RemoveProductEvent>((event, emit) async {
      emit(RemoveLoading());
      try {
        String accessToken = Utils.getToken();
        final apiService = ApiTokenService(accessToken);
        print(accessToken);
        Response response = await apiService
            .deleteRequest('/v1/product/remove/good?good_id=${event.goodId}');
        AuthenticationResponseModel dataResponse =
            AuthenticationResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(RemoveSuccess());
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(RemoveFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(RemoveFailure(dataResponse.message.text!));
        } else {
          emit(RemoveFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        print(ex);
        emit(RemoveFailure("Серверийн алдаа"));
      }
    });
  }
}
