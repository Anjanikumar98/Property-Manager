import 'package:dartz/dartz.dart';
import 'package:property_manager/core/services/notification/notification.dart';
import 'package:property_manager/core/services/notification/notification_repository.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';

class MarkNotificationRead
    implements UseCase<NotificationEntity, MarkNotificationReadParams> {
  final NotificationRepository repository;

  MarkNotificationRead(this.repository);

  @override
  Future<Either<Failure, NotificationEntity>> call(
    MarkNotificationReadParams params,
  ) async {
    return await repository.markAsRead(params.notificationId);
  }
}

class MarkNotificationReadParams {
  final String notificationId;

  MarkNotificationReadParams({required this.notificationId});
}

