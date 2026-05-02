import 'package:fish_meat/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppBarWidget({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ConstantColors.blueClr,
      title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), 
      centerTitle: true, 
      actions: actions);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}