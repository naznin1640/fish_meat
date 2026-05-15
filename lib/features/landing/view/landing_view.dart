import 'package:fish_meat/features/cart/views/cart_screen.dart';
import 'package:fish_meat/features/home/views/homescreen.dart';
import 'package:fish_meat/features/notification/view/notification_screen.dart';
import 'package:fish_meat/features/orders/providers/order_notifier.dart';
import 'package:fish_meat/features/orders/view/order_screen.dart';
import 'package:fish_meat/features/profile/view/profile_screen.dart';
import 'package:fish_meat/features/search/view/search_view.dart';
import 'package:fish_meat/features/landing/widgets/app_bar_widget.dart';
import 'package:fish_meat/features/landing/widgets/bottom_nav_widget.dart';
import 'package:fish_meat/shared/utilities/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingView extends ConsumerStatefulWidget{
  const LandingView({super.key});

  @override
   ConsumerState<LandingView> createState() => _LandingViewState();
}

 class _LandingViewState extends ConsumerState<LandingView> {
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final container = ProviderScope.containerOf(context);
      NotificationService().initialize(context, container);
      ref.read(orderProvider.notifier).fetchOrders();
    });
  }
  void _showNotificationPanel(){
    showModalBottomSheet(context: context, 
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
     NotificationScreen()
    );
  }
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navIndexProvider);

    final screens = [
      const Homescreen(),
      const SearchScreen(),
      const CartScreen(),
      const OrderScreen(),
      const ProfileScreen(),
    ];

    final titles = [
      "Categories",
      "Search",
      "My Cart",
      "My Orders",
      "Profile",
    ];

    return Scaffold(
      appBar: currentIndex == 3
          ? null
          : AppBarWidget(
              title: titles[currentIndex],
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed:_showNotificationPanel,
                ),
              ],
            ),
      body: screens[currentIndex],
      bottomNavigationBar: const BottomNavWidget(),
    );
  }
}

