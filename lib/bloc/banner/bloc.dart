import 'package:black_book/bloc/refresh_token/bloc.dart';
import 'package:black_book/bloc/refresh_token/event.dart';
import 'package:black_book/models/banner/response.dart';
import 'package:black_book/service/api.dart';
import 'package:black_book/util/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'event.dart';
import 'state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  BannerBloc() : super(BannerInitial()) {
    on<GetBannerEvent>((event, emit) async {
      emit(BannerLoading());
      try {
        String accessToken = Utils.getToken();
        print(accessToken);
        final apiService = ApiTokenService(accessToken);
        Response response = await apiService.getRequest('/v1/misc/banner/main');
        print("this reponse  = ${response.data}");
        BannerResponse dataResponse = BannerResponse.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(BannerSuccess(dataResponse.data!));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(BannerFailure(dataResponse.message.text!));
        } else {
          emit(BannerFailure(""));
        }
      } catch (ex) {
        print(ex);
        if (ex.toString() ==
            "DioException [bad response]: The request returned an invalid status code of 403.") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
        } else {
          emit(BannerFailure(ex.toString()));
        }
      }
    });
  }
}
