import 'package:flutter/material.dart';

class NotifItem {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final DateTime time;
  final String orderId;

  NotifItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
    required this.orderId,
  });
}