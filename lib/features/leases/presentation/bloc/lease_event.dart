import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:property_manager/features/leases/domain/entities/lease.dart';
import 'package:property_manager/features/leases/domain/usecases/get_leases.dart';
import 'package:property_manager/features/leases/presentation/widgets/lease_termination_dialog.dart';

abstract class LeaseEvent extends Equatable {
  const LeaseEvent();

  @override
  List<Object?> get props => [];
}

class TerminateLeaseEvent extends LeaseEvent {
  final String leaseId;
  final DateTime terminationDate;
  final TerminationReason reason;
  final String reasonDetails;
  final bool refundSecurityDeposit;
  final double deductions;
  final String? notes;

  const TerminateLeaseEvent({
    required this.leaseId,
    required this.terminationDate,
    required this.reason,
    required this.reasonDetails,
    this.refundSecurityDeposit = true,
    this.deductions = 0.0,
    this.notes,
  });

  @override
  List<Object?> get props => [
    leaseId,
    terminationDate,
    reason,
    reasonDetails,
    refundSecurityDeposit,
    deductions,
    notes,
  ];
}

class RenewLeaseEvent extends LeaseEvent {
  final String leaseId;
  final DateTime newEndDate;
  final double newMonthlyRent;
  final double newSecurityDeposit;
  final RentFrequency rentFrequency;
  final int noticePeriodDays;
  final String? renewalTerms;
  final String? notes;

  const RenewLeaseEvent({
    required this.leaseId,
    required this.newEndDate,
    required this.newMonthlyRent,
    required this.newSecurityDeposit,
    required this.rentFrequency,
    required this.noticePeriodDays,
    this.renewalTerms,
    this.notes,
  });

  @override
  List<Object?> get props => [
    leaseId,
    newEndDate,
    newMonthlyRent,
    newSecurityDeposit,
    rentFrequency,
    noticePeriodDays,
    renewalTerms,
    notes,
  ];
}

class ChangeLeaseStatusEvent extends LeaseEvent {
  final String leaseId;
  final LeaseStatus newStatus;
  final String? reason;

  const ChangeLeaseStatusEvent({
    required this.leaseId,
    required this.newStatus,
    this.reason,
  });

  @override
  List<Object?> get props => [leaseId, newStatus, reason];
}

class AddLeaseNoteEvent extends LeaseEvent {
  final String leaseId;
  final String note;

  const AddLeaseNoteEvent({required this.leaseId, required this.note});

  @override
  List<Object?> get props => [leaseId, note];
}

class AddLeaseDocumentEvent extends LeaseEvent {
  final String leaseId;
  final String documentPath;
  final String documentName;

  const AddLeaseDocumentEvent({
    required this.leaseId,
    required this.documentPath,
    required this.documentName,
  });

  @override
  List<Object?> get props => [leaseId, documentPath, documentName];
}

class LoadLeaseHistoryEvent extends LeaseEvent {
  final String leaseId;

  const LoadLeaseHistoryEvent(this.leaseId);

  @override
  List<Object?> get props => [leaseId];
}

class RefreshLeaseStatusEvent extends LeaseEvent {
  const RefreshLeaseStatusEvent();

  @override
  List<Object?> get props => [];
}

class LoadLeasesEvent extends LeaseEvent {
  final GetLeasesParams params;

  const LoadLeasesEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class CreateLeaseEvent extends LeaseEvent {
  final Lease lease;

  const CreateLeaseEvent({required this.lease});

  @override
  List<Object?> get props => [lease];
}

class UpdateLeaseEvent extends LeaseEvent {
  final Lease lease;

  const UpdateLeaseEvent({required this.lease});

  @override
  List<Object?> get props => [lease];
}

class DeleteLeaseEvent extends LeaseEvent {
  final String leaseId;

  const DeleteLeaseEvent(this.leaseId);

  @override
  List<Object?> get props => [leaseId];
}

