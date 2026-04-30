import 'package:fish_meat/features/auth/api/auth_api.dart';
import 'package:fish_meat/features/auth/model/response/auth_model.dart';
import 'package:fish_meat/features/auth/model/response/register_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authrepoProvider = Provider<AuthRepo>((ref) => AuthRepo());


class AuthRepo {
  final authApi = AuthApi();

Future<LoginResponse?> login(String email, String password) async {
  return await authApi.login(email, password);
}

// Future<LoginResponse?> verifyOtp(String email, String otp) async{
//   return await authApi.verifyOtp(email, otp);
// }


Future<RegisterModel?> createAccount(String username, String email, String password) async{
  return await authApi.createAccount(username, email, password);
}
}
