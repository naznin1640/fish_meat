import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/landing/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Categories"),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
          ),
          // child: ,
        ),
    );
  }
}