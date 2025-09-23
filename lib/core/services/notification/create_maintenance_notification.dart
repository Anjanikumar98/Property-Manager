import 'package:dartz/dartz.dart';
import 'package:property_manager/core/services/notification/notification.dart';
import 'package:property_manager/core/services/notification/notification_repository.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';

class CreateMaintenanceNotification
    implements
        UseCase<NotificationEntity, CreateMaintenanceNotificationParams> {
  final NotificationRepository repository;

  CreateMaintenanceNotification(this.repository);

  @override
  Future<Either<Failure, NotificationEntity>> call(
    CreateMaintenanceNotificationParams params,
  ) async {
    final notification = NotificationEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: NotificationType.maintenanceRequest,
      title: 'Maintenance Request',
      body: 'New maintenance request: ${params.description}',
      scheduledFor: DateTime.now(),
      isRead: false,
      createdAt: DateTime.now(),
      data: {
        'propertyId': params.propertyId,
        'tenantId': params.tenantId,
        'requestId': params.requestId,
        'priority': params.priority,
      },
      actionUrl: '/maintenance/${params.requestId}',
    );

    return await repository.createNotification(notification);
  }
}

class CreateMaintenanceNotificationParams {
  final String propertyId;
  final String tenantId;
  final String requestId;
  final String description;
  final String priority;

  CreateMaintenanceNotificationParams({
    required this.propertyId,
    required this.tenantId,
    required this.requestId,
    required this.description,
    required this.priority,
  });
}
