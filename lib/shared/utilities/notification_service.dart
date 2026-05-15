import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fish_meat/core/services/api_services.dart';
import 'package:fish_meat/features/orders/providers/order_notifier.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message: ${message.messageId}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

      ProviderContainer? _container;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'fish_meat_channel',
    'Fish & Meat Notifications',
    description: 'Order updates, promotions and reminders',
    importance: Importance.high,
  );

  Future<void> initialize(BuildContext context,ProviderContainer container) async {
    _container = container;

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print("Notification permission: ${settings.authorizationStatus}");

    if(settings.authorizationStatus == AuthorizationStatus.denied){
      print("Notification denied by user");
      return;
    }

    await _setupLocalNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message: ${message.notification?.title}");
      _showLocalNotification(message);

      final type = message.data['type'];
      if(type == 'ORDER_STATUS' || type == 'ORDER_UPDATE'){
        _container?.read(orderProvider.notifier).fetchOrders();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification tapped: ${message.data}");
      if(!context.mounted) return;
      _handleNotificationTap(message, context);
    });

    final initialMessage = await _messaging.getInitialMessage();
      if(!context.mounted) return;
    if (initialMessage != null) {
      print("App opened from notification: ${initialMessage.data}");
      await Future.delayed(Duration(microseconds: 500));
      if(context.mounted) {
      _handleNotificationTap(initialMessage, context);
    }}

    await _saveToken();

    _messaging.onTokenRefresh.listen((newToken) async {
      print("FCM Token refreshed: $newToken");
      await _updateTokenOnServer(newToken);
    });
  }

  Future<void> _setupLocalNotifications() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        print("Local notification tapped: ${details.payload}");
      },
    );

  
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _showLocalNotification(RemoteMessage message) {
  final notification = message.notification;
  if (notification == null) return;

  _localNotifications.show(
    id: notification.hashCode,
    title: notification.title,
    body: notification.body,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
        color: const Color(0xFF03213A),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),
    payload: message.data.toString(),
  );
}


  void _handleNotificationTap(RemoteMessage message, BuildContext context) {
    final type = message.data['type'] ?? '';
    final orderId = message.data['orderId'];
    print("Notification type: $type, orderId: $orderId");

    switch (type){
      case 'ORDER_STATUS':
      case 'ORDER_UPDATE':

      _container?.read(orderProvider.notifier).fetchOrders();
      _navigateToOrders(context);
      break;

      case 'PRE_ORDER_REMINDER':
      _container?.read(orderProvider.notifier).fetchOrders();
      _navigateToOrders(context);
      break;

      default:
      _navigateToOrders(context);
      break;
    }
  }
    void _navigateToOrders(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        'bottomnav',
        (route) => false,
      );
    }
  }

  Future<void> _saveToken() async {
    final token = await _messaging.getToken();
    if (token != null) {
      print("FCM Token: $token");
      await _updateTokenOnServer(token);
    }
  }

  Future<void> _updateTokenOnServer(String token) async {
    try {
      final dio = ApiServices().dio;
      await dio.put("/auth/user", data: {"fcmToken": token});
      print("FCM token saved to server");
    } on DioException catch (e) {
      print("Failed to save FCM token: ${e.response?.data}");
    }
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
