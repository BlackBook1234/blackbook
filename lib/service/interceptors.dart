import 'dart:io';

import 'package:dio/dio.dart';

class CustomInterceptors extends InterceptorsWrapper {
  CustomInterceptors()
      : super(onRequest: (options, handler) {
          return handler.next(options); // continue
        }, onResponse: (response, handler) {
          return handler.next(response); // continue
        }, onError: (e, handler) {
          if (e.error is HandshakeException) {
            return handler.resolve(e.response!); //ssl shalgah
          }
          return handler.resolve(e.response!);
        });
}