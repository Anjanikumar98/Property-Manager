import 'package:equatable/equatable.dart';

class Lease extends Equatable {
  final String id;
  final String propertyId;
  final String tenantId;
  final String propertyName;
  final String tenantName;
  final LeaseType leaseType;
  final LeaseStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final double monthlyRent;
  final double securityDeposit;
  final RentFrequency rentFrequency;
  final int noticePeriodDays;
  final String? specialTerms;
  final String? notes;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Calculated fields
  final int totalDays;
  final int remainingDays;
  final bool isActive;
  final bool isExpiringSoon;

  const Lease({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.propertyName,
    required this.tenantName,
    required this.leaseType,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    required this.securityDeposit,
    required this.rentFrequency,
    required this.noticePeriodDays,
    this.specialTerms,
    this.notes,
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
    required this.totalDays,
    required this.remainingDays,
    required this.isActive,
    required this.isExpiringSoon,
  });

  // Calculate total rent for the lease period
  double get totalRentAmount {
    final months = ((endDate.difference(startDate).inDays) / 30).ceil();
    return monthlyRent * months;
  }

  // Calculate rent per frequency
  double get rentPerFrequency {
    switch (rentFrequency) {
      case RentFrequency.monthly:
        return monthlyRent;
      case RentFrequency.quarterly:
        return monthlyRent * 3;
      case RentFrequency.biannual:
        return monthlyRent * 6;
      case RentFrequency.annual:
        return monthlyRent * 12;
    }
  }

  // Get progress percentage (0.0 to 1.0)
  double get progressPercentage {
    if (totalDays <= 0) return 0.0;
    final elapsed = totalDays - remainingDays;
    return (elapsed / totalDays).clamp(0.0, 1.0);
  }

  // Check if lease is expiring within warning period
  bool get isExpiring {
    return isActive && remainingDays <= noticePeriodDays;
  }

  Lease copyWith({
    String? id,
    String? propertyId,
    String? tenantId,
    String? propertyName,
    String? tenantName,
    LeaseType? leaseType,
    LeaseStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    double? monthlyRent,
    double? securityDeposit,
    RentFrequency? rentFrequency,
    int? noticePeriodDays,
    String? specialTerms,
    String? notes,
    List<String>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalDays,
    int? remainingDays,
    bool? isActive,
    bool? isExpiringSoon,
  }) {
    return Lease(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      tenantId: tenantId ?? this.tenantId,
      propertyName: propertyName ?? this.propertyName,
      tenantName: tenantName ?? this.tenantName,
      leaseType: leaseType ?? this.leaseType,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      rentFrequency: rentFrequency ?? this.rentFrequency,
      noticePeriodDays: noticePeriodDays ?? this.noticePeriodDays,
      specialTerms: specialTerms ?? this.specialTerms,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalDays: totalDays ?? this.totalDays,
      remainingDays: remainingDays ?? this.remainingDays,
      isActive: isActive ?? this.isActive,
      isExpiringSoon: isExpiringSoon ?? this.isExpiringSoon,
    );
  }

  @override
  List<Object?> get props => [
    id,
    propertyId,
    tenantId,
    propertyName,
    tenantName,
    leaseType,
    status,
    startDate,
    endDate,
    monthlyRent,
    securityDeposit,
    rentFrequency,
    noticePeriodDays,
    specialTerms,
    notes,
    attachments,
    createdAt,
    updatedAt,
    totalDays,
    remainingDays,
    isActive,
    isExpiringSoon,
  ];
}

enum LeaseStatus { draft, active, expired, terminated, renewed }

enum LeaseType { residential, commercial, shortTerm, longTerm }

enum RentFrequency { monthly, quarterly, biannual, annual }
