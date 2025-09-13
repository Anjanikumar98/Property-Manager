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
  final List<String> propertyIds;
  final TenantStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // New fields for enhanced functionality
  final List<ContactInfo> contactHistory;
  final List<AddressHistory> addressHistory;
  final List<CommunicationLog> communicationHistory;
  final List<PaymentHistory> paymentHistory;
  final DateTime? leaseStartDate;
  final DateTime? leaseEndDate;
  final String? previousTenantId; // For tracking tenant relationships

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
    this.status = TenantStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.contactHistory = const [],
    this.addressHistory = const [],
    this.communicationHistory = const [],
    this.paymentHistory = const [],
    this.leaseStartDate,
    this.leaseEndDate,
    this.previousTenantId,
  });

  String get fullName => '$firstName $lastName';

  bool get isActive => status == TenantStatus.active;

  bool get isFormer => status == TenantStatus.former;

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
    status,
    createdAt,
    updatedAt,
    contactHistory,
    addressHistory,
    communicationHistory,
    paymentHistory,
    leaseStartDate,
    leaseEndDate,
    previousTenantId,
  ];
}

enum TenantStatus { active, inactive, former, pending, suspended }

class ContactInfo extends Equatable {
  final String? id;
  final String type; // 'email', 'phone', 'emergency_contact'
  final String value;
  final String? description;
  final DateTime validFrom;
  final DateTime? validTo;
  final DateTime createdAt;

  const ContactInfo({
    this.id,
    required this.type,
    required this.value,
    this.description,
    required this.validFrom,
    this.validTo,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    value,
    description,
    validFrom,
    validTo,
    createdAt,
  ];
}

class AddressHistory extends Equatable {
  final String? id;
  final String address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final DateTime validFrom;
  final DateTime? validTo;
  final DateTime createdAt;

  const AddressHistory({
    this.id,
    required this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    required this.validFrom,
    this.validTo,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    address,
    city,
    state,
    zipCode,
    country,
    validFrom,
    validTo,
    createdAt,
  ];
}

class CommunicationLog extends Equatable {
  final String? id;
  final String tenantId;
  final CommunicationType type;
  final String subject;
  final String? content;
  final CommunicationMethod method;
  final DateTime communicatedAt;
  final String? initiatedBy;
  final Map<String, dynamic>? metadata;

  const CommunicationLog({
    this.id,
    required this.tenantId,
    required this.type,
    required this.subject,
    this.content,
    required this.method,
    required this.communicatedAt,
    this.initiatedBy,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    tenantId,
    type,
    subject,
    content,
    method,
    communicatedAt,
    initiatedBy,
    metadata,
  ];
}

enum CommunicationType {
  inquiry,
  complaint,
  maintenance,
  payment,
  lease,
  general,
  emergency,
}

enum CommunicationMethod { email, phone, inPerson, sms, mail, other }

class PaymentHistory extends Equatable {
  final String? id;
  final String tenantId;
  final double amount;
  final String type; // 'rent', 'deposit', 'fee', 'refund'
  final String? description;
  final DateTime paidAt;
  final PaymentMethod method;
  final PaymentStatus status;
  final String? transactionId;
  final Map<String, dynamic>? metadata;

  const PaymentHistory({
    this.id,
    required this.tenantId,
    required this.amount,
    required this.type,
    this.description,
    required this.paidAt,
    required this.method,
    required this.status,
    this.transactionId,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    tenantId,
    amount,
    type,
    description,
    paidAt,
    method,
    status,
    transactionId,
    metadata,
  ];
}

enum PaymentMethod { cash, check, creditCard, debitCard, bankTransfer, other, onlinePayment }

enum PaymentStatus { pending, completed, failed, refunded, disputed, paid, overdue, partial, cancelled, partiallyPaid }
