import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio(BaseOptions(
    baseUrl: 'https://fakestoreapi.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  )) {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Dio get dio => _dio;
}
