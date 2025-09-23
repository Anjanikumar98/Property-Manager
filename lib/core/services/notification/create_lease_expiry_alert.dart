import 'package:dartz/dartz.dart';
import 'package:property_manager/core/services/notification/notification.dart';
import 'package:property_manager/core/services/notification/notification_repository.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';

class CreateLeaseExpiryAlert
    implements UseCase<NotificationEntity, CreateLeaseExpiryAlertParams> {
  final NotificationRepository repository;

  CreateLeaseExpiryAlert(this.repository);

  @override
  Future<Either<Failure, NotificationEntity>> call(
    CreateLeaseExpiryAlertParams params,
  ) async {
    final notification = NotificationEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: NotificationType.leaseExpiry,
      title: 'Lease Expiry Alert',
      body:
          'Lease for ${params.propertyName} expires on ${_formatDate(params.expiryDate)}',
      scheduledFor: params.expiryDate.subtract(
        Duration(days: params.reminderDays),
      ),
      isRead: false,
      createdAt: DateTime.now(),
      data: {
        'propertyId': params.propertyId,
        'tenantId': params.tenantId,
        'leaseId': params.leaseId,
        'expiryDate': params.expiryDate.toIso8601String(),
      },
      actionUrl: '/leases/${params.leaseId}',
    );

    return await repository.createNotification(notification);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class CreateLeaseExpiryAlertParams {
  final String propertyId;
  final String tenantId;
  final String leaseId;
  final String propertyName;
  final DateTime expiryDate;
  final int reminderDays;

  CreateLeaseExpiryAlertParams({
    required this.propertyId,
    required this.tenantId,
    required this.leaseId,
    required this.propertyName,
    required this.expiryDate,
    required this.reminderDays,
  });
}
