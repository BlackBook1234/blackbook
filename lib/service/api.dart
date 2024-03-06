import 'package:dio/dio.dart';
import 'interceptors.dart';

class ApiService {
  final Dio dio;

  ApiService()
      : dio = Dio(BaseOptions(
            baseUrl: "https://khardevter.horshoo.com",
            receiveTimeout: const Duration(milliseconds: 9000),
            sendTimeout: const Duration(milliseconds: 9000),
            headers: {}))
          ..interceptors.add(CustomInterceptors());
  Future<Response> postRequest(String path, {dynamic body}) async {
    return dio.post(path, data: body);
  }

  Future<Response> getRequest(String path) async {
    return dio.get(path);
  }
}

class ApiTokenService {
  final Dio dio;
  ApiTokenService(String token)
      : dio = Dio(BaseOptions(
            baseUrl: "https://khardevter.horshoo.com",
            receiveTimeout: const Duration(milliseconds: 9000),
            sendTimeout: const Duration(milliseconds: 9000),
            headers: {"Authorization": "Bearer $token"}))
          ..interceptors.add(
            CustomInterceptors(),
          );

  Future<Response> postRequest(String path, {dynamic body}) async {
    return dio.post(path, data: body);
  }

  Future<Response> deleteRequest(String path) async {
    return dio.delete(path);
  }

  Future<Response> getRequest(String path) async {
    return dio.get(path);
  }
}

class ApiFormService {
  final Dio dio;
  ApiFormService(String token)
      : dio = Dio(
          BaseOptions(
            baseUrl: "https://khardevter.horshoo.com",
            receiveTimeout: const Duration(milliseconds: 90000),
            sendTimeout: const Duration(milliseconds: 90000),
            headers: {
              "Connection": "keep-alive",
              "Accept-Encoding": "gzip, deflate, br",
              "Accept": "*/*",
              "Content-type": "multipart/form-data",
              "Authorization": "Bearer $token"
            },
          ),
        );

  Future<Response> postRequest(String path, {dynamic body}) async {
    return dio.post(
      path,
      data: body,
    );
  }

  Future<Response> getRequest(String path) async {
    return dio.get(
      path,
    );
  }
}
