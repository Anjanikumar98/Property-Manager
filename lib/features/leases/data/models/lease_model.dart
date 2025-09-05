import '../../domain/entities/lease.dart';

class LeaseModel extends Lease {
  const LeaseModel({
    required super.id,
    required super.propertyId,
    required super.tenantId,
    required super.propertyName,
    required super.tenantName,
    required super.leaseType,
    required super.status,
    required super.startDate,
    required super.endDate,
    required super.monthlyRent,
    required super.securityDeposit,
    required super.rentFrequency,
    required super.noticePeriodDays,
    super.specialTerms,
    super.notes,
    super.attachments,
    required super.createdAt,
    required super.updatedAt,
    required super.totalDays,
    required super.remainingDays,
    required super.isActive,
    required super.isExpiringSoon,
  });

  factory LeaseModel.fromJson(Map<String, dynamic> json) {
    final startDate = DateTime.parse(json['startDate']);
    final endDate = DateTime.parse(json['endDate']);
    final now = DateTime.now();

    final totalDays = endDate.difference(startDate).inDays;
    final remainingDays = endDate.difference(now).inDays;
    final status = LeaseStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => LeaseStatus.draft,
    );
    final isActive =
        status == LeaseStatus.active &&
        now.isAfter(startDate) &&
        now.isBefore(endDate);
    final noticePeriod = json['noticePeriodDays'] ?? 30;
    final isExpiringSoon = isActive && remainingDays <= noticePeriod;

    return LeaseModel(
      id: json['id'],
      propertyId: json['propertyId'],
      tenantId: json['tenantId'],
      propertyName: json['propertyName'],
      tenantName: json['tenantName'],
      leaseType: LeaseType.values.firstWhere(
        (e) => e.name == json['leaseType'],
        orElse: () => LeaseType.residential,
      ),
      status: status,
      startDate: startDate,
      endDate: endDate,
      monthlyRent: (json['monthlyRent'] as num).toDouble(),
      securityDeposit: (json['securityDeposit'] as num).toDouble(),
      rentFrequency: RentFrequency.values.firstWhere(
        (e) => e.name == json['rentFrequency'],
        orElse: () => RentFrequency.monthly,
      ),
      noticePeriodDays: noticePeriod,
      specialTerms: json['specialTerms'],
      notes: json['notes'],
      attachments: List<String>.from(json['attachments'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      totalDays: totalDays,
      remainingDays: remainingDays,
      isActive: isActive,
      isExpiringSoon: isExpiringSoon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'tenantId': tenantId,
      'propertyName': propertyName,
      'tenantName': tenantName,
      'leaseType': leaseType.name,
      'status': status.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'monthlyRent': monthlyRent,
      'securityDeposit': securityDeposit,
      'rentFrequency': rentFrequency.name,
      'noticePeriodDays': noticePeriodDays,
      'specialTerms': specialTerms,
      'notes': notes,
      'attachments': attachments,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory LeaseModel.fromEntity(Lease lease) {
    return LeaseModel(
      id: lease.id,
      propertyId: lease.propertyId,
      tenantId: lease.tenantId,
      propertyName: lease.propertyName,
      tenantName: lease.tenantName,
      leaseType: lease.leaseType,
      status: lease.status,
      startDate: lease.startDate,
      endDate: lease.endDate,
      monthlyRent: lease.monthlyRent,
      securityDeposit: lease.securityDeposit,
      rentFrequency: lease.rentFrequency,
      noticePeriodDays: lease.noticePeriodDays,
      specialTerms: lease.specialTerms,
      notes: lease.notes,
      attachments: lease.attachments,
      createdAt: lease.createdAt,
      updatedAt: lease.updatedAt,
      totalDays: lease.totalDays,
      remainingDays: lease.remainingDays,
      isActive: lease.isActive,
      isExpiringSoon: lease.isExpiringSoon,
    );
  }

  // Helper method to create a new lease
  factory LeaseModel.create({
    required String propertyId,
    required String tenantId,
    required String propertyName,
    required String tenantName,
    required LeaseType leaseType,
    required DateTime startDate,
    required DateTime endDate,
    required double monthlyRent,
    required double securityDeposit,
    required RentFrequency rentFrequency,
    required int noticePeriodDays,
    String? specialTerms,
    String? notes,
    List<String>? attachments,
  }) {
    final now = DateTime.now();
    final totalDays = endDate.difference(startDate).inDays;
    final remainingDays = endDate.difference(now).inDays;
    final isActive = now.isAfter(startDate) && now.isBefore(endDate);
    final isExpiringSoon = isActive && remainingDays <= noticePeriodDays;

    return LeaseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      propertyId: propertyId,
      tenantId: tenantId,
      propertyName: propertyName,
      tenantName: tenantName,
      leaseType: leaseType,
      status:
          now.isBefore(startDate)
              ? LeaseStatus.draft
              : (isActive ? LeaseStatus.active : LeaseStatus.expired),
      startDate: startDate,
      endDate: endDate,
      monthlyRent: monthlyRent,
      securityDeposit: securityDeposit,
      rentFrequency: rentFrequency,
      noticePeriodDays: noticePeriodDays,
      specialTerms: specialTerms,
      notes: notes,
      attachments: attachments ?? [],
      createdAt: now,
      updatedAt: now,
      totalDays: totalDays,
      remainingDays: remainingDays,
      isActive: isActive,
      isExpiringSoon: isExpiringSoon,
    );
  }
}
