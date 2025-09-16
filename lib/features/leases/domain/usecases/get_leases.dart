import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lease.dart';
import '../repositories/lease_repository.dart';

class GetLeases {
  final LeaseRepository repository;

  GetLeases(this.repository);

  Future<Either<Failure, List<Lease>>> call(GetLeasesParams params) {
    switch (params.filterType) {
      case LeaseFilterType.all:
        return repository.getLeases();
      case LeaseFilterType.active:
        return repository.getActiveLeases();
      case LeaseFilterType.expiring:
        return repository.getExpiringLeases();
      case LeaseFilterType.byProperty:
        if (params.propertyId == null) {
          return Future.value(
            Left(ValidationFailure('Property ID is required')),
          );
        }
        return repository.getLeasesByProperty(params.propertyId!);
      case LeaseFilterType.byTenant:
        if (params.tenantId == null) {
          return Future.value(Left(ValidationFailure('Tenant ID is required')));
        }
        return repository.getLeasesByTenant(params.tenantId!);
    }
  }
}

enum LeaseFilterType { all, active, expiring, byProperty, byTenant }

class GetLeasesParams extends Equatable {
  final LeaseFilterType filterType;
  final String? propertyId;
  final String? tenantId;

  const GetLeasesParams({
    required this.filterType,
    this.propertyId,
    this.tenantId,
  });

  @override
  List<Object?> get props => [filterType, propertyId, tenantId];
}
