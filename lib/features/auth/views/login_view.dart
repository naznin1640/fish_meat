import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/auth/providers/otp_notifier.dart';
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
    final state = ref.watch(otpProvider);
    final pro = ref.read(otpProvider.notifier);
    return Scaffold(
      backgroundColor: blueClr,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Center(
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
                          padding: const EdgeInsets.all(25),
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
                              hintStyle: TextStyle(color: lightClr),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              prefixIcon: Icon(Icons.mail, color: lightClr),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await pro.sendOtp();
                                if (state.loginData != null &&
                                    state.loginData!.success &&
                                    context.mounted) {
                                  Navigator.pushNamed(context, '/otp');
                                }
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: blueClr,
                              ),
                              child: Center(
                                child: Text(
                                  "Send Otp",
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
