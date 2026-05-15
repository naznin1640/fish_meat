import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/auth/api/auth_api.dart';
import 'package:fish_meat/features/auth/views/register_account_view.dart';
import 'package:fish_meat/features/auth/views/login_view.dart';
import 'package:fish_meat/features/home/views/homescreen.dart';
import 'package:fish_meat/firebase_options.dart';
import 'package:fish_meat/features/landing/view/landing_view.dart';
import 'package:fish_meat/features/splash/view/splash_view.dart';
import 'package:fish_meat/shared/services/shared_pref_svc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Background message: ${message.messageId}");
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefSvc.instance.init();

  final savedToken = SharedPrefSvc.instance.getValue(SharedPrefKeys.token, "");
  if(savedToken.isNotEmpty){
  AuthApi.globaltoken = savedToken;
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(ProviderScope(
    child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

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
    );
  }
}


