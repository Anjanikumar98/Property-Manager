import 'package:dartz/dartz.dart';
import 'package:property_manager/core/services/notification/notification_repository.dart';
import 'package:property_manager/core/services/notification/notification_settings.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';

class UpdateNotificationSettings
    implements UseCase<NotificationSettings, UpdateNotificationSettingsParams> {
  final NotificationRepository repository;

  UpdateNotificationSettings(this.repository);

  @override
  Future<Either<Failure, NotificationSettings>> call(
    UpdateNotificationSettingsParams params,
  ) async {
    return await repository.updateNotificationSettings(params.settings);
  }
}

class UpdateNotificationSettingsParams {
  final NotificationSettings settings;

  UpdateNotificationSettingsParams({required this.settings});
}

