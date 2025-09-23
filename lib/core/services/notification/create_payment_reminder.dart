import 'package:dartz/dartz.dart';
import 'package:property_manager/core/services/notification/notification.dart';
import 'package:property_manager/core/services/notification/notification_repository.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';

class CreatePaymentReminder
    implements UseCase<NotificationEntity, CreatePaymentReminderParams> {
  final NotificationRepository repository;

  CreatePaymentReminder(this.repository);

  @override
  Future<Either<Failure, NotificationEntity>> call(
    CreatePaymentReminderParams params,
  ) async {
    final notification = NotificationEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: NotificationType.paymentReminder,
      title: 'Payment Reminder',
      body:
          'Rent payment of ₹${params.amount} is due for ${params.propertyName}',
      scheduledFor: params.dueDate.subtract(
        Duration(days: params.reminderDays),
      ),
      isRead: false,
      createdAt: DateTime.now(),
      data: {
        'propertyId': params.propertyId,
        'tenantId': params.tenantId,
        'amount': params.amount,
        'dueDate': params.dueDate.toIso8601String(),
      },
      actionUrl: '/payments/record',
    );

    return await repository.createNotification(notification);
  }
}

class CreatePaymentReminderParams {
  final String propertyId;
  final String tenantId;
  final String propertyName;
  final double amount;
  final DateTime dueDate;
  final int reminderDays;

  CreatePaymentReminderParams({
    required this.propertyId,
    required this.tenantId,
    required this.propertyName,
    required this.amount,
    required this.dueDate,
    required this.reminderDays,
  });
}

