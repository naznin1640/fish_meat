import 'package:fish_meat/features/auth/model/auth_model.dart';
import 'package:flutter/material.dart';

class AuthState {
  final LoginResponse? loginData;
  final bool isLoading;
  final String? error;
  final TextEditingController emailController;
  final TextEditingController otpController;

  AuthState({
    this.loginData,
    this.isLoading = false,
    this.error,
    required this.emailController,
    required this.otpController
  });

  AuthState copyWith({
    LoginResponse? loginData,
    bool? isLoading,
    String? error,
    TextEditingController? emailController,
    TextEditingController? otpController
  }) {
    return AuthState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      loginData: loginData ?? this.loginData,
      emailController: emailController ?? this.emailController,
      otpController: otpController ?? this.otpController
    );
  }
}
