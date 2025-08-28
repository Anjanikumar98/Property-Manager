// lib/features/payments/data/models/payment_model.dart
import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.leaseId,
    required super.propertyId,
    required super.tenantId,
    required super.amount,
    required super.paymentDate,
    required super.dueDate,
    required super.paymentMethod,
    required super.paymentType,
    required super.status,
    super.notes,
    super.receiptNumber,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      leaseId: json['lease_id'] as String,
      propertyId: json['property_id'] as String,
      tenantId: json['tenant_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(json['payment_date'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      paymentMethod: json['payment_method'] as String,
      paymentType: json['payment_type'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      receiptNumber: json['receipt_number'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lease_id': leaseId,
      'property_id': propertyId,
      'tenant_id': tenantId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'payment_method': paymentMethod,
      'payment_type': paymentType,
      'status': status,
      'notes': notes,
      'receipt_number': receiptNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory PaymentModel.fromEntity(Payment payment) {
    return PaymentModel(
      id: payment.id,
      leaseId: payment.leaseId,
      propertyId: payment.propertyId,
      tenantId: payment.tenantId,
      amount: payment.amount,
      paymentDate: payment.paymentDate,
      dueDate: payment.dueDate,
      paymentMethod: payment.paymentMethod,
      paymentType: payment.paymentType,
      status: payment.status,
      notes: payment.notes,
      receiptNumber: payment.receiptNumber,
      createdAt: payment.createdAt,
      updatedAt: payment.updatedAt,
    );
  }
}

