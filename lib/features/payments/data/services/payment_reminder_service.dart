// lib/features/payments/data/services/payment_reminder_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:property_manager/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:property_manager/features/payments/data/models/payment_model.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/database_service.dart';

class PaymentReminderService {
  final NotificationService _notificationService;
  final DatabaseService _databaseService;
  Timer? _reminderTimer;

  PaymentReminderService(
      this._notificationService,
      this._databaseService,
      );

  Future<void> initialize() async {
    await _scheduleRecurringCheck();
    await _checkAndSendReminders();
  }

  Future<void> dispose() async {
    _reminderTimer?.cancel();
  }

  // Schedule payment reminders
  Future<void> schedulePaymentReminder({
    required String paymentId,
    required DateTime reminderDate,
    required PaymentReminderType type,
    String? customMessage,
  }) async {
    final reminder = PaymentReminderModel(
      id: _generateId(),
      paymentId: paymentId,
      reminderDate: reminderDate,
      type: type,
      message: customMessage,
      isActive: true,
      createdAt: DateTime.now(),
    );

    await _databaseService.insert('payment_reminders', reminder.toJson());
    await _scheduleNotification(reminder);
  }

  // Create automatic reminders for new payments
  Future<void> createAutomaticReminders(PaymentModel payment) async {
    final reminderSettings = await _getReminderSettings();

    for (final setting in reminderSettings) {
      if (!setting.isEnabled) continue;

      final reminderDate = _calculateReminderDate(payment.dueDate, setting);
      if (reminderDate.isBefore(DateTime.now())) continue;

      await schedulePaymentReminder(
        paymentId: payment.id,
        reminderDate: reminderDate,
        type: setting.type,
        customMessage: setting.defaultMessage,
      );
    }
  }

  // Check for due payments and send reminders
  Future<void> _checkAndSendReminders() async {
    final now = DateTime.now();
    final reminders = await _getPendingReminders(now);

    for (final reminder in reminders) {
      await _sendReminder(reminder);
      await _markReminderAsSent(reminder.id);
    }
  }

  // Schedule recurring reminder checks
  Future<void> _scheduleRecurringCheck() async {
    _reminderTimer = Timer.periodic(
      const Duration(hours: 1),
          (_) => _checkAndSendReminders(),
    );
  }

  // Get pending reminders that need to be sent
  Future<List<PaymentReminderModel>> _getPendingReminders(DateTime now) async {
    final result = await _databaseService.query(
      'payment_reminders',
      where: 'reminderDate <= ? AND isActive = 1 AND isSent = 0',
      whereArgs: [now.toIso8601String()],
    );

    return result.map((json) => PaymentReminderModel.fromJson(json)).toList();
  }

  // Send reminder notification
  Future<void> _sendReminder(PaymentReminderModel reminder) async {
    final payment = await _getPayment(reminder.paymentId);
 //   if (payment == null || payment.status == PaymentStatus.paid) return;

    final title = _getReminderTitle(reminder.type, payment!);
    final body = reminder.message ?? _getDefaultReminderMessage(reminder.type, payment);

    await _notificationService.showNotification(
      id: reminder.id.hashCode,
      title: title,
      body: body,
      payload: jsonEncode({
        'type': 'payment_reminder',
        'paymentId': payment.id,
        'reminderId': reminder.id,
      }),
    );

    // Schedule repeat reminders for overdue payments
    if (reminder.type == PaymentReminderType.overdue) {
      await _scheduleOverdueFollowUp(payment);
    }
  }

  // Schedule notification using local notifications
  Future<void> _scheduleNotification(PaymentReminderModel reminder) async {
    final payment = await _getPayment(reminder.paymentId);
    if (payment == null) return;

    final title = _getReminderTitle(reminder.type, payment);
    final body = reminder.message ?? _getDefaultReminderMessage(reminder.type, payment);

    await _notificationService.scheduleNotification(
      id: reminder.id.hashCode,
      title: title,
      body: body,
      scheduledDate: reminder.reminderDate,
      payload: jsonEncode({
        'type': 'payment_reminder',
        'paymentId': payment.id,
        'reminderId': reminder.id,
      }),
    );
  }

  // Get payment by ID
  Future<PaymentModel?> _getPayment(String paymentId) async {
    final result = await _databaseService.query(
      'payments',
      where: 'id = ?',
      whereArgs: [paymentId],
    );

    if (result.isEmpty) return null;
    return PaymentModel.fromJson(result.first as String);
  }

  // Get reminder settings
  Future<List<ReminderSetting>> _getReminderSettings() async {
    final result = await _databaseService.query('reminder_settings');
    if (result.isEmpty) return _getDefaultReminderSettings();

    return result.map((json) => ReminderSetting.fromJson(json)).toList();
  }

  // Calculate reminder date based on due date and setting
  DateTime _calculateReminderDate(DateTime dueDate, ReminderSetting setting) {
    switch (setting.type) {
      case PaymentReminderType.upcoming:
        return dueDate.subtract(Duration(days: setting.daysBefore));
      case PaymentReminderType.dueToday:
        return DateTime(dueDate.year, dueDate.month, dueDate.day, 9, 0);
      case PaymentReminderType.overdue:
        return dueDate.add(Duration(days: setting.daysBefore));
    }
  }

