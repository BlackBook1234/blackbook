// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:black_book/service/api.dart';
import 'package:black_book/util/utils.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

import 'dio_handle.dart';

class APIHttpClient {
  // String authToken = Utils.getToken();

  final Map<String, dynamic> _cache = {};

  final _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {"Authorization": "Bearer ${Utils.getToken()}"},
      //  baseUrl: 'http://10.10.10.77:6979',
      contentType: 'application/json',
    ),
  );

  Completer<void>? _isRefreshing;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool useAuth = true,
    bool useCache = false,
  }) {
    if (useCache && _cache.containsKey(path) && _cache[path] != null) {
      return Future.value(_cache[path]!);
    }

    return mapException(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
    ).then(
      (value) {
        if (useCache) {
          _cache[path] = value;
        }
        return value;
      },
    );
  }

  /// HTTP POST request.
  Future<dynamic> post(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    // options!.headers!['Authorization'] = 'Bearer $authToken';
    return mapException(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    ).then((value) {
      return value;
    });
  }

  /// HTTP PUT request.
  Future<dynamic> put(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return mapException(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// HTTP HEAD request.
  Future<dynamic> head(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return mapException(
      () => _dio.head(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// HTTP DELETE request.
  Future<dynamic> delete(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return mapException(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// HTTP PATCH request.
  Future<dynamic> patch(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return mapException(
      () => _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  APIHttpClient() {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: print, // specify log function
        retries: 3, // retry count
        retryDelays: const [
          Duration(seconds: 1), // wait 1 sec before first retry
          Duration(seconds: 2), // wait 2 sec before second retry
          Duration(seconds: 3), // wait 3 sec before third retry
        ],
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
      ),
    );
  }

  void _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Wait for the token to be refreshed
    if (_isRefreshing != null) {
      await _isRefreshing!.future;
    }

    if (Utils.getToken() != "") {
      options.headers['Authorization'] = 'Bearer ${Utils.getToken()}';
    }

    handler.next(options);
  }

  void _onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    // Token is expired ...
    if (response.data['error'] == 'UnauthorizedError') {
      // Is there already a refresh in progress?
      if (_isRefreshing != null && !(_isRefreshing!.isCompleted)) {
        await _isRefreshing!.future;
      } else {
        // Refresh the token
        _isRefreshing = Completer();
        // await UAuth().refreshToken();
        _isRefreshing!.complete();
      }

      // Refresh-лэж чадаагүй. Log out хийх.
      if (Utils.getToken() == "") {
        // UAuth().logout();
        return;
      }

      response.requestOptions.headers['Authorization'] = 'Bearer ${Utils.getToken()}';

      final options = Options(
        method: response.requestOptions.method,
        headers: response.requestOptions.headers,
      );

      // log("API: Resending ${response.realUri.path} with new token");

      final newRequestResponse = await _dio.request<dynamic>(
        response.requestOptions.path,
        options: options,
        data: response.requestOptions.data,
        queryParameters: response.requestOptions.queryParameters,
      );

      if (newRequestResponse.data['error'] != null) {
        return handler.reject(
          DioError(
            requestOptions: newRequestResponse.requestOptions,
            response: newRequestResponse,
            type: DioErrorType.badResponse,
            error: response.data['error'],
          ),
        );
      }

      return handler.next(newRequestResponse);
    }

    if (response.data['error'] != null) {
      return handler.reject(
        DioError(
          requestOptions: response.requestOptions,
          response: response,
          type: DioErrorType.badResponse,
          error: response.data['error'],
        ),
      );
    }

    return handler.next(response);
  }

  // Future<dynamic> postMultipart(
  //   String path, {
  //   bool useAuth = true,
  //   Map<String, String>? body,
  //   required Map<String, Uint8List> files,
  // }) async {
  //   final formData = FormData();

  //   if (body != null) formData.fields.addAll(body.entries);

  //   for (var entry in files.entries) {
  //     formData.files.add(
  //       MapEntry(
  //         entry.key,
  //         MultipartFile.fromBytes(
  //           List<int>.from(entry.value),
  //           filename: 'avatar.jpg',
  //           contentType: MediaType('image', 'jpeg'),
  //         ),
  //       ),
  //     );
  //   }

  //   return await post(path, data: formData);
  // }
}
