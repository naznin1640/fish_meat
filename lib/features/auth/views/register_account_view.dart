import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/auth/providers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAccountView extends ConsumerStatefulWidget {
  const CreateAccountView({super.key});

  @override
  ConsumerState<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends ConsumerState<CreateAccountView> {
  final _createKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final pro = ref.read(authProvider.notifier);
    return Scaffold(
      backgroundColor: ConstantColors.blueClr,
      body: Form(
        key: _createKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 15,
                  children: [
                    Center(
                      child: Text(
                        "CREATE ACCOUNT",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: state.nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: "Enter your Name",
                      ),
                    ),
                    TextFormField(
                      controller: state.emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your email";
                        } else if (!value.contains("@")) {
                          return "inavlid emil";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: "Enter email id",
                      ),
                    ),
                    TextFormField(
                      controller: state.passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter password";
                        } else if (value.length < 5 || value.length > 10) {
                          return "Password must contain 5 charecters";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: "Enter password",
                      ),
                    ),
                    InkWell(
                      onTap: state.isLoading
                          ? null
                          : () async {
                              if (_createKey.currentState!.validate()) {
                                final success = await pro.createAccount();

                                if (!context.mounted) return;

                                if (success) {
                                  Navigator.pushNamed(context, '/home');
                                } else {
                                  final updatedState = ref.read(authProvider);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        updatedState.error ??
                                            "Registration failed",
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: state.isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  "Register",
                                  style: TextStyle(
                                    color: ConstantColors.blueClr,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
