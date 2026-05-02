import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/auth/views/login_view.dart';
import 'package:fish_meat/landing/view/landing_view.dart';
import 'package:fish_meat/shared/services/shared_pref_svc.dart';
import 'package:flutter/material.dart';
 
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

void checkLogin(){
  final isLoggedIn = SharedPrefSvc.instance.getValue(
    SharedPrefKeys.isLoggedIn, 
    false);

    Future.delayed(Duration(seconds: 2), (){
      if (isLoggedIn){
        if(!mounted) return;
      Navigator.pushReplacement(
        context, 
      MaterialPageRoute(builder:(_) => LandingView()));
      }else{
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => LoginView()));
      }
    });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(height: 120, "assets/vector/bluefish-vector.png"),
          Center(
            child: Text(
              "FISH AND MEAT",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: ConstantColors.blueClr,
              ),
            ),
          ),
          Text(
            "Purchase Fresh Fish And Meat",
            style: TextStyle(fontSize: 12, color: ConstantColors.blueClr),
          ),
        ],
      ),
    );
  }
}
