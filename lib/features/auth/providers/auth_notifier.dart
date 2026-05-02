import 'package:fish_meat/features/auth/model/state/auth_state.dart';
import 'package:fish_meat/features/auth/repo/auth_repo.dart';
import 'package:fish_meat/shared/services/shared_pref_svc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.authRepo)
    : super(
        AuthState(
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
          nameController: TextEditingController(),
        ),
      );

  final AuthRepo authRepo;

  Future<bool> login() async {
    state = state.copyWith(
      isLoading: true,
      loginData: null,
      error: null);

    final result = await authRepo.login(state.emailController.text, state.passwordController.text);

    if (result != null && result.success == true) {

      await SharedPrefSvc.instance.setValue(
        SharedPrefKeys.token, 
        result.data?.token ?? "");

        await SharedPrefSvc.instance.setValue(
          SharedPrefKeys.isLoggedIn, 
          true);

          await SharedPrefSvc.instance.setValue(
            SharedPrefKeys.userName, 
            result.data?.user?.username ?? "");

            await SharedPrefSvc.instance.setValue(
              SharedPrefKeys.id, 
              result.data?.user?.id ??"");

      state = state.copyWith(isLoading: false, loginData: result);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result?.message ?? "Invalid email or password",
      );
      return false;
    }
  }

  Future<bool> createAccount() async {
    state = state.copyWith(
      isLoading: true,
      data: null,
      error: null);
     try {
    final result = await authRepo.createAccount(
      state.nameController.text.trim(),
      state.emailController.text.trim(),
      state.passwordController.text.trim(),
    );

    if (result != null) {
      state = state.copyWith(isLoading: false, data: result);
      return true;
    }
  } catch (e) {
    state = state.copyWith(
      isLoading: false,
      error: e.toString(),
    );
    return false;
  }

  state = state.copyWith(isLoading: false);
  return false;
}
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return (AuthNotifier(ref.read(authrepoProvider)));
});