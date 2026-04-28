import 'package:fish_meat/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CreateAccountView extends StatelessWidget {
  CreateAccountView({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _createKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueClr,
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
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your name";
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: "Enter your Name",
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your email";
                        } else if (!value.contains("@")) {
                          return "inavlid emil";
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: "Enter email id",
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        } else if (value.length < 8) {
                          return "Password must be 8 characters";
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: "Enter Password",
                      ),
                    ),
                    TextFormField(
                      controller: _phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Phone Number";
                        } else if (value.length < 10 || value.length > 10) {
                          return "invalid phone Number";
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: "Enter phone Number",
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_createKey.currentState!.validate()) {}
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              color: blueClr,
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
