import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/auth/views/register_account_view.dart';
import 'package:fish_meat/features/auth/views/login_view.dart';
import 'package:fish_meat/features/home/views/homescreen.dart';
import 'package:fish_meat/landing/view/landing_view.dart';
import 'package:fish_meat/features/splash/view/splash_view.dart';
import 'package:fish_meat/shared/services/shared_pref_svc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefSvc.instance.init();
  runApp(ProviderScope(
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: ConstantColors.blueClr,
      ),
      debugShowCheckedModeBanner: false,
       initialRoute: '/',
      routes: {
        '/': (context) => SplashView(),
        '/login' : (context) => LoginView(),
        '/createaccount' : (context) => CreateAccountView(),
        'bottomnav' : (context) => LandingView(),
        '/home' : (context) => Homescreen()
      },
      // home: ,
    );
  }
}
