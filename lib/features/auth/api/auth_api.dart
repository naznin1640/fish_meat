
import 'package:dio/dio.dart';
import 'package:fish_meat/core/constants/api_constants.dart';
import 'package:fish_meat/core/services/auth_services.dart';
import 'package:fish_meat/features/auth/model/response/auth_model.dart';
import 'package:fish_meat/features/auth/model/response/register_model.dart';

class AuthApi {
  final dio = AuthServices().dio;
Future<LoginResponse?> login (String email, String password)async{
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {
          "email" : email,
          "password": password,}
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }


  // Future<LoginResponse?> verifyOtp(String email, String password) async{
  //   try {
  //     final response = await dio.post(
  //       "/auth/verify",
  //       data: {
  //         "email" : email,
  //         "otp" : otp
  //       }
  //     );
  //     return LoginResponse.fromJson(response.data);
  //   } catch (e) {
  //     return null;
  //   }
  // }
  Future<RegisterModel?> createAccount(
    String username,
    String email,
    String password) 
    async{
    try {
      final res = await dio.post(
       "/auth/register",
       data: {
        "username" : username,
        "email" : email,
         "password" : password
       }
      );
      return RegisterModel.fromJson(res.data);
    } on DioException catch (e) {
      throw e.response?.data["message"];
    }
  }
}
