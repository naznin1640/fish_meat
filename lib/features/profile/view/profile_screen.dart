import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/landing/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Profile"),
      body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 4,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    // backgroundImage: ,
                    child: Icon(Icons.person, size: 65,),
                    ),
                ),
                Text("Naznin", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ConstantColors.blueClr),)
              ],
            ),
          ),
        ),
    );
  }
}