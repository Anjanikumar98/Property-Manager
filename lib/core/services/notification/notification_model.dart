// lib/features/notifications/data/models/notification_model.dart
import 'package:property_manager/core/services/notification/notification.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.body,
    required super.scheduledFor,
    required super.isRead,
    required super.createdAt,
    super.data,
    super.actionUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: NotificationType.values.firstWhere((e) => e.name == json['type']),
      title: json['title'],
      body: json['body'],
      scheduledFor: DateTime.parse(json['scheduledFor']),
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      data:
          json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      actionUrl: json['actionUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'body': body,
      'scheduledFor': scheduledFor.toIso8601String(),
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'data': data,
      'actionUrl': actionUrl,
    };
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      type: entity.type,
      title: entity.title,
      body: entity.body,
      scheduledFor: entity.scheduledFor,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
      data: entity.data,
      actionUrl: entity.actionUrl,
    );
  }
}

