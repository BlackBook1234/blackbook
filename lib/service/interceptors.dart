import 'package:dio/dio.dart';

class CustomInterceptors extends InterceptorsWrapper {
  CustomInterceptors()
      : super(onRequest: (options, handler) {
          return handler.next(options); //continue
        }, onResponse: (response, handler) {
          return handler.next(response); // continue
          // ignore: deprecated_member_use
        }, onError: (DioError e, handler) {
          return handler.next(e); //continue
        });
}
