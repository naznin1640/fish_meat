import 'package:dio/dio.dart';
import 'package:fish_meat/core/constants/api_constants.dart';
import 'package:fish_meat/features/auth/api/auth_api.dart';

class ApiServices {
  static final ApiServices _instance = ApiServices._internal();
  factory ApiServices() => _instance;

  late Dio dio;

  ApiServices._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (AuthApi.globaltoken != null) {
            options.headers["Authorization"] = 'Bearer ${AuthApi.globaltoken}';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('error: ${e.message}');
          return handler.next(e);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: false,
    ));
  }
}