  // Get reminder title based on type
  String _getReminderTitle(PaymentReminderType type, PaymentModel payment) {
    switch (type) {
      case PaymentReminderType.upcoming:
        return 'Payment Due Soon';
      case PaymentReminderType.dueToday:
        return 'Payment Due Today';
      case PaymentReminderType.overdue:
        return 'Payment Overdue';
    }
  }

  // Get default reminder message
  String _getDefaultReminderMessage(PaymentReminderType type, PaymentModel payment) {
    final amount = '\${payment.totalAmount.toStringAsFixed(2)}';

    switch (type) {
      case PaymentReminderType.upcoming:
        final daysUntilDue = payment.dueDate.difference(DateTime.now()).inDays;
        return 'Rent payment of $amount is due in $daysUntilDue days.';
      case PaymentReminderType.dueToday:
        return 'Your rent payment of $amount is due today.';
      case PaymentReminderType.overdue:
        final daysOverdue = payment.daysOverdue;
        return 'Your rent payment of $amount is $daysOverdue days overdue.';
    }
  }

  // Schedule follow-up reminders for overdue payments
  Future<void> _scheduleOverdueFollowUp(PaymentModel payment) async {
    final followUpDays = [3, 7, 14, 30]; // Follow up after these days

    for (final days in followUpDays) {
      final followUpDate = payment.dueDate.add(Duration(days: days));
      if (followUpDate.isBefore(DateTime.now())) continue;

      await schedulePaymentReminder(
        paymentId: payment.id,
        reminderDate: followUpDate,
        type: PaymentReminderType.overdue,
        customMessage: 'Payment of \${payment.totalAmount.toStringAsFixed(2)} is now $days days overdue. Please pay immediately to avoid additional fees.',
      );
    }
  }

  // Mark reminder as sent
  Future<void> _markReminderAsSent(String reminderId) async {
    await _databaseService.update(
      'payment_reminders',
      {'isSent': 1, 'sentAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [reminderId],
    );
  }

  // Cancel reminder
  Future<void> cancelReminder(String reminderId) async {
    await _databaseService.update(
      'payment_reminders',
      {'isActive': 0},
      where: 'id = ?',
      whereArgs: [reminderId],
    );

    // Cancel scheduled notification
    await _notificationService.cancelNotification(reminderId.hashCode);
  }

  // Update reminder settings
  Future<void> updateReminderSettings(List<ReminderSetting> settings) async {
    await _databaseService.delete('reminder_settings');

    for (final setting in settings) {
      await _databaseService.insert('reminder_settings', setting.toJson());
    }
  }

  // Get default reminder settings
  List<ReminderSetting> _getDefaultReminderSettings() {
    return [
      ReminderSetting(
        type: PaymentReminderType.upcoming,
        daysBefore: 3,
        isEnabled: true,
        defaultMessage: null,
      ),
      ReminderSetting(
        type: PaymentReminderType.dueToday,
        daysBefore: 0,
        isEnabled: true,
        defaultMessage: null,
      ),
      ReminderSetting(
        type: PaymentReminderType.overdue,
        daysBefore: 1,
        isEnabled: true,
        defaultMessage: null,
      ),
    ];
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

// Payment reminder model
class PaymentReminderModel {
  final String id;
  final String paymentId;
  final DateTime reminderDate;
  final PaymentReminderType type;
  final String? message;
  final bool isActive;
  final bool isSent;
  final DateTime? sentAt;
  final DateTime createdAt;

  const PaymentReminderModel({
    required this.id,
    required this.paymentId,
    required this.reminderDate,
    required this.type,
    this.message,
    required this.isActive,
    this.isSent = false,
    this.sentAt,
    required this.createdAt,
  });

  factory PaymentReminderModel.fromJson(Map<String, dynamic> json) {
    return PaymentReminderModel(
      id: json['id'],
      paymentId: json['paymentId'],
      reminderDate: DateTime.parse(json['reminderDate']),
      type: PaymentReminderType.values.firstWhere((e) => e.name == json['type']),
      message: json['message'],
      isActive: json['isActive'] == 1,
      isSent: json['isSent'] == 1,
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentId': paymentId,
      'reminderDate': reminderDate.toIso8601String(),
      'type': type.name,
      'message': message,
      'isActive': isActive ? 1 : 0,
      'isSent': isSent ? 1 : 0,
      'sentAt': sentAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// Reminder setting model
class ReminderSetting {
  final PaymentReminderType type;
  final int daysBefore;
  final bool isEnabled;
  final String? defaultMessage;

  const ReminderSetting({
    required this.type,
    required this.daysBefore,
    required this.isEnabled,
    this.defaultMessage,
  });

  factory ReminderSetting.fromJson(Map<String, dynamic> json) {
    return ReminderSetting(
      type: PaymentReminderType.values.firstWhere((e) => e.name == json['type']),
      daysBefore: json['daysBefore'],
      isEnabled: json['isEnabled'] == 1,
      defaultMessage: json['defaultMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'daysBefore': daysBefore,
      'isEnabled': isEnabled ? 1 : 0,
      'defaultMessage': defaultMessage,
    };
  }
}

enum PaymentReminderType {
  upcoming,
  dueToday,
  overdue,
}
