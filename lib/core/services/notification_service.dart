// lib/core/services/notification_service.dart
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

enum NotificationType {
  paymentReminder,
  leaseExpiry,
  maintenanceRequest,
  propertyUpdate,
  systemAlert,
}

class NotificationPayload {
  final String id; // Use String for flexibility
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final DateTime scheduledFor;

  NotificationPayload({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    required this.scheduledFor,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'title': title,
    'body': body,
    'data': data,
    'scheduledFor': scheduledFor.toIso8601String(),
  };

  factory NotificationPayload.fromJson(
    Map<String, dynamic> json,
  ) => NotificationPayload(
    id: json['id'],
    type: NotificationType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => NotificationType.systemAlert, // fallback
    ),
    title: json['title'],
    body: json['body'],
    data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
    scheduledFor: DateTime.parse(json['scheduledFor']),
  );
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.notification.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Notification permission denied');
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    final payload = response.payload;
    if (payload != null) {
      // Navigate to appropriate screen based on payload
      _handleNotificationNavigation(payload);
    }
  }

  void _handleNotificationNavigation(String payload) {
    // This will be implemented with your router
    // For now, just print the payload
    print('Notification tapped: $payload');
  }

  // Show immediate notification
  Future<void> showNotification(NotificationPayload payload) async {
    await _notifications.show(
      payload.id.hashCode,
      payload.title,
      payload.body,
      _getNotificationDetails(payload.type),
      payload: payload.toJson().toString(),
    );
  }

  // Schedule notification
  Future<void> scheduleNotification(NotificationPayload payload) async {
    await _notifications.zonedSchedule(
      payload.id.hashCode,
      payload.title,
      payload.body,
      tz.TZDateTime.from(payload.scheduledFor, tz.local),
      _getNotificationDetails(payload.type),
      payload: payload.toJson().toString(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Schedule recurring notification
  Future<void> scheduleRecurringNotification(
    NotificationPayload payload,
    RepeatInterval interval,
  ) async {
    await _notifications.periodicallyShow(
      payload.id.hashCode,
      payload.title,
      payload.body,
      interval,
      _getNotificationDetails(payload.type),
      payload: payload.toJson().toString(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  NotificationDetails _getNotificationDetails(NotificationType type) {
    final channelId = _getChannelId(type);
    final channelName = _getChannelName(type);
    final importance = _getImportance(type);

    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: importance,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: _getNotificationColor(type),
        playSound: true,
        enableVibration: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  String _getChannelId(NotificationType type) {
    switch (type) {
      case NotificationType.paymentReminder:
        return 'payment_reminders';
      case NotificationType.leaseExpiry:
        return 'lease_expiry';
      case NotificationType.maintenanceRequest:
        return 'maintenance_requests';
      case NotificationType.propertyUpdate:
        return 'property_updates';
      case NotificationType.systemAlert:
        return 'system_alerts';
    }
  }

  String _getChannelName(NotificationType type) {
    switch (type) {
      case NotificationType.paymentReminder:
        return 'Payment Reminders';
      case NotificationType.leaseExpiry:
        return 'Lease Expiry Alerts';
      case NotificationType.maintenanceRequest:
        return 'Maintenance Requests';
      case NotificationType.propertyUpdate:
        return 'Property Updates';
      case NotificationType.systemAlert:
        return 'System Alerts';
    }
  }

  Importance _getImportance(NotificationType type) {
    switch (type) {
      case NotificationType.paymentReminder:
      case NotificationType.leaseExpiry:
        return Importance.high;
      case NotificationType.maintenanceRequest:
        return Importance.defaultImportance;
      case NotificationType.propertyUpdate:
        return Importance.low;
      case NotificationType.systemAlert:
        return Importance.max;
    }
  }

  Color? _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.paymentReminder:
        return const Color(0xFF2196F3); // Blue
      case NotificationType.leaseExpiry:
        return const Color(0xFFFF9800); // Orange
      case NotificationType.maintenanceRequest:
        return const Color(0xFF4CAF50); // Green
      case NotificationType.propertyUpdate:
        return const Color(0xFF9C27B0); // Purple
      case NotificationType.systemAlert:
        return const Color(0xFFF44336); // Red
    }
  }

  // Cancel notification
  Future<void> cancelNotification(String notificationId) async {
    await _notifications.cancel(notificationId.hashCode);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Check if notification is scheduled
  Future<bool> isNotificationScheduled(String notificationId) async {
    final pending = await getPendingNotifications();
    return pending.any((n) => n.id == notificationId.hashCode);
  }
}
