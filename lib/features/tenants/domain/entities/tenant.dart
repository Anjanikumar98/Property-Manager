// lib/features/tenants/domain/entities/tenant.dart
import 'package:equatable/equatable.dart';

class Tenant extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? alternatePhone;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String? occupation;
  final String? company;
  final double? monthlyIncome;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? idProofType;
  final String? idProofNumber;
  final String? profileImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Tenant({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.alternatePhone,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    this.occupation,
    this.company,
    this.monthlyIncome,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.idProofType,
    this.idProofNumber,
    this.profileImagePath,
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
    String? alternatePhone,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? occupation,
    String? company,
    double? monthlyIncome,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? idProofType,
    String? idProofNumber,
    String? profileImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tenant(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      occupation: occupation ?? this.occupation,
      company: company ?? this.company,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      idProofType: idProofType ?? this.idProofType,
      idProofNumber: idProofNumber ?? this.idProofNumber,
      profileImagePath: profileImagePath ?? this.profileImagePath,
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
    alternatePhone,
    address,
    city,
    state,
    zipCode,
    occupation,
    company,
    monthlyIncome,
    emergencyContactName,
    emergencyContactPhone,
    idProofType,
    idProofNumber,
    profileImagePath,
    createdAt,
    updatedAt,
  ];
}

