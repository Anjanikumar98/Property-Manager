// lib/features/tenants/domain/entities/tenant.dart
import 'package:equatable/equatable.dart';

class Tenant extends Equatable {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? address;
  final DateTime? dateOfBirth;
  final String? occupation;
  final double? monthlyIncome;
  final String? idNumber;
  final String? notes;
  final List<String> propertyIds; // Properties this tenant is associated with
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Tenant({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.address,
    this.dateOfBirth,
    this.occupation,
    this.monthlyIncome,
    this.idNumber,
    this.notes,
    this.propertyIds = const [],
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  Tenant copyWith({
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
    return Tenant(
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

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phone,
    emergencyContactName,
    emergencyContactPhone,
    address,
    dateOfBirth,
    occupation,
    monthlyIncome,
    idNumber,
    notes,
    propertyIds,
    isActive,
    createdAt,
    updatedAt,
  ];
}


