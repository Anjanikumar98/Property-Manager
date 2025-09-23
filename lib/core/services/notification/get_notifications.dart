import 'package:dartz/dartz.dart';
import 'package:property_manager/core/services/notification/notification.dart';
import 'package:property_manager/core/services/notification/notification_repository.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';

class GetNotifications implements UseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    NoParams params,
  ) async {
    return await repository.getNotifications();
  }
}
