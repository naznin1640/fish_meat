import 'package:dio/dio.dart';
import 'package:fish_meat/core/constants/api_constants.dart';
import 'package:fish_meat/shared/services/api_services.dart';
import 'package:fish_meat/features/auth/model/response/auth_model.dart';
import 'package:fish_meat/features/auth/model/response/register_model.dart';

class AuthApi {
  
  final dio = ApiServices().dio;
  static String? globaltoken; 
  

Future<LoginResponse?> login(String email, String password) async {
  try {
    final response = await dio.post(
      ApiConstants.login,
      data: {
        "email": email,
        "password": password,
      },
    );

if(response.statusCode == 200 || response.data == 201){

final loginResponse = LoginResponse.fromJson(response.data);

if(loginResponse.success == true){
  globaltoken = loginResponse.data?.token;
  
    print("TOKEN SAVED: $globaltoken"); 

     return loginResponse;
}
}  
  } catch (e) {
    print("LOGIN ERROR: $e");
    return null;
  }
}


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

