import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
          );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _initialized = true;
    } catch (e) {
      throw PermissionException('Failed to initialize notifications: $e');
    }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    debugPrint('Notification tapped: ${response.payload}');
  }

  Future<bool> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        // For Android 13+
        final status = await Permission.notification.request();
        return status.isGranted;
      } else if (Platform.isIOS || Platform.isMacOS) {
        // iOS and macOS have requestPermissions on their plugin
        final bool? granted = await _notifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        return granted ?? false;
      } else {
        return true; // other platforms don't need it
      }
    } catch (e) {
      throw PermissionException(
        'Failed to request notification permissions: $e',
      );
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'default_channel',
            'Default Channel',
            channelDescription: 'Default notification channel',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(id, title, body, details, payload: payload);
    } catch (e) {
      throw ServerException('Failed to show notification: $e');
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'scheduled_channel',
            'Scheduled Channel',
            channelDescription: 'Scheduled notification channel',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } catch (e) {
      throw ServerException('Failed to schedule notification: $e');
    }
  }

  Future<void> showRentDueNotification({
    required String tenantName,
    required String propertyName,
    required double amount,
    required DateTime dueDate,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await showNotification(
      id: id,
      title: 'Rent Due Reminder',
      body:
          'Rent of ${AppConstants.currencySymbol}$amount is due from $tenantName for $propertyName',
      payload: 'rent_due',
    );
  }

  Future<void> showLeaseExpiryNotification({
    required String tenantName,
    required String propertyName,
    required DateTime expiryDate,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await showNotification(
      id: id,
      title: 'Lease Expiry Alert',
      body:
          'Lease for $tenantName at $propertyName expires on ${_formatDate(expiryDate)}',
      payload: 'lease_expiry',
    );
  }

  Future<void> showPaymentReceivedNotification({
    required String tenantName,
    required double amount,
    required String paymentType,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await showNotification(
      id: id,
      title: 'Payment Received',
      body:
          '$paymentType payment of ${AppConstants.currencySymbol}$amount received from $tenantName',
      payload: 'payment_received',
    );
  }

  Future<void> scheduleRentReminders({
    required String leaseId,
    required String tenantName,
    required String propertyName,
    required double rentAmount,
    required int dueDayOfMonth,
  }) async {
    final now = DateTime.now();

    // Schedule for next 12 months
    for (int i = 0; i < 12; i++) {
      final month = now.month + i;
      final year = now.year + (month > 12 ? 1 : 0);
      final adjustedMonth = month > 12 ? month - 12 : month;

      final dueDate = DateTime(year, adjustedMonth, dueDayOfMonth);

      // Schedule 3 days before due date
      final reminderDate = dueDate.subtract(const Duration(days: 3));

      if (reminderDate.isAfter(now)) {
        await scheduleNotification(
          id: leaseId.hashCode + i,
          title: 'Rent Due Soon',
          body:
              'Rent of ${AppConstants.currencySymbol}$rentAmount from $tenantName for $propertyName is due in 3 days',
          scheduledDate: reminderDate,
          payload: 'rent_reminder_$leaseId',
        );
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id);
    } catch (e) {
      throw ServerException('Failed to cancel notification: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
    } catch (e) {
      throw ServerException('Failed to cancel all notifications: $e');
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      throw ServerException('Failed to get pending notifications: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
