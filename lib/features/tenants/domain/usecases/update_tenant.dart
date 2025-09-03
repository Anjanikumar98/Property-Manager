import 'package:dartz/dartz.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import 'package:property_manager/features/tenants/data/repositories/tenant_repository_impl.dart';
import '../../../../core/errors/failures.dart';
import '../entities/tenant.dart';


class UpdateTenant implements UseCase<Tenant, UpdateTenantParams> {
  final TenantRepository repository;

  UpdateTenant(this.repository);

  @override
  Future<Either<Failure, Tenant>> call(UpdateTenantParams params) async {
    return await repository.updateTenant(params.tenant);
  }
}

class UpdateTenantParams {
  final Tenant tenant;

  UpdateTenantParams({required this.tenant});
}
