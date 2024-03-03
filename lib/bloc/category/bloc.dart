import 'package:black_book/bloc/refresh_token/bloc.dart';
import 'package:black_book/bloc/refresh_token/event.dart';
import 'package:black_book/models/category/category_response.dart';
import 'package:black_book/models/login/authentication.dart';
import 'package:black_book/service/api.dart';
import 'package:black_book/util/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'event.dart';
import 'state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<CreateCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        String accessToken = Utils.getToken();
        print(accessToken);
        final apiService = ApiTokenService(accessToken);
        var body = {"name": event.name, "parent": event.parent};
        print(body);
        Response response =
            await apiService.postRequest('/v1/category/create', body: body);
        print("this reponse  = ${response.data}");
        AuthenticationResponseModel dataResponse =
            AuthenticationResponseModel.fromJson(
                response.data); //TODO ene hesegt oor responeod huleej avna
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(CategorySuccess());
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(CategoryFailure(dataResponse.message.text!));
        } else {
          emit(CategoryFailure(""));
        }
      } catch (ex) {
        print(ex);
        if (ex.toString() ==
            "DioException [bad response]: The request returned an invalid status code of 403.") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
        }
        emit(CategoryFailure(ex.toString()));
      }
    });
    on<GetCategoryEvent>((event, emit) async {
      emit(GetCategoryLoading());
      try {
        String accessToken = Utils.getToken();
        print(" this is token = $accessToken");
        final apiService = ApiTokenService(accessToken);
        Response response = await apiService
            .getRequest('/v1/category/my/list?parent=${event.type}');
        print(response);
        CategoryResponseModel dataResponse =
            CategoryResponseModel.fromJson(response.data);
        if (response.statusCode == 200 && dataResponse.status == "success") {
          emit(GetCategorySuccess(dataResponse.data!));
        } else if (dataResponse.status == "error" &&
            dataResponse.message.show) {
          emit(GetCategoryFailure(dataResponse.message.text!));
        } else {
          emit(GetCategoryFailure(""));
        }
      } catch (ex) {
        print(ex);
        if (ex.toString() ==
            "DioException [bad response]: The request returned an invalid status code of 403.") {
          final bloc = RefreshBloc();
          bloc.add(const RefreshTokenEvent());
        }
        emit(GetCategoryFailure("Серверийн алдаа"));
      }
    });
  }
}
