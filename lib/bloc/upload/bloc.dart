import 'package:black_book/bloc/refresh_token/bloc.dart';
import 'package:black_book/bloc/refresh_token/event.dart';
import 'package:black_book/models/upload/upload_response.dart';
import 'package:black_book/service/api.dart';
import 'package:black_book/util/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'event.dart';
import 'state.dart';

class UploadBloc extends Bloc<UploadPhotoEvent, UploadPhotoState> {
  UploadBloc() : super(UploadInitial()) {
    on<UploadPhotoEvent>((event, emit) async {
      emit(UploadLoading());
      try {
        final apiService = ApiFormService(Utils.getToken());
        var body = FormData.fromMap(
            {"photo": await MultipartFile.fromFile(event.photo.path)});
        Response response = await apiService
            .postRequest('/v1/misc/upload/product/photo', body: body);
        print(response.data);
        UploadResponseModel dataResponse =
            UploadResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(UploadSuccess(dataResponse.data!));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.reason == "auth_token_error") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(UploadFailure("Token"));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(UploadFailure(dataResponse.message.text!));
        } else {
          emit(UploadFailure("Серверийн алдаа"));
        }
      } catch (ex) {
        emit(UploadFailure("Серверийн алдаа"));
      }
    });
  }
}
