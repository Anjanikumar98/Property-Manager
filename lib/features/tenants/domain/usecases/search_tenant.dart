// lib/features/tenants/domain/usecases/search_tenants.dart
import 'package:dartz/dartz.dart';
import 'package:property_manager/features/auth/domain/usecases/login_user.dart';
import 'package:property_manager/features/tenants/data/repositories/tenant_repository_impl.dart';
import '../../../../core/errors/failures.dart';
import '../entities/tenant.dart';

class SearchTenants implements UseCase<List<Tenant>, SearchTenantsParams> {
  final TenantRepository repository;

  SearchTenants(this.repository);

  @override
  Future<Either<Failure, List<Tenant>>> call(SearchTenantsParams params) async {
    return await repository.searchTenants(params.query);
  }
}

class SearchTenantsParams {
  final String query;

  SearchTenantsParams({required this.query});
}
