import 'dart:developer';
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('--> [HTTP REQUEST] ${options.method.toUpperCase()} ${options.uri}', name: 'DioClient');
    if (options.data != null) {
      log('Request Body: ${options.data}', name: 'DioClient');
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('<-- [HTTP RESPONSE] ${response.statusCode} ${response.requestOptions.uri}', name: 'DioClient');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('<-- [HTTP ERROR] ${err.response?.statusCode} ${err.requestOptions.uri}', name: 'DioClient');
    log('Error Message: ${err.message}', name: 'DioClient');
    if (err.response?.data != null) {
      log('Error Body: ${err.response?.data}', name: 'DioClient');
    }
    return handler.next(err);
  }
}
