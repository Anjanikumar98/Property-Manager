// lib/features/tenants/domain/repositories/tenant_repository.dart
import 'package:property_manager/features/tenants/domain/entities/tenant.dart';

abstract class TenantRepository {
  Future<List<Tenant>> getTenants();
  Future<Tenant?> getTenantById(String id);
  Future<List<Tenant>> searchTenants(String query);
  Future<Tenant?> getTenantByEmail(String email);
  Future<Tenant?> getTenantByPhone(String phone);
  Future<String> addTenant(Tenant tenant);
  Future<void> updateTenant(Tenant tenant);
  Future<void> deleteTenant(String id);
}
