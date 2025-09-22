// lib/features/notifications/domain/entities/notification.dart
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum NotificationType {
  paymentReminder,
  leaseExpiry,
  maintenanceRequest,
  propertyUpdate,
  systemAlert,
}

class NotificationEntity extends Equatable {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime scheduledFor;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;
  final String? actionUrl;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.scheduledFor,
    required this.isRead,
    required this.createdAt,
    this.data,
    this.actionUrl,
  });

  NotificationEntity markAsRead() {
    return NotificationEntity(
      id: id,
      type: type,
      title: title,
      body: body,
      scheduledFor: scheduledFor,
      isRead: true,
      createdAt: createdAt,
      data: data,
      actionUrl: actionUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    body,
    scheduledFor,
    isRead,
    createdAt,
    data,
    actionUrl,
  ];
}
