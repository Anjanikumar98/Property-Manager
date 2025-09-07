// lib/features/leases/domain/services/lease_status_service.dart

import '../entities/lease.dart';

class LeaseStatusService {
  static const int defaultNoticePerioD = 30; // days

  /// Updates lease status based on current date and lease dates
  static LeaseStatus calculateLeaseStatus(Lease lease, DateTime currentDate) {
    // If lease is already terminated, keep it terminated
    if (lease.status == LeaseStatus.terminated) {
      return LeaseStatus.terminated;
    }

    // Check if lease is renewed (this would be set manually)
    if (lease.status == LeaseStatus.renewed) {
      return LeaseStatus.renewed;
    }

    // Calculate status based on dates
    if (currentDate.isBefore(lease.startDate)) {
      return LeaseStatus.draft;
    } else if (currentDate.isAfter(lease.endDate)) {
      return LeaseStatus.expired;
    } else {
      return LeaseStatus.active;
    }
  }

  /// Calculates if lease is expiring soon based on notice period
  static bool isLeaseExpiringSoon(Lease lease, DateTime currentDate) {
    if (lease.status != LeaseStatus.active) return false;

    final daysUntilExpiry = lease.endDate.difference(currentDate).inDays;
    return daysUntilExpiry <= lease.noticePeriodDays;
  }

  /// Calculates remaining days in lease
  static int calculateRemainingDays(Lease lease, DateTime currentDate) {
    if (currentDate.isAfter(lease.endDate)) return 0;
    return lease.endDate.difference(currentDate).inDays;
  }

  /// Calculates total days in lease
  static int calculateTotalDays(Lease lease) {
    return lease.endDate.difference(lease.startDate).inDays;
  }

  /// Calculates lease progress as percentage (0.0 to 1.0)
  static double calculateLeaseProgress(Lease lease, DateTime currentDate) {
    final totalDays = calculateTotalDays(lease);
    if (totalDays <= 0) return 0.0;

    final elapsedDays = currentDate.difference(lease.startDate).inDays;
    final progress = elapsedDays / totalDays;

    return progress.clamp(0.0, 1.0);
  }

  /// Updates all calculated fields for a lease
  static Lease updateCalculatedFields(Lease lease, [DateTime? currentDate]) {
    final now = currentDate ?? DateTime.now();

    final status = calculateLeaseStatus(lease, now);
    final isActive = status == LeaseStatus.active;
    final totalDays = calculateTotalDays(lease);
    final remainingDays = calculateRemainingDays(lease, now);
    final isExpiringSoon = isLeaseExpiringSoon(lease, now);

    return lease.copyWith(
      status: status,
      isActive: isActive,
      totalDays: totalDays,
      remainingDays: remainingDays,
      isExpiringSoon: isExpiringSoon,
    );
  }

  /// Gets all leases that need status updates
  static List<Lease> updateLeaseStatuses(
    List<Lease> leases, [
    DateTime? currentDate,
  ]) {
    final now = currentDate ?? DateTime.now();

    return leases.map((lease) => updateCalculatedFields(lease, now)).toList();
  }

  /// Filters leases by status
  static List<Lease> filterLeasesByStatus(
    List<Lease> leases,
    LeaseStatus status,
  ) {
    return leases.where((lease) => lease.status == status).toList();
  }

  /// Gets active leases
  static List<Lease> getActiveLeases(List<Lease> leases) {
    return filterLeasesByStatus(leases, LeaseStatus.active);
  }

  /// Gets expiring leases
  static List<Lease> getExpiringLeases(List<Lease> leases) {
    return leases.where((lease) => lease.isExpiringSoon).toList();
  }

  /// Gets expired leases
  static List<Lease> getExpiredLeases(List<Lease> leases) {
    return filterLeasesByStatus(leases, LeaseStatus.expired);
  }

  /// Gets draft leases
  static List<Lease> getDraftLeases(List<Lease> leases) {
    return filterLeasesByStatus(leases, LeaseStatus.draft);
  }

