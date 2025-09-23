import 'package:dartz/dartz.dart';
import 'package:property_manager/core/services/notification/notification_repository.dart';
import 'package:property_manager/core/services/notification/notification_settings.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';

class GetNotificationSettings
    implements UseCase<NotificationSettings, NoParams> {
  final NotificationRepository repository;

  GetNotificationSettings(this.repository);

  @override
  Future<Either<Failure, NotificationSettings>> call(NoParams params) async {
    return await repository.getNotificationSettings();
  }
}

