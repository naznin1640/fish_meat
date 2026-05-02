import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/auth/providers/auth_notifier.dart';
import 'package:fish_meat/landing/view/landing_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final pro = ref.read(authProvider.notifier);
    return Scaffold(
      backgroundColor: ConstantColors.blueClr,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.asset(
                      height: 120,
                      "assets/vector/bluefish-vector.png",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      left: 20,
                      top: 30,
                    ),
                    child: TextFormField(
                      controller: state.emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your email id";
                        } else if (!value.contains("@")) {
                          return "Please enter your email id";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "enter your email",
                        hintStyle: TextStyle(color: ConstantColors.lightClr),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: ConstantColors.lightClr,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      left: 20,
                      top: 10,
                    ),
                    child: TextFormField(
                      controller: state.passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your password";
                        } else if (value.length < 5) {
                          return "Password must be contain 5 characters";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "enter password",
                        hintStyle: TextStyle(color: ConstantColors.lightClr),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: ConstantColors.lightClr,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Don't have an Account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/createaccount');
                          },
                          child: Text("Register"),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    child: InkWell(
                      onTap: state.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final succes = await pro.login();
                                if (succes && context.mounted) {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LandingView()));
                                } else {
                                  final updatedState = ref.read(authProvider);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        updatedState.error ?? "Login failed",
                                      ),
                                    ),
                                  );
                                }
                              }
                            },

                      child: Container(
                        height: 48,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ConstantColors.blueClr,
                        ),
                        child: Center(
                          child: state.isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
