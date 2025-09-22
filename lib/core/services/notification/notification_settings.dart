// lib/features/notifications/domain/entities/notification_settings.dart
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class NotificationSettings extends Equatable {
  final bool paymentRemindersEnabled;
  final bool leaseExpiryAlertsEnabled;
  final bool maintenanceRequestsEnabled;
  final bool propertyUpdatesEnabled;
  final bool systemAlertsEnabled;
  final int paymentReminderDays;
  final int leaseExpiryReminderDays;
  final TimeOfDay quietHoursStart;
  final TimeOfDay quietHoursEnd;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const NotificationSettings({
    required this.paymentRemindersEnabled,
    required this.leaseExpiryAlertsEnabled,
    required this.maintenanceRequestsEnabled,
    required this.propertyUpdatesEnabled,
    required this.systemAlertsEnabled,
    required this.paymentReminderDays,
    required this.leaseExpiryReminderDays,
    required this.quietHoursStart,
    required this.quietHoursEnd,
    required this.soundEnabled,
    required this.vibrationEnabled,
  });

  NotificationSettings copyWith({
    bool? paymentRemindersEnabled,
    bool? leaseExpiryAlertsEnabled,
    bool? maintenanceRequestsEnabled,
    bool? propertyUpdatesEnabled,
    bool? systemAlertsEnabled,
    int? paymentReminderDays,
    int? leaseExpiryReminderDays,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return NotificationSettings(
      paymentRemindersEnabled:
          paymentRemindersEnabled ?? this.paymentRemindersEnabled,
      leaseExpiryAlertsEnabled:
          leaseExpiryAlertsEnabled ?? this.leaseExpiryAlertsEnabled,
      maintenanceRequestsEnabled:
          maintenanceRequestsEnabled ?? this.maintenanceRequestsEnabled,
      propertyUpdatesEnabled:
          propertyUpdatesEnabled ?? this.propertyUpdatesEnabled,
      systemAlertsEnabled: systemAlertsEnabled ?? this.systemAlertsEnabled,
      paymentReminderDays: paymentReminderDays ?? this.paymentReminderDays,
      leaseExpiryReminderDays:
          leaseExpiryReminderDays ?? this.leaseExpiryReminderDays,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }

  @override
  List<Object?> get props => [
    paymentRemindersEnabled,
    leaseExpiryAlertsEnabled,
    maintenanceRequestsEnabled,
    propertyUpdatesEnabled,
    systemAlertsEnabled,
    paymentReminderDays,
    leaseExpiryReminderDays,
    quietHoursStart,
    quietHoursEnd,
    soundEnabled,
    vibrationEnabled,
  ];
}

// Default settings
class DefaultNotificationSettings {
  static const NotificationSettings defaultSettings = NotificationSettings(
    paymentRemindersEnabled: true,
    leaseExpiryAlertsEnabled: true,
    maintenanceRequestsEnabled: true,
    propertyUpdatesEnabled: false,
    systemAlertsEnabled: true,
    paymentReminderDays: 3,
    leaseExpiryReminderDays: 30,
    quietHoursStart: TimeOfDay(hour: 22, minute: 0),
    quietHoursEnd: TimeOfDay(hour: 8, minute: 0),
    soundEnabled: true,
    vibrationEnabled: true,
  );
}
