import 'package:dartz/dartz.dart';
import 'package:property_manager/core/services/notification/notification.dart';
import 'package:property_manager/core/services/notification/notification_repository.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';

class CreateNotification
    implements UseCase<NotificationEntity, CreateNotificationParams> {
  final NotificationRepository repository;

  CreateNotification(this.repository);

  @override
  Future<Either<Failure, NotificationEntity>> call(
    CreateNotificationParams params,
  ) async {
    return await repository.createNotification(params.notification);
  }
}

class CreateNotificationParams {
  final NotificationEntity notification;

  CreateNotificationParams({required this.notification});
}

