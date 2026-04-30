import 'package:dio/dio.dart';
import 'package:fish_meat/core/constants/api_constants.dart';


class AuthServices {
  late Dio dio;
  AuthServices(){
    dio=Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {"Content-Type": "application/json"},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers["Authorization"] = 'Bearer Token';
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
    )
  );

  dio.interceptors.add(LogInterceptor(request: true, requestBody: true, responseBody: true, error: true, requestHeader: false));
  }
}
