import 'package:fish_meat/features/auth/views/register_account_view.dart';
import 'package:fish_meat/features/auth/views/login_view.dart';
import 'package:fish_meat/features/home/homescreen.dart';
import 'package:fish_meat/features/landing/bottom_nav.dart';
import 'package:fish_meat/features/splash/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       initialRoute: '/',
      routes: {
        '/': (context) => SplashView(),
        '/login' : (context) => LoginView(),
        '/createaccount' : (context) => CreateAccountView(),
        'bottomnav' : (context) => BottomNav(),
        '/home' : (context) => Homescreen()
      },
      // home: ,
    );
  }
}
