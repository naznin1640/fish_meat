import 'package:fish_meat/features/notification/model/notification_model.dart';
import 'package:fish_meat/features/orders/providers/order_notifier.dart';
import 'package:fish_meat/landing/widgets/bottom_nav_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fish_meat/core/constants/colors.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final orders = orderState.orders;

    final List<NotifItem> notifications = [];

    for (final order in orders) {
      final shortId = order.id.substring(order.id.length - 6);

      if (order.status == 'PAID' || order.status == 'CONFIRMED') {
        notifications.add(NotifItem(
          icon: Icons.check_circle_outline,
          color: Colors.orange,
          title: "Order Confirmed",
          body: "Order #$shortId has been confirmed.",
          time: order.date,
          orderId: order.id,
        ));
      } else if (order.status == 'PACKED') {
        notifications.add(NotifItem(
          icon: Icons.inventory_2_outlined,
          color: Colors.blue,
          title: "Order Packed",
          body: "Order #$shortId is packed and ready.",
          time: order.date,
          orderId: order.id,
        ));
      } else if (order.status == 'ON_THE_WAY') {
        notifications.add(NotifItem(
          icon: Icons.local_shipping_outlined,
          color: Colors.blue,
          title: "Out for Delivery",
          body: "Order #$shortId is on the way!",
          time: order.date,
          orderId: order.id,
        ));
      } else if (order.status == 'DELIVERED') {
        notifications.add(NotifItem(
          icon: Icons.done_all,
          color: Colors.green,
          title: "Order Delivered",
          body: "Order #$shortId has been delivered.",
          time: order.date,
          orderId: order.id,
        ));
      } else if (order.status == 'CANCELLED') {
        notifications.add(NotifItem(
          icon: Icons.cancel_outlined,
          color: Colors.red,
          title: "Order Cancelled",
          body: "Order #$shortId was cancelled.",
          time: order.date,
          orderId: order.id,
        ));
      }

      if (order.isPreOrder && order.preOrder != null) {
        final scheduledDate = DateTime.tryParse(order.preOrder!);
        if (scheduledDate != null) {
          final daysLeft = scheduledDate.difference(DateTime.now()).inDays;
          notifications.add(NotifItem(
            icon: Icons.schedule,
            color: Colors.purple,
            title: "Pre-order Reminder",
            body: daysLeft > 0
                ? "Order #$shortId scheduled in $daysLeft day${daysLeft != 1 ? 's' : ''}."
                : "Order #$shortId is scheduled for today!",
            time: scheduledDate,
            orderId: order.id,
          ));
        }
      }
    }

    notifications.sort((a, b) => b.time.compareTo(a.time));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: ConstantColors.blueClr,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (notifications.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  "${notifications.length} alerts",
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
      body: orderState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? _buildEmpty()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 70),
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    return NotifTile(
                      item: notif,
                      onTap: () {
                        Navigator.pop(context);
                        ref.read(navIndexProvider.notifier).state = 3;
                      },
                    );
                  },
                ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            "No notifications yet",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Order updates will appear here",
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class NotifTile extends StatelessWidget {
  final NotifItem item;
  final VoidCallback onTap;

  const NotifTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: item.color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(item.icon, color: item.color, size: 22),
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF1A2B3C),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            item.body,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd MMM yyyy, hh:mm a').format(item.time),
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
          ),
        ],
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
    );
  }
}