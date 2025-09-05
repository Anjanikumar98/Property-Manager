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
    super.status = TenantStatus.active,
    required super.createdAt,
    required super.updatedAt,
    super.contactHistory,
    super.addressHistory,
    super.communicationHistory,
    super.paymentHistory,
    super.leaseStartDate,
    super.leaseEndDate,
    super.previousTenantId,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: json['id']?.toString(),
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      emergencyContactName: json['emergencyContactName'],
      emergencyContactPhone: json['emergencyContactPhone'],
      address: json['address'],
      dateOfBirth:
          json['dateOfBirth'] != null
              ? DateTime.tryParse(json['dateOfBirth'])
              : null,
      occupation: json['occupation'],
      monthlyIncome:
          json['monthlyIncome'] != null
              ? double.tryParse(json['monthlyIncome'].toString())
              : null,
      idNumber: json['idNumber'],
      notes: json['notes'],
      propertyIds:
          json['propertyIds'] != null
              ? (json['propertyIds'] as String)
                  .split(',')
                  .where((id) => id.isNotEmpty)
                  .toList()
              : [],
      status: _parseStatus(json['isActive']),
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
      leaseStartDate:
          json['leaseStartDate'] != null
              ? DateTime.tryParse(json['leaseStartDate'])
              : null,
      leaseEndDate:
          json['leaseEndDate'] != null
              ? DateTime.tryParse(json['leaseEndDate'])
              : null,
      previousTenantId: json['previousTenantId'],
      // Note: Complex fields like contactHistory, addressHistory, etc.
      // would typically be stored in separate tables and joined
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
      'propertyIds': propertyIds.join(','),
      'isActive': status == TenantStatus.active ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'leaseStartDate': leaseStartDate?.toIso8601String(),
      'leaseEndDate': leaseEndDate?.toIso8601String(),
      'previousTenantId': previousTenantId,
    };
  }

  static TenantStatus _parseStatus(dynamic isActive) {
    if (isActive == 1 || isActive == true) {
      return TenantStatus.active;
    }
    return TenantStatus.inactive;
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
      status: tenant.status,
      createdAt: tenant.createdAt,
      updatedAt: tenant.updatedAt,
      contactHistory: tenant.contactHistory,
      addressHistory: tenant.addressHistory,
      communicationHistory: tenant.communicationHistory,
      paymentHistory: tenant.paymentHistory,
      leaseStartDate: tenant.leaseStartDate,
      leaseEndDate: tenant.leaseEndDate,
      previousTenantId: tenant.previousTenantId,
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
    TenantStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ContactInfo>? contactHistory,
    List<AddressHistory>? addressHistory,
    List<CommunicationLog>? communicationHistory,
    List<PaymentHistory>? paymentHistory,
    DateTime? leaseStartDate,
    DateTime? leaseEndDate,
    String? previousTenantId,
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
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contactHistory: contactHistory ?? this.contactHistory,
      addressHistory: addressHistory ?? this.addressHistory,
      communicationHistory: communicationHistory ?? this.communicationHistory,
      paymentHistory: paymentHistory ?? this.paymentHistory,
      leaseStartDate: leaseStartDate ?? this.leaseStartDate,
      leaseEndDate: leaseEndDate ?? this.leaseEndDate,
      previousTenantId: previousTenantId ?? this.previousTenantId,
    );
  }
}

