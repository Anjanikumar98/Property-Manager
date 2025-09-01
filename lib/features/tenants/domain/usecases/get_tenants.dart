// lib/features/tenants/domain/usecases/get_tenants.dart
import 'package:dartz/dartz.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import 'package:property_manager/features/tenants/data/repositories/tenant_repository_impl.dart';
import '../../../../core/errors/failures.dart';
import '../entities/tenant.dart';
import '../repositories/tenant_repository.dart';

class GetTenants implements UseCase<List<Tenant>, NoParams> {
  final TenantRepository repository;

  GetTenants(this.repository);

  @override
  Future<Either<Failure, List<Tenant>>> call(NoParams params) async {
    return await repository.getTenants();
  }
}
