import 'package:dartz/dartz.dart';
import 'package:property_manager/core/services/notification/notification_repository.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';

class DeleteNotification implements UseCase<bool, DeleteNotificationParams> {
  final NotificationRepository repository;

  DeleteNotification(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteNotificationParams params) async {
    return await repository.deleteNotification(params.notificationId);
  }
}

class DeleteNotificationParams {
  final String notificationId;

  DeleteNotificationParams({required this.notificationId});
}
