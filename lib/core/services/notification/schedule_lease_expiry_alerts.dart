import 'package:dartz/dartz.dart';
import 'package:property_manager/core/services/notification/notification_repository.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import '../../../../core/errors/failures.dart';

class ScheduleLeaseExpiryAlerts implements UseCase<bool, NoParams> {
  final NotificationRepository repository;

  ScheduleLeaseExpiryAlerts(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.scheduleLeaseExpiryAlerts();
  }
}
