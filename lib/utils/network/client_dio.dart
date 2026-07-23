import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../utils.dart';

/// A class that represents a Dio client for making HTTP requests.
class ApiClient {
  ApiClient() {
    _dio = Dio();
    _dio.options.baseUrl = GetIt.instance<AppSettings>().baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'accept': 'application/json',
      'x-api-key': GetIt.instance<AppSettings>().apiKey,
    };
    _dio.options.listFormat = ListFormat.multiCompatible;
  }

  late Dio _dio;

  /// Sends a GET request to the specified [path] with optional [queryParameters] and [options].
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

  /// Sends a POST request to the specified [path] with optional [data], [queryParameters], and [options].
  Future<Response<dynamic>> post(
    String path, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    void Function(int count, int total)? onSendProgress,
  }) async =>
      _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
      );
}
