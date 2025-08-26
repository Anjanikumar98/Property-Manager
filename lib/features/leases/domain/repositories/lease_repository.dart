import '../../domain/entities/lease.dart';

abstract class LeaseRepository {
  Future<List<Lease>> getLeases();
  Future<Lease?> getLeaseById(String id);
  Future<List<Lease>> getLeasesByPropertyId(String propertyId);
  Future<List<Lease>> getLeasesByTenantId(String tenantId);
  Future<List<Lease>> getActiveLeases();
  Future<String> createLease(Lease lease);
  Future<void> updateLease(Lease lease);
  Future<void> terminateLease(String id, DateTime terminationDate);
  Future<void> deleteLease(String id);
}
