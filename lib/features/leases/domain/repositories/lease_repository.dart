// lib/features/leases/domain/repositories/lease_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lease.dart';

abstract class LeaseRepository {
  Future<Either<Failure, List<Lease>>> getLeases();
  Future<Either<Failure, Lease>> getLeaseById(String id);
  Future<Either<Failure, List<Lease>>> getLeasesByProperty(String propertyId);
  Future<Either<Failure, List<Lease>>> getLeasesByTenant(String tenantId);
  Future<Either<Failure, List<Lease>>> getActiveLeases();
  Future<Either<Failure, List<Lease>>> getExpiringLeases();
  Future<Either<Failure, Lease>> createLease(Lease lease);
  Future<Either<Failure, Lease>> updateLease(Lease lease);
  Future<Either<Failure, void>> deleteLease(String id);
  Future<Either<Failure, Lease>> terminateLease(String id, DateTime terminationDate);
  Future<Either<Failure, Lease>> renewLease(String id, DateTime newEndDate);
}
