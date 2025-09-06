// lib/features/leases/presentation/bloc/lease_event.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/lease.dart';
import '../../domain/usecases/get_leases.dart';

abstract class LeaseEvent extends Equatable {
  const LeaseEvent();

  @override
  List<Object?> get props => [];
}

class LoadLeasesEvent extends LeaseEvent {
  final GetLeasesParams params;

  const LoadLeasesEvent(this.params);

  @override
  List<Object> get props => [params];
}

class CreateLeaseEvent extends LeaseEvent {
  final Lease lease;

  const CreateLeaseEvent(this.lease);

  @override
  List<Object> get props => [lease];
}

class UpdateLeaseEvent extends LeaseEvent {
  final Lease lease;

  const UpdateLeaseEvent(this.lease);

  @override
  List<Object> get props => [lease];
}

class DeleteLeaseEvent extends LeaseEvent {
  final String leaseId;

  const DeleteLeaseEvent(this.leaseId);

  @override
  List<Object> get props => [leaseId];
}

class TerminateLeaseEvent extends LeaseEvent {
  final String leaseId;
  final DateTime terminationDate;

  const TerminateLeaseEvent(this.leaseId, this.terminationDate);

  @override
  List<Object> get props => [leaseId, terminationDate];
}

class RenewLeaseEvent extends LeaseEvent {
  final String leaseId;
  final DateTime newEndDate;

  const RenewLeaseEvent(this.leaseId, this.newEndDate);

  @override
  List<Object> get props => [leaseId, newEndDate];
}