  /// Gets terminated leases
  static List<Lease> getTerminatedLeases(List<Lease> leases) {
    return filterLeasesByStatus(leases, LeaseStatus.terminated);
  }

  /// Validates lease renewal parameters
  static String? validateRenewalParams({
    required DateTime currentEndDate,
    required DateTime newEndDate,
    required double newMonthlyRent,
    required double newSecurityDeposit,
  }) {
    if (newEndDate.isBefore(currentEndDate) ||
        newEndDate.isAtSameMomentAs(currentEndDate)) {
      return 'New end date must be after current end date';
    }

    if (newMonthlyRent <= 0) {
      return 'Monthly rent must be greater than 0';
    }

    if (newSecurityDeposit < 0) {
      return 'Security deposit cannot be negative';
    }

    final daysDifference = newEndDate.difference(currentEndDate).inDays;
    if (daysDifference < 30) {
      return 'Renewal period must be at least 30 days';
    }

    return null; // Valid
  }

  /// Validates lease termination parameters
  static String? validateTerminationParams({
    required DateTime startDate,
    required DateTime endDate,
    required DateTime terminationDate,
    required int noticePeriodDays,
  }) {
    if (terminationDate.isBefore(startDate)) {
      return 'Termination date cannot be before lease start date';
    }

    if (terminationDate.isAfter(endDate)) {
      return 'Termination date cannot be after lease end date';
    }

    // Check if proper notice was given (for future terminations)
    final now = DateTime.now();
    if (terminationDate.isAfter(now)) {
      final noticeDays = terminationDate.difference(now).inDays;
      if (noticeDays < noticePeriodDays) {
        return 'Insufficient notice period. Required: $noticePeriodDays days, given: $noticeDays days';
      }
    }

    return null; // Valid
  }

  /// Calculates financial impact of early termination
  static LeaseTerminationSummary calculateTerminationSummary({
    required Lease lease,
    required DateTime terminationDate,
    required bool refundSecurityDeposit,
    required double deductions,
  }) {
    final daysEarly =
        lease.endDate
            .difference(terminationDate)
            .inDays
            .clamp(0, double.infinity)
            .toInt();
    final daysCompleted =
        terminationDate
            .difference(lease.startDate)
            .inDays
            .clamp(0, double.infinity)
            .toInt();

    // Calculate prorated rent (if terminating mid-month)
    final lastDayOfMonth = DateTime(
      terminationDate.year,
      terminationDate.month + 1,
      0,
    );
    final isEndOfMonth = terminationDate.day == lastDayOfMonth.day;

    double proratedRent = 0.0;
    if (!isEndOfMonth && terminationDate.day > 1) {
      final daysInMonth = lastDayOfMonth.day;
      final daysUsed = terminationDate.day - 1;
      proratedRent = (lease.monthlyRent / daysInMonth) * daysUsed;
    }

    // Calculate security deposit refund
    double securityDepositRefund = 0.0;
    if (refundSecurityDeposit) {
      securityDepositRefund = (lease.securityDeposit - deductions).clamp(
        0.0,
        lease.securityDeposit,
      );
    }

    return LeaseTerminationSummary(
      originalEndDate: lease.endDate,
      terminationDate: terminationDate,
      daysEarly: daysEarly,
      daysCompleted: daysCompleted,
      proratedRent: proratedRent,
      securityDepositRefund: securityDepositRefund,
      deductions: deductions,
    );
  }
}

class LeaseTerminationSummary {
  final DateTime originalEndDate;
  final DateTime terminationDate;
  final int daysEarly;
  final int daysCompleted;
  final double proratedRent;
  final double securityDepositRefund;
  final double deductions;

  const LeaseTerminationSummary({
    required this.originalEndDate,
    required this.terminationDate,
    required this.daysEarly,
    required this.daysCompleted,
    required this.proratedRent,
    required this.securityDepositRefund,
    required this.deductions,
  });

  double get totalRefund => securityDepositRefund + proratedRent;
  bool get isEarlyTermination => daysEarly > 0;
}
