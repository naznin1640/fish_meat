import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/cart/views/cart_screen.dart';
import 'package:fish_meat/features/home/homescreen.dart';
import 'package:fish_meat/features/orders/view/order_screen.dart';
import 'package:fish_meat/features/profile/view/profile_screen.dart';
import 'package:fish_meat/features/search/view/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class BottomNav extends ConsumerWidget {
   BottomNav({super.key});

   final navIndexProvider = StateProvider<int>((ref) => 0);

  final List<Widget> screens =[
    Homescreen(),
    SearchScreen(),
    CartScreen(),
    OrderScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        unselectedItemColor: ConstantColors.lightClr,
        selectedItemColor: Colors.white,
       selectedFontSize: 14,
       unselectedFontSize: 12,
        onTap: (index) {
          ref.read(navIndexProvider.notifier).state = index;
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: ConstantColors.blueClr,
        items: const[  
          BottomNavigationBarItem(icon: Icon(Icons.home,), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search),label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ] ),
        
    );
  }
}


