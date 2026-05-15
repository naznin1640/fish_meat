import 'package:dio/dio.dart';
import 'package:fish_meat/shared/services/api_services.dart';
import 'package:fish_meat/features/profile/model/response/user_model.dart';

class ProfileApi {
  final Dio dio = ApiServices().dio;

  Future<UserResponse?> getUserDetails() async{
    try {
      final res = await dio.get('/users');
      return UserResponse.fromJson(res.data);
    } on DioException catch (e) {
      print("${e.response?.data}");
      return null;
    }
  }

  Future<UserResponse?> updateUser({
    String? address,
    String? pincode,
    String? fcmToken
  }) async{
    try {
      final res = await dio.put('/users', data: {
        if (address != null) "address" : address,
        if (pincode != null) "pincode" : pincode,
        if(fcmToken != null) "fcmToken" : fcmToken
      });
      print("STATUS: ${res.statusCode}");
      print("UPDATE RESPONSE: ${res.data}");
      return UserResponse.fromJson(res.data);
    } on DioException catch (e) {
      print("ERROR STATUS: ${e.response?.statusCode}");
    print("ERROR BODY: ${e.response?.data}");
      return null;
    }
  }
}