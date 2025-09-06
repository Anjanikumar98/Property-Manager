// lib/features/leases/domain/usecases/create_lease.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lease.dart';
import '../repositories/lease_repository.dart';

class CreateLease {
  final LeaseRepository repository;

  CreateLease(this.repository);

  Future<Either<Failure, Lease>> call(CreateLeaseParams params) async {
    return await repository.createLease(params.lease);
  }
}

class CreateLeaseParams extends Equatable {
  final Lease lease;

  const CreateLeaseParams({required this.lease});

  @override
  List<Object> get props => [lease];
}
