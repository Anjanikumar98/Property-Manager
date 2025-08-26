// lib/features/leases/domain/entities/lease.dart
import 'package:equatable/equatable.dart';

class Lease extends Equatable {
  final String id;
  final String propertyId;
  final String tenantId;
  final DateTime startDate;
  final DateTime endDate;
  final double monthlyRent;
  final double securityDeposit;
  final String status; // active, expired, terminated
  final String terms;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Lease({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    required this.securityDeposit,
    required this.status,
    required this.terms,
    required this.createdAt,
    required this.updatedAt,
  });

  Lease copyWith({
    String? id,
    String? propertyId,
    String? tenantId,
    DateTime? startDate,
    DateTime? endDate,
    double? monthlyRent,
    double? securityDeposit,
    String? status,
    String? terms,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Lease(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      tenantId: tenantId ?? this.tenantId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      status: status ?? this.status,
      terms: terms ?? this.terms,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    propertyId,
    tenantId,
    startDate,
    endDate,
    monthlyRent,
    securityDeposit,
    status,
    terms,
    createdAt,
    updatedAt,
  ];
}
