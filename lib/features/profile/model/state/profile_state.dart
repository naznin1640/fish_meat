import 'package:fish_meat/features/profile/model/response/user_model.dart';

class ProfileState {
  final bool isLoading;
  final bool isUpdating;
  final UserModel? user;
  final String? error;
  final String? successMessage;

  ProfileState({
    this.isLoading = false,
    this.isUpdating = false,
    this.user,
    this.error,
    this.successMessage,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isUpdating,
    UserModel? user,
    String? error,
    String? successMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      user: user ?? this.user,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}