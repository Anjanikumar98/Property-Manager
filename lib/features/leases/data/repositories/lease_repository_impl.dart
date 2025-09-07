// lib/features/leases/domain/repositories/lease_repository.dart

import 'package:dartz/dartz.dart';
import 'package:property_manager/features/leases/domain/entities/lease.dart';
import '../../../../core/errors/failures.dart';
import '../../presentation/widgets/lease_termination_dialog.dart';
import '../../presentation/widgets/lease_history_widget.dart';

abstract class LeaseRepository {
  /// Create a new lease
  Future<Either<Failure, Lease>> createLease(Lease lease);

  /// Get all leases with optional filtering
  Future<Either<Failure, List<Lease>>> getLeases({
    LeaseStatus? status,
    String? propertyId,
    String? tenantId,
    bool? isExpiring,
    DateTime? startDateFrom,
    DateTime? startDateTo,
    DateTime? endDateFrom,
    DateTime? endDateTo,
  });

  /// Get lease by ID
  Future<Either<Failure, Lease>> getLeaseById(String id);

  /// Update existing lease
  Future<Either<Failure, Lease>> updateLease(Lease lease);

  /// Delete lease
  Future<Either<Failure, void>> deleteLease(String id);

  /// Renew lease with new terms
  Future<Either<Failure, Lease>> renewLease({
    required String leaseId,
    required DateTime newEndDate,
    required double newMonthlyRent,
    required double newSecurityDeposit,
    required RentFrequency rentFrequency,
    required int noticePeriodDays,
    String? renewalTerms,
    String? notes,
  });

  /// Terminate lease
  Future<Either<Failure, Lease>> terminateLease({
    required String leaseId,
    required DateTime terminationDate,
    required TerminationReason reason,
    required String reasonDetails,
    bool refundSecurityDeposit = true,
    double deductions = 0.0,
    String? notes,
  });

  /// Change lease status manually
  Future<Either<Failure, Lease>> changeLeaseStatus({
    required String leaseId,
    required LeaseStatus newStatus,
    String? reason,
  });

  /// Update lease calculated fields (status, remaining days, etc.)
  Future<Either<Failure, List<Lease>>> refreshLeaseStatuses();

  /// Get leases by status
  Future<Either<Failure, List<Lease>>> getLeasesByStatus(LeaseStatus status);

  /// Get active leases
  Future<Either<Failure, List<Lease>>> getActiveLeases();

  /// Get expiring leases
  Future<Either<Failure, List<Lease>>> getExpiringLeases();

  /// Get expired leases
  Future<Either<Failure, List<Lease>>> getExpiredLeases();

  /// Get lease history
  Future<Either<Failure, List<LeaseHistoryItem>>> getLeaseHistory(
    String leaseId,
  );

  /// Add lease history entry
  Future<Either<Failure, void>> addLeaseHistoryEntry({
    required String leaseId,
    required LeaseHistoryAction action,
    required String title,
    String? description,
    String? oldValue,
    String? newValue,
    String? user,
  });

  /// Add note to lease
  Future<Either<Failure, Lease>> addLeaseNote({
    required String leaseId,
    required String note,
  });

  /// Add document to lease
  Future<Either<Failure, Lease>> addLeaseDocument({
    required String leaseId,
    required String documentPath,
    required String documentName,
  });

  /// Remove document from lease
  Future<Either<Failure, Lease>> removeLeaseDocument({
    required String leaseId,
    required String documentPath,
  });

  /// Get lease statistics
  Future<Either<Failure, LeaseStatistics>> getLeaseStatistics();
}

class LeaseStatistics {
  final int totalLeases;
  final int activeLeases;
  final int expiredLeases;
  final int draftLeases;
  final int terminatedLeases;
  final int expiringLeases;
  final double totalMonthlyRent;
  final double totalSecurityDeposits;
  final double averageMonthlyRent;
  final double occupancyRate;

  const LeaseStatistics({
    required this.totalLeases,
    required this.activeLeases,
    required this.expiredLeases,
    required this.draftLeases,
    required this.terminatedLeases,
    required this.expiringLeases,
    required this.totalMonthlyRent,
    required this.totalSecurityDeposits,
    required this.averageMonthlyRent,
    required this.occupancyRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalLeases': totalLeases,
      'activeLeases': activeLeases,
      'expiredLeases': expiredLeases,
      'draftLeases': draftLeases,
      'terminatedLeases': terminatedLeases,
      'expiringLeases': expiringLeases,
      'totalMonthlyRent': totalMonthlyRent,
      'totalSecurityDeposits': totalSecurityDeposits,
      'averageMonthlyRent': averageMonthlyRent,
      'occupancyRate': occupancyRate,
    };
  }

  factory LeaseStatistics.fromJson(Map<String, dynamic> json) {
    return LeaseStatistics(
      totalLeases: json['totalLeases'] ?? 0,
      activeLeases: json['activeLeases'] ?? 0,
      expiredLeases: json['expiredLeases'] ?? 0,
      draftLeases: json['draftLeases'] ?? 0,
      terminatedLeases: json['terminatedLeases'] ?? 0,
      expiringLeases: json['expiringLeases'] ?? 0,
      totalMonthlyRent: (json['totalMonthlyRent'] ?? 0).toDouble(),
      totalSecurityDeposits: (json['totalSecurityDeposits'] ?? 0).toDouble(),
      averageMonthlyRent: (json['averageMonthlyRent'] ?? 0).toDouble(),
      occupancyRate: (json['occupancyRate'] ?? 0).toDouble(),
    );
  }
}
