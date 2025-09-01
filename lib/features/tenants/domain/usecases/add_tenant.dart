// lib/features/tenants/domain/usecases/add_tenant.dart
import 'package:dartz/dartz.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import 'package:property_manager/features/tenants/data/repositories/tenant_repository_impl.dart';
import '../../../../core/errors/failures.dart';
import '../entities/tenant.dart';

class AddTenant implements UseCase<Tenant, AddTenantParams> {
  final TenantRepository repository;

  AddTenant(this.repository);

  @override
  Future<Either<Failure, Tenant>> call(AddTenantParams params) async {
    return await repository.addTenant(params.tenant);
  }
}

class AddTenantParams {
  final Tenant tenant;

  AddTenantParams({required this.tenant});
}




