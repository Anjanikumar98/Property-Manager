// lib/features/tenants/data/models/tenant_model.dart
import '../../domain/entities/tenant.dart';

class TenantModel extends Tenant {
  const TenantModel({
    super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    super.emergencyContactName,
    super.emergencyContactPhone,
    super.address,
    super.dateOfBirth,
    super.occupation,
    super.monthlyIncome,
    super.idNumber,
    super.notes,
    super.propertyIds,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      emergencyContactName: json['emergencyContactName'],
      emergencyContactPhone: json['emergencyContactPhone'],
      address: json['address'],
      dateOfBirth:
          json['dateOfBirth'] != null
              ? DateTime.parse(json['dateOfBirth'])
              : null,
      occupation: json['occupation'],
      monthlyIncome: json['monthlyIncome']?.toDouble(),
      idNumber: json['idNumber'],
      notes: json['notes'],
      propertyIds:
          json['propertyIds'] != null
              ? List<String>.from(json['propertyIds'])
              : [],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'address': address,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'occupation': occupation,
      'monthlyIncome': monthlyIncome,
      'idNumber': idNumber,
      'notes': notes,
      'propertyIds': propertyIds,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TenantModel.fromEntity(Tenant tenant) {
    return TenantModel(
      id: tenant.id,
      firstName: tenant.firstName,
      lastName: tenant.lastName,
      email: tenant.email,
      phone: tenant.phone,
      emergencyContactName: tenant.emergencyContactName,
      emergencyContactPhone: tenant.emergencyContactPhone,
      address: tenant.address,
      dateOfBirth: tenant.dateOfBirth,
      occupation: tenant.occupation,
      monthlyIncome: tenant.monthlyIncome,
      idNumber: tenant.idNumber,
      notes: tenant.notes,
      propertyIds: tenant.propertyIds,
      isActive: tenant.isActive,
      createdAt: tenant.createdAt,
      updatedAt: tenant.updatedAt,
    );
  }

  @override
  TenantModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? address,
    DateTime? dateOfBirth,
    String? occupation,
    double? monthlyIncome,
    String? idNumber,
    String? notes,
    List<String>? propertyIds,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TenantModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      occupation: occupation ?? this.occupation,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      idNumber: idNumber ?? this.idNumber,
      notes: notes ?? this.notes,
      propertyIds: propertyIds ?? this.propertyIds,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
