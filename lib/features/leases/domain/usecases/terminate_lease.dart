// lib/features/leases/domain/usecases/terminate_lease.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lease.dart';
import '../repositories/lease_repository.dart';

class TerminateLease {
  final LeaseRepository repository;

  TerminateLease(this.repository);

  Future<Either<Failure, Lease>> call(TerminateLeaseParams params) async {
    return await repository.terminateLease(
      params.leaseId,
      params.terminationDate,
    );
  }
}

class TerminateLeaseParams extends Equatable {
  final String leaseId;
  final DateTime terminationDate;

  const TerminateLeaseParams({
    required this.leaseId,
    required this.terminationDate,
  });

  @override
  List<Object> get props => [leaseId, terminationDate];
}
