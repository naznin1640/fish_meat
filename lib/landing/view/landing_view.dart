import 'package:fish_meat/features/cart/views/cart_screen.dart';
import 'package:fish_meat/features/home/views/homescreen.dart';
import 'package:fish_meat/features/orders/view/order_screen.dart';
import 'package:fish_meat/features/profile/view/profile_screen.dart';
import 'package:fish_meat/features/search/view/search_screen.dart';
import 'package:fish_meat/landing/widgets/app_bar_widget.dart';
import 'package:fish_meat/landing/widgets/bottom_nav_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingView extends ConsumerWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);

    final screens = [
      Homescreen(),
      SearchScreen(),
      CartScreen(),
      OrderScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: const BottomNavWidget(),
    );
  }
}