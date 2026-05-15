import 'package:fish_meat/features/profile/api/profile_api.dart';
import 'package:fish_meat/features/profile/model/response/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepoProvider = Provider<ProfileRepo>((ref) => ProfileRepo());

class ProfileRepo {
  final ProfileApi api = ProfileApi();

  Future<UserResponse?> getUserDetails() async {
    return api.getUserDetails();
  }

  Future<UserResponse?> updateUser({
    String? address,
    String? pincode,
    String? fcmToken
  }) async {
    return api.updateUser(
      address: address,
      pincode: pincode,
      fcmToken: fcmToken
    );
  }
}
