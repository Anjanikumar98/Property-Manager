// lib/features/tenants/data/models/tenant_model.dart
import '../../domain/entities/tenant.dart';

class TenantModel extends Tenant {
  const TenantModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    super.alternatePhone,
    required super.address,
    required super.city,
    required super.state,
    required super.zipCode,
    super.occupation,
    super.company,
    super.monthlyIncome,
    super.emergencyContactName,
    super.emergencyContactPhone,
    super.idProofType,
    super.idProofNumber,
    super.profileImagePath,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      alternatePhone: json['alternate_phone'] as String?,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zip_code'] as String,
      occupation: json['occupation'] as String?,
      company: json['company'] as String?,
      monthlyIncome: (json['monthly_income'] as num?)?.toDouble(),
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      idProofType: json['id_proof_type'] as String?,
      idProofNumber: json['id_proof_number'] as String?,
      profileImagePath: json['profile_image_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'alternate_phone': alternatePhone,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'occupation': occupation,
      'company': company,
      'monthly_income': monthlyIncome,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'id_proof_type': idProofType,
      'id_proof_number': idProofNumber,
      'profile_image_path': profileImagePath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TenantModel.fromEntity(Tenant tenant) {
    return TenantModel(
      id: tenant.id,
      firstName: tenant.firstName,
      lastName: tenant.lastName,
      email: tenant.email,
      phone: tenant.phone,
      alternatePhone: tenant.alternatePhone,
      address: tenant.address,
      city: tenant.city,
      state: tenant.state,
      zipCode: tenant.zipCode,
      occupation: tenant.occupation,
      company: tenant.company,
      monthlyIncome: tenant.monthlyIncome,
      emergencyContactName: tenant.emergencyContactName,
      emergencyContactPhone: tenant.emergencyContactPhone,
      idProofType: tenant.idProofType,
      createdAt: tenant.createdAt,
      updatedAt: tenant.updatedAt,
    );
  }
}

