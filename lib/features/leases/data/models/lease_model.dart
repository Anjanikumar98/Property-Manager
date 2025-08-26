// lib/features/leases/data/models/lease_model.dart
import '../../domain/entities/lease.dart';

class LeaseModel extends Lease {
  const LeaseModel({
    required super.id,
    required super.propertyId,
    required super.tenantId,
    required super.startDate,
    required super.endDate,
    required super.monthlyRent,
    required super.securityDeposit,
    required super.status,
    required super.terms,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LeaseModel.fromJson(Map<String, dynamic> json) {
    return LeaseModel(
      id: json['id'] as String,
      propertyId: json['property_id'] as String,
      tenantId: json['tenant_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      monthlyRent: (json['monthly_rent'] as num).toDouble(),
      securityDeposit: (json['security_deposit'] as num).toDouble(),
      status: json['status'] as String,
      terms: json['terms'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'tenant_id': tenantId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'monthly_rent': monthlyRent,
      'security_deposit': securityDeposit,
      'status': status,
      'terms': terms,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory LeaseModel.fromEntity(Lease lease) {
    return LeaseModel(
      id: lease.id,
      propertyId: lease.propertyId,
      tenantId: lease.tenantId,
      startDate: lease.startDate,
      endDate: lease.endDate,
      monthlyRent: lease.monthlyRent,
      securityDeposit: lease.securityDeposit,
      status: lease.status,
      terms: lease.terms,
      createdAt: lease.createdAt,
      updatedAt: lease.updatedAt,
    );
  }
}
