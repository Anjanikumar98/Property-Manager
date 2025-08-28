// lib/features/payments/domain/entities/payment.dart
import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String leaseId;
  final String propertyId;
  final String tenantId;
  final double amount;
  final DateTime paymentDate;
  final DateTime dueDate;
  final String paymentMethod; // cash, bank_transfer, cheque, online
  final String paymentType; // rent, deposit, maintenance, other
  final String status; // paid, pending, overdue, partial
  final String? notes;
  final String? receiptNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Payment({
    required this.id,
    required this.leaseId,
    required this.propertyId,
    required this.tenantId,
    required this.amount,
    required this.paymentDate,
    required this.dueDate,
    required this.paymentMethod,
    required this.paymentType,
    required this.status,
    this.notes,
    this.receiptNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  Payment copyWith({
    String? id,
    String? leaseId,
    String? propertyId,
    String? tenantId,
    double? amount,
    DateTime? paymentDate,
    DateTime? dueDate,
    String? paymentMethod,
    String? paymentType,
    String? status,
    String? notes,
    String? receiptNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      leaseId: leaseId ?? this.leaseId,
      propertyId: propertyId ?? this.propertyId,
      tenantId: tenantId ?? this.tenantId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      dueDate: dueDate ?? this.dueDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentType: paymentType ?? this.paymentType,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    leaseId,
    propertyId,
    tenantId,
    amount,
    paymentDate,
    dueDate,
    paymentMethod,
    paymentType,
    status,
    notes,
    receiptNumber,
    createdAt,
    updatedAt,
  ];
}
