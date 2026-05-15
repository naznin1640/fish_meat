import 'package:fish_meat/features/profile/model/response/user_model.dart';
import 'package:fish_meat/features/profile/model/state/profile_state.dart';
import 'package:fish_meat/features/profile/repo/profile_repo.dart';
import 'package:flutter_riverpod/legacy.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(this.repo): super(ProfileState());

  final ProfileRepo repo;

Future<void> fetchUser() async{
  state = state.copyWith(
    isLoading: true,
    error: null
  );

  final response = await repo.getUserDetails();
  if(response != null && response.success){
    state =state.copyWith(
      isLoading: false,
      user: response.data
    );
  }else{
    state.copyWith(
      isLoading: false,
      error: response?.message ?? "failed to load" 
    );
  }
}

Future<bool> updateUser({
  String? address,
  String? pincode
}) async{
  state = state.copyWith(
    isUpdating: true,
    error: null,
    successMessage: null
  );

  final response = await repo.updateUser(address: address,pincode: pincode);
  if(response != null && response.success){
    state = state.copyWith(
      isUpdating: false,
      user: response.data,
      successMessage: "profile updated successfullyyy"
    );
    return true;
  }else{
state = state.copyWith(
  isLoading: false,
  error: response?.message ?? "failed to load" 
);
    return false;
  }
}
  
}

final profileProvider = StateNotifierProvider<ProfileNotifier,ProfileState >((ref) {
  return ProfileNotifier(ref.read(profileRepoProvider));
});


