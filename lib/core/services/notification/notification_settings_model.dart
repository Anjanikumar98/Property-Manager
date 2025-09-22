// lib/features/notifications/data/models/notification_settings_model.dart
import 'package:flutter/material.dart';
import 'package:property_manager/core/services/notification/notification_settings.dart';

class NotificationSettingsModel extends NotificationSettings {
  const NotificationSettingsModel({
    required super.paymentRemindersEnabled,
    required super.leaseExpiryAlertsEnabled,
    required super.maintenanceRequestsEnabled,
    required super.propertyUpdatesEnabled,
    required super.systemAlertsEnabled,
    required super.paymentReminderDays,
    required super.leaseExpiryReminderDays,
    required super.quietHoursStart,
    required super.quietHoursEnd,
    required super.soundEnabled,
    required super.vibrationEnabled,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      paymentRemindersEnabled: json['paymentRemindersEnabled'] ?? true,
      leaseExpiryAlertsEnabled: json['leaseExpiryAlertsEnabled'] ?? true,
      maintenanceRequestsEnabled: json['maintenanceRequestsEnabled'] ?? true,
      propertyUpdatesEnabled: json['propertyUpdatesEnabled'] ?? false,
      systemAlertsEnabled: json['systemAlertsEnabled'] ?? true,
      paymentReminderDays: json['paymentReminderDays'] ?? 3,
      leaseExpiryReminderDays: json['leaseExpiryReminderDays'] ?? 30,
      quietHoursStart:
          json['quietHoursStart'] != null
              ? TimeOfDay.fromDateTime(DateTime.parse(json['quietHoursStart']))
              : const TimeOfDay(hour: 22, minute: 0),
      quietHoursEnd:
          json['quietHoursEnd'] != null
              ? TimeOfDay.fromDateTime(DateTime.parse(json['quietHoursEnd']))
              : const TimeOfDay(hour: 8, minute: 0),
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentRemindersEnabled': paymentRemindersEnabled,
      'leaseExpiryAlertsEnabled': leaseExpiryAlertsEnabled,
      'maintenanceRequestsEnabled': maintenanceRequestsEnabled,
      'propertyUpdatesEnabled': propertyUpdatesEnabled,
      'systemAlertsEnabled': systemAlertsEnabled,
      'paymentReminderDays': paymentReminderDays,
      'leaseExpiryReminderDays': leaseExpiryReminderDays,
      'quietHoursStart':
          DateTime(
            2023,
            1,
            1,
            quietHoursStart.hour,
            quietHoursStart.minute,
          ).toIso8601String(),
      'quietHoursEnd':
          DateTime(
            2023,
            1,
            1,
            quietHoursEnd.hour,
            quietHoursEnd.minute,
          ).toIso8601String(),
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
    };
  }

  factory NotificationSettingsModel.fromEntity(NotificationSettings entity) {
    return NotificationSettingsModel(
      paymentRemindersEnabled: entity.paymentRemindersEnabled,
      leaseExpiryAlertsEnabled: entity.leaseExpiryAlertsEnabled,
      maintenanceRequestsEnabled: entity.maintenanceRequestsEnabled,
      propertyUpdatesEnabled: entity.propertyUpdatesEnabled,
      systemAlertsEnabled: entity.systemAlertsEnabled,
      paymentReminderDays: entity.paymentReminderDays,
      leaseExpiryReminderDays: entity.leaseExpiryReminderDays,
      quietHoursStart: entity.quietHoursStart,
      quietHoursEnd: entity.quietHoursEnd,
      soundEnabled: entity.soundEnabled,
      vibrationEnabled: entity.vibrationEnabled,
    );
  }
}

