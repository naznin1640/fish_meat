import 'package:fish_meat/features/auth/model/response/auth_model.dart';
import 'package:fish_meat/features/auth/model/response/register_model.dart';
import 'package:flutter/material.dart';

class AuthState {
  final LoginResponse? loginData;
  final RegisterModel? data;
  final bool isLoading;
  final String? error;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;



  AuthState({
    this.loginData,
    this.data,
    this.isLoading = false,
    this.error,
    required this.emailController,
    required this.passwordController,
     required this.nameController,

  });

  AuthState copyWith({
    LoginResponse? loginData,
  final RegisterModel? data,
    bool? isLoading,
    String? error,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? nameController,
  

  }) {
    return AuthState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      loginData: loginData ?? this.loginData,
      data:data ?? this.data,
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      nameController: nameController ?? this.nameController,
    );
  }
}
