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
        } else if (dataResponse.message.show) {
          emit(UploadFailure(dataResponse.message.text!));
        } else {
          emit(UploadFailure(""));
        }
      } catch (ex, stackTrace) {
        if (ex.toString() ==
            "DioException [bad response]: The request returned an invalid status code of 403.") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
          emit(UploadFailure("Token"));
        } else {
          print("Error: $ex");
          print("Stacktrace: $stackTrace");
          if (ex is DioError) {
            print("Response data: ${ex.response?.data}");
          }
          emit(UploadFailure("Серверийн алдаа"));
        }
      }
    });
  }
}
