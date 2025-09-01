// lib/features/tenants/domain/usecases/delete_tenant.dart
import 'package:dartz/dartz.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import 'package:property_manager/features/tenants/data/repositories/tenant_repository_impl.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/tenant_repository.dart';

class DeleteTenant implements UseCase<void, DeleteTenantParams> {
  final TenantRepository repository;

  DeleteTenant(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTenantParams params) async {
    return await repository.deleteTenant(params.id);
  }
}

class DeleteTenantParams {
  final String id;

  DeleteTenantParams({required this.id});
}
