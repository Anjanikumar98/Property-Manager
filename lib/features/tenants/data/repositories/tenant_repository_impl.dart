// lib/features/tenants/domain/repositories/tenant_repository.dart
import 'package:dartz/dartz.dart';
import 'package:property_manager/features/tenants/domain/entities/tenant.dart';
import '../../../../core/errors/failures.dart';

abstract class TenantRepository {
  Future<Either<Failure, List<Tenant>>> getTenants();
  Future<Either<Failure, Tenant>> getTenantById(String id);
  Future<Either<Failure, List<Tenant>>> getTenantsByProperty(String propertyId);
  Future<Either<Failure, List<Tenant>>> searchTenants(String query);
  Future<Either<Failure, Tenant>> addTenant(Tenant tenant);
  Future<Either<Failure, Tenant>> updateTenant(Tenant tenant);
  Future<Either<Failure, void>> deleteTenant(String id);
  Future<Either<Failure, void>> deactivateTenant(String id);
  Future<Either<Failure, void>> activateTenant(String id);
}
