import 'package:fish_meat/core/services/auth_services.dart';
import 'package:fish_meat/features/auth/model/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class OtpNotifier extends StateNotifier<AuthState> {
  OtpNotifier({required this.authServices})
    : super(
        AuthState(
          emailController: TextEditingController(),
          otpController: TextEditingController(),
        ),
      );

  final AuthServices authServices;
  bool isLoading = false;
  String? error;

  Future<void> sendOtp() async {
    state = state.copyWith(isLoading: true);

    final result = await authServices.sendOtp(state.emailController.text);

    if (result != null && result.success) {
      state = state = state.copyWith(isLoading: false, loginData: result);
    } else {
      state = state.copyWith(isLoading: false, error: "Something went wrong");
      error = result?.message ?? "Something went wrong";
    }
  }

  Future<bool> verifyOtp() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await authServices.verifyOtp(
      state.emailController.text,
      state.otpController.text,
    );

    if(result != null && result.success){
       state = state.copyWith(
        isLoading: false,
        loginData: result
       );
       return true;
    }else{
      state = state.copyWith(
        isLoading: false,
        error: result?.message ?? "Inavlid Otp"
      );
      return false;
    }
  }
}

final otpProvider = StateNotifierProvider<OtpNotifier, AuthState>((ref) {
  return (OtpNotifier(authServices: AuthServices()));
});
