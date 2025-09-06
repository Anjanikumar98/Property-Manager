// lib/features/leases/presentation/bloc/lease_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/lease.dart';

abstract class LeaseState extends Equatable {
  const LeaseState();

  @override
  List<Object?> get props => [];
}

class LeaseInitial extends LeaseState {}

class LeaseLoading extends LeaseState {}

class LeaseLoaded extends LeaseState {
  final List<Lease> leases;
  final List<Lease> activeLeases;
  final List<Lease> expiringLeases;

  const LeaseLoaded({
    required this.leases,
    required this.activeLeases,
    required this.expiringLeases,
  });

  @override
  List<Object> get props => [leases, activeLeases, expiringLeases];
}

class LeaseError extends LeaseState {
  final String message;

  const LeaseError(this.message);

  @override
  List<Object> get props => [message];
}

class LeaseOperationSuccess extends LeaseState {
  final String message;
  final Lease? lease;

  const LeaseOperationSuccess(this.message, {this.lease});

  @override
  List<Object?> get props => [message, lease];
}
