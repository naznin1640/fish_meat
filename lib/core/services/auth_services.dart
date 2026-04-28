import 'package:dio/dio.dart';
import 'package:fish_meat/core/constants/api_constants.dart';
import 'package:fish_meat/features/auth/model/auth_model.dart';

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
  }
  Future<LoginResponse?> sendOtp (String email)async{
    try {
      final response = await dio.post(
        "send-otp",
        data: {"email" : email}
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
  Future<LoginResponse?> verifyOtp(String email, String otp) async{
    try {
      final response = await dio.post(
        "verify-otp",
        data: {
          "email" : email,
          "otp" : otp
        }
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